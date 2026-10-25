---
paths:
  - "**/*.py"
  - "**/*.pyi"
---
# Python

- Modern idioms: type hints on public functions, `pathlib` over `os.path`, f-strings, dataclasses (or the project's pydantic) for structured data.
- Use the project's environment and runner (`uv run`, `poetry run`, the venv, conda — check for `uv.lock`, `poetry.lock`, `environment.yml`). Never `pip install` into the system interpreter. Ask before adding a dependency.
- Format and lint with what `pyproject.toml` configures (ruff / black / isort). Don't introduce a new tool.
- Tests: pytest, laid out like the package; fixtures over setUp; `tmp_path` for files; parametrize instead of copy-pasting cases.
- Errors: catch specific exceptions, never bare `except:`; re-raise with context (`raise ... from e`).
- No mutable default arguments, no `import *`, no work at import time — scripts go behind `if __name__ == "__main__":`.
- Security: no `eval`/`exec` on input; no `pickle.load` or `torch.load(..., weights_only=False)` on files you didn't create; `subprocess` with an argument list, not `shell=True`; parameterized SQL.
- Notebooks: keep logic in importable modules that the notebook calls. Don't read `.ipynb` outputs unless asked.
