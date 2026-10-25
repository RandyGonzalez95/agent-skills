"""Regression checks for coverage failures, not tests of a user's application."""

import copy
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

from check_authorization_coverage import evaluate, InvalidInput, REQUIRED_CHECKS


def fixture():
    cases = [{"id": expectation, "expectation": expectation, "checks": sorted(checks)}
             for expectation, checks in REQUIRED_CHECKS.items() if expectation != "filtered"]
    inventory = {
        "schema_version": 1, "scope": "disposable fixture",
        "discovery": {"sources": ["test router"], "gaps": []},
        "operations": [{"id": "GET /records/{id}", "source": "fixture:1",
                        "applicability": "applicable", "policy": "Owner only", "cases": cases}],
    }
    results = {
        "schema_version": 1, "inventory_sha256": "fixture-hash",
        "command": "native-test-runner", "completed": True, "exit_code": 0,
        "cases": [{"operation": "GET /records/{id}", "case": case["id"], "status": "pass",
                   "checks": case["checks"][:], "evidence": "synthetic assertion log"}
                  for case in cases],
    }
    return inventory, results


class CoverageTests(unittest.TestCase):
    def setUp(self):
        self.inventory, self.results = fixture()

    def run_gate(self):
        return evaluate(self.inventory, self.results, "fixture-hash")

    def test_complete_allowed_and_denied(self):
        summary, code = self.run_gate()
        self.assertEqual(code, 0)
        self.assertEqual(summary["fully_passing_operations"], 1)
        self.assertEqual(summary["successful_cases"], 2)

    def test_missing_case_and_new_endpoint_fail(self):
        self.results["cases"].pop()
        operation = copy.deepcopy(self.inventory["operations"][0])
        operation["id"] = "DELETE /records/{id}"
        self.inventory["operations"].append(operation)
        summary, code = self.run_gate()
        self.assertEqual(code, 1)
        self.assertEqual(summary["missing_cases"], 3)
        self.assertEqual(summary["fully_passing_operations"], 0)

    def test_fail_skip_blocked_error_never_pass(self):
        for status in ("fail", "skip", "blocked", "error"):
            with self.subTest(status=status):
                self.results["cases"][1]["status"] = status
                summary, code = self.run_gate()
                self.assertEqual(code, 1)
                self.assertEqual(summary["fully_passing_operations"], 0)

    def test_status_only_assertion_does_not_pass(self):
        self.results["cases"][1]["checks"] = ["denial"]
        summary, code = self.run_gate()
        self.assertEqual(code, 1)
        self.assertEqual(summary["issues"][0]["kind"], "missing_assertions")

    def test_discovery_gap_and_aborted_run_fail(self):
        self.inventory["discovery"]["gaps"] = ["Plugin routes unavailable"]
        self.results["completed"] = False
        summary, code = self.run_gate()
        self.assertEqual(code, 1)
        self.assertEqual({issue["kind"] for issue in summary["issues"]},
                         {"discovery_gap", "incomplete_run"})

    def test_exclusions_need_reason_and_are_not_passes(self):
        operation = self.inventory["operations"][0]
        operation.update(applicability="not_applicable", cases=[])
        self.results["cases"] = []
        with self.assertRaises(InvalidInput):
            self.run_gate()
        operation["reason"] = "Public health response contains no object data"
        summary, code = self.run_gate()
        self.assertEqual(code, 0)
        self.assertEqual(summary["status"], "not_applicable")
        self.assertEqual(summary["fully_passing_operations"], 0)

    def test_runner_failure_outside_recorded_cases_fails(self):
        self.results["exit_code"] = 1
        summary, code = self.run_gate()
        self.assertEqual(code, 1)
        self.assertEqual(summary["issues"][0]["kind"], "runner_failure")

    def test_blocked_operation_remains_gap_even_with_passing_cases(self):
        self.inventory["operations"][0].update(applicability="blocked", reason="Unknown sharing rule")
        summary, code = self.run_gate()
        self.assertEqual(code, 1)
        self.assertEqual(summary["blocked_operations"], 1)

    def test_filtered_contract(self):
        case = self.inventory["operations"][0]["cases"][1]
        case.update(expectation="filtered", checks=sorted(REQUIRED_CHECKS["filtered"]))
        self.results["cases"][1]["checks"] = case["checks"][:]
        self.assertEqual(self.run_gate()[1], 0)

    def test_inventory_cannot_drop_required_assertions_or_denied_case(self):
        case = self.inventory["operations"][0]["cases"][1]
        case["checks"] = ["denial"]
        with self.assertRaises(InvalidInput):
            self.run_gate()
        self.inventory["operations"][0]["cases"].pop()
        with self.assertRaises(InvalidInput):
            self.run_gate()

    def test_duplicate_unknown_and_stale_results_rejected(self):
        original = copy.deepcopy(self.results)
        self.results["cases"].append(copy.deepcopy(self.results["cases"][0]))
        with self.assertRaises(InvalidInput):
            self.run_gate()
        self.results = copy.deepcopy(original)
        self.results["cases"][0]["operation"] = "unknown"
        with self.assertRaises(InvalidInput):
            self.run_gate()
        self.results = copy.deepcopy(original)
        self.results["inventory_sha256"] = "old-inventory"
        with self.assertRaises(InvalidInput):
            self.run_gate()

    def test_empty_inventory_and_duplicate_operation_rejected(self):
        self.inventory["operations"].append(copy.deepcopy(self.inventory["operations"][0]))
        with self.assertRaises(InvalidInput):
            self.run_gate()
        self.inventory["operations"] = []
        with self.assertRaises(InvalidInput):
            self.run_gate()

    def test_cli_hash_exit_codes_and_invalid_input(self):
        with tempfile.TemporaryDirectory() as directory:
            inventory_path = Path(directory) / "inventory.json"
            results_path = Path(directory) / "results.json"
            raw = json.dumps(self.inventory).encode()
            inventory_path.write_bytes(raw)
            self.results["inventory_sha256"] = hashlib.sha256(raw).hexdigest()
            command = [sys.executable, str(Path(__file__).with_name("check_authorization_coverage.py")),
                       str(inventory_path), str(results_path)]
            for status, expected_code in (("pass", 0), ("fail", 1), ("invalid-status", 2)):
                self.results["cases"][1]["status"] = status
                results_path.write_text(json.dumps(self.results), encoding="utf-8")
                process = subprocess.run(command, capture_output=True, text=True)
                self.assertEqual(process.returncode, expected_code, process.stdout + process.stderr)
                self.assertIn("status", json.loads(process.stdout))
            for raw_invalid in ('{"cases": [], "cases": []}', 'not-json-sensitive-value'):
                results_path.write_text(raw_invalid, encoding="utf-8")
                process = subprocess.run(command, capture_output=True, text=True)
                self.assertEqual(process.returncode, 2)
                self.assertNotIn("sensitive-value", process.stdout + process.stderr)


if __name__ == "__main__":
    unittest.main()
