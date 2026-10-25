"""Validate native authorization-test results against a workspace operation inventory.

No network requests or application imports. Exit 0: complete/N/A, 1: gaps, 2: invalid.
"""

import argparse
import hashlib
import json
from pathlib import Path


class InvalidInput(ValueError):
    pass


def require(condition, message):
    if not condition:
        raise InvalidInput(message)


def nonempty(value):
    return isinstance(value, str) and bool(value.strip())


def string_list(value, label, allow_empty=True):
    require(isinstance(value, list), label + " must be an array")
    require(all(nonempty(item) for item in value), label + " must contain strings")
    require(len(value) == len(set(value)), label + " contains duplicates")
    require(allow_empty or bool(value), label + " must not be empty")
    return set(value)


REQUIRED_CHECKS = {
    "allow": {"authorized_effect"},
    "deny": {"denial", "no_foreign_data", "no_unauthorized_state",
             "no_unauthorized_side_effect"},
    "filtered": {"expected_filter", "no_foreign_data", "no_unauthorized_state",
                 "no_unauthorized_side_effect"},
}
STATUSES = {"pass", "fail", "skip", "blocked", "error"}


def evaluate(inventory, results, inventory_sha256):
    for label, document in (("inventory", inventory), ("results", results)):
        require(isinstance(document, dict), label + " must be an object")
        require(type(document.get("schema_version")) is int
                and document["schema_version"] == 1, label + " schema_version must be 1")
    require(nonempty(inventory.get("scope")), "inventory scope is required")
    discovery = inventory.get("discovery")
    require(isinstance(discovery, dict), "discovery is required")
    string_list(discovery.get("sources"), "discovery sources", allow_empty=False)
    string_list(discovery.get("gaps"), "discovery gaps")
    operations = inventory.get("operations")
    require(isinstance(operations, list) and bool(operations),
            "operations must be a nonempty array; no application is a separate N/A phase")
    require(results.get("inventory_sha256") == inventory_sha256,
            "results do not match the exact inventory bytes")
    require(nonempty(results.get("command")), "sanitized test command is required")
    require(type(results.get("completed")) is bool, "completed must be a boolean")
    require(type(results.get("exit_code")) is int, "native runner exit_code must be an integer")
    require(isinstance(results.get("cases"), list), "result cases must be an array")

    expected = {}
    operation_ids = set()
    applicable_ids = set()
    excluded = 0
    blocked_operations = 0
    issues = [{"kind": "discovery_gap", "reason": gap} for gap in discovery["gaps"]]
    if not results["completed"]:
        issues.append({"kind": "incomplete_run"})
    if results["exit_code"] != 0:
        issues.append({"kind": "runner_failure", "exit_code": results["exit_code"]})

    for operation in operations:
        require(isinstance(operation, dict), "operation must be an object")
        operation_id = operation.get("id")
        require(nonempty(operation_id), "operation id is required")
        require(operation_id not in operation_ids, "duplicate operation id")
        operation_ids.add(operation_id)
        require(nonempty(operation.get("source")), "operation source is required")
        applicability = operation.get("applicability")
        require(isinstance(applicability, str)
                and applicability in {"applicable", "not_applicable", "blocked"},
                "invalid applicability")
        cases = operation.get("cases")
        require(isinstance(cases, list), "operation cases must be an array")
        if applicability != "applicable":
            require(nonempty(operation.get("reason")), "exclusion/blocker reason is required")
            if applicability == "not_applicable":
                require(not cases, "excluded operation must not have test cases")
                excluded += 1
                continue
            blocked_operations += 1
            issues.append({"operation": operation_id, "kind": "blocked_operation",
                           "reason": operation["reason"]})
        else:
            applicable_ids.add(operation_id)
            require(nonempty(operation.get("policy")), "applicable operation policy is required")

        expectations = set()
        for case in cases:
            require(isinstance(case, dict), "expected case must be an object")
            case_id = case.get("id")
            require(nonempty(case_id), "case id is required")
            key = (operation_id, case_id)
            require(key not in expected, "duplicate expected case")
            expectation = case.get("expectation")
            require(isinstance(expectation, str) and expectation in REQUIRED_CHECKS,
                    "invalid case expectation")
            checks = string_list(case.get("checks"), "expected checks", allow_empty=False)
            require(REQUIRED_CHECKS[expectation] <= checks,
                    "case is missing mandatory assertion names")
            expected[key] = checks
            expectations.add(expectation)
        if applicability == "applicable":
            require("allow" in expectations and bool({"deny", "filtered"} & expectations),
                    "applicable operation needs allowed and denied/filtered cases")

    observed = {}
    counts = dict.fromkeys(sorted(STATUSES), 0)
    successful = set()
    for result in results["cases"]:
        require(isinstance(result, dict), "case result must be an object")
        require(nonempty(result.get("operation")) and nonempty(result.get("case")),
                "result operation and case are required")
        key = (result["operation"], result["case"])
        require(key in expected, "result references an unknown operation/case")
        require(key not in observed, "duplicate case result")
        status = result.get("status")
        require(isinstance(status, str) and status in STATUSES, "invalid result status")
        checks = string_list(result.get("checks"), "executed checks")
        require(nonempty(result.get("evidence")), "result evidence/reason is required")
        observed[key] = result
        counts[status] += 1
        missing_checks = expected[key] - checks
        if status == "pass" and not missing_checks:
            successful.add(key)
        else:
            issues.append({"operation": key[0], "case": key[1], "kind": status
                           if status != "pass" else "missing_assertions",
                           "missing_checks": sorted(missing_checks)})

    missing = expected.keys() - observed.keys()
    for operation_id, case_id in sorted(missing):
        issues.append({"operation": operation_id, "case": case_id, "kind": "missing_result"})
    passed_operations = sum(
        all(key in successful for key in expected if key[0] == operation_id)
        for operation_id in applicable_ids
    )
    status = "incomplete" if issues else ("pass" if applicable_ids else "not_applicable")
    return {
        "status": status,
        "operations": len(operations),
        "applicable_operations": len(applicable_ids),
        "fully_passing_operations": passed_operations,
        "blocked_operations": blocked_operations,
        "not_applicable_operations": excluded,
        "required_cases": len(expected),
        "successful_cases": len(successful),
        "missing_cases": len(missing),
        "reported_case_statuses": counts,
        "issues": issues,
    }, 1 if issues else 0


def unique_object(pairs):
    result = {}
    for key, value in pairs:
        require(key not in result, "duplicate JSON object key")
        result[key] = value
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("inventory", type=Path)
    parser.add_argument("results", type=Path)
    args = parser.parse_args()
    try:
        inventory_bytes = args.inventory.read_bytes()
        inventory = json.loads(inventory_bytes, object_pairs_hook=unique_object)
        results = json.loads(args.results.read_bytes(), object_pairs_hook=unique_object)
        summary, code = evaluate(inventory, results, hashlib.sha256(inventory_bytes).hexdigest())
    except (InvalidInput, OSError, ValueError) as error:
        # JSON parse/OS errors may contain sensitive input or paths; do not echo them.
        summary = {"status": "invalid", "error": str(error) if isinstance(error, InvalidInput)
                   else "Cannot read or parse input JSON"}
        code = 2
    print(json.dumps(summary, indent=2))
    return code


if __name__ == "__main__":
    raise SystemExit(main())
