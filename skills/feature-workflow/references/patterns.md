# Pattern references

Reviewed 24 October 2026. No specific repository URL was supplied; these primary GitHub examples were selected for their fit to the requested workflow.

| Source | Use in this skill |
|---|---|
| [Anthropic: basic workflows](https://github.com/anthropics/claude-cookbooks/blob/bfe50e59dbb4f5546a0af9ca36ebb77e637c9ce1/patterns/agents/basic_workflows.ipynb) | Focused prompts run in order, passing checked outputs to the next stage. Independent checks may run concurrently when permitted. |
| [Anthropic: evaluator/optimizer](https://github.com/anthropics/claude-cookbooks/blob/bfe50e59dbb4f5546a0af9ca36ebb77e637c9ce1/patterns/agents/evaluator_optimizer.ipynb) | Review returns concrete feedback for the next implementation attempt. This skill adds bounded corrections and executable acceptance checks. |
| [Anthropic: orchestrator/workers](https://github.com/anthropics/claude-cookbooks/blob/bfe50e59dbb4f5546a0af9ca36ebb77e637c9ce1/patterns/agents/orchestrator_workers.ipynb) | A coordinator may assign a separate review task when delegation is available and permitted. Separate agents are not required for every stage. |
| [Microsoft: verify before approve](https://github.com/microsoft/agenticai-design-patterns/blob/14606ff6229d62bde275b77579608f7e5792eb8a/assets/orchestration-and-workflows/verify-before-approve/README.md) | Verify the actual candidate before delivery; source edits invalidate affected evidence. Use existing authorization instead of inventing approvals. |
| [Microsoft: bounded autonomy](https://github.com/microsoft/agenticai-design-patterns/blob/14606ff6229d62bde275b77579608f7e5792eb8a/assets/orchestration-and-workflows/bounded-autonomy/README.md) | Limit correction and publication retries. Stop with evidence when requirements cannot be met. Runtime and repository controls enforce actual permissions. |

These are pattern adaptations, not copied implementations. The skill does not require an Anthropic SDK, Azure services, hidden reasoning logs, or the examples' model choices. The stage contract and safe Git delivery rules are specific to this software-feature workflow.
