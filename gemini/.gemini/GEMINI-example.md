The `GEMINI.md` file is a powerful tool for providing me with project-specific context and instructions. Think of it as a "project README" specifically for me, the Gemini agent.

By creating a `GEMINI.md` file in the root directory of your project, you can tell me about the project's conventions, commands, and goals. I will read this file at the beginning of our interaction within that project to guide my work.

### How to Use `GEMINI.md`

Place a `GEMINI.md` file in the root of your project directory. Here’s what you should put in it:

1.  **Project Overview:** A brief description of the project's purpose and goals.
2.  **Build & Run Commands:** The exact shell commands to build, test, lint, and run the project. This is the most important section.
3.  **Tech Stack & Conventions:** Key libraries, frameworks, and architectural patterns used. Mention coding style (e.g., "use Prettier for formatting," "prefer functional components in React").
4.  **Important File Locations:** Pointers to key files like configuration, main entry points, or critical modules.

### What NOT to Include

*   **Secrets:** Never store API keys, passwords, or any sensitive credentials in this file.
*   **Temporary Instructions:** Use the chat prompt for one-off tasks. `GEMINI.md` is for persistent, project-level guidance.
*   **Personal Preferences:** For personal, non-project-related facts you want me to remember, use the `save_memory` tool (e.g., "Remember my preferred editor is Neovim").

---

### Example `GEMINI.md`

Here is an example for a Python FastAPI project:

```markdown
# Project: My Awesome API

This is a REST API for managing user profiles and widgets, built with FastAPI and PostgreSQL.

## Key Technologies
- Python 3.11+
- FastAPI
- Pydantic for data validation
- SQLAlchemy for ORM
- Ruff for linting and formatting

## Common Commands

**Setup:**
To set up the development environment and install dependencies:
```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

**Run Development Server:**
```bash
uvicorn app.main:app --reload
```

**Run Tests:**
To run the full test suite using pytest:
```bash
pytest
```

**Linting & Formatting:**
To check for style issues and auto-format the code:
```bash
ruff check .
ruff format .
```

## Coding Conventions
- All API endpoints should be in the `app/api/` directory.
- Use Pydantic models for all request and response bodies.
- Follow the Google Python Style Guide.
```