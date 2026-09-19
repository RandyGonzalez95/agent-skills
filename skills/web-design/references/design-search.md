# Design search

The bundled scripts and CSV data preserve the original UI/UX search engine. They require Python 3; locate an actual interpreter instead of assuming a launcher works. If unavailable, use ordinary design judgment and disclose that no database search ran.

Run commands with the actual full path to [scripts/search.py](../scripts/search.py):

```text
python <skill-directory>/scripts/search.py "dashboard accessible dense" --design-system
python <skill-directory>/scripts/search.py "keyboard focus" --domain ux
python <skill-directory>/scripts/search.py "responsive navigation" --stack react
```

Use --help for supported domains, stacks, and output formats. Pass the project's actual stack. The data contains historical recommendations and snippets; verify current APIs before implementation.

When using --persist, explicitly pass --output-dir with the project root. Read existing output first. Do not use --force to discard established decisions without a reason within the user's task. The optional variance, motion, and density settings are design suggestions, not user preferences.

For empty results, broaden the query once, then give a clearly labeled recommendation based on general design principles. Never describe a fallback as a database match.
