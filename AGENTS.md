# AGENTS.md

## Build, Lint, and Test Commands

### Build
- Use `nix build` to build the project.
- For specific plugins, refer to their `build` commands in `lua/custom/plugins/*.lua`.

### Lint
- Run `golangci-lint run` for Go files.
- Use `stylua` for Lua files: `stylua <file>`.
- Use `blade-formatter` for Blade templates.

### Test
- Use `neotest` for running tests:
  - Run nearest test: `require('neotest').run.run()`.
  - Run tests in the current file: `require('neotest').run.run(vim.fn.expand('%'))`.
  - Open test output: `require('neotest').output.open({ enter = true })`.
- For Behat tests: `make exec-behat test=<target>`.

## Code Style Guidelines

### Formatting
- Use `stylua` for Lua code.
- Follow `gofmt` and `goimports` for Go code.
- Ensure consistent indentation and spacing.

### Naming Conventions
- Use descriptive and consistent names for variables and functions.
- Avoid unclear or inconsistent naming (e.g., `temp`, `data1`).

### Imports
- Group imports logically and avoid unused imports.

### Error Handling
- Use descriptive error messages.
- Handle errors gracefully, avoiding abrupt terminations.

### General
- Keep functions small and focused.
- Document complex logic with comments.
- Avoid hardcoding values; use configuration or constants where possible.