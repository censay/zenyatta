# Contributing to Zenyatta

Thank you for your interest in contributing to Zenyatta! This document provides guidelines and instructions for contributing.

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork**: `git clone https://github.com/YOUR_USERNAME/zenyatta.git ~/zenyatta`
3. **Run setup**: `cd ~/zenyatta && ./setup.sh`
4. **Make your changes** and test them
5. **Submit a pull request**

## Development Setup

Zenyatta is written in Bash and uses standard Unix tools. No special build process is required.

### Requirements

- Bash 4.0+
- Podman or Docker
- Git
- Meld (for visual diffs)

### Code Style

- Use 2-space indentation
- Functions should be lowercase with underscores: `zen_function_name`
- Constants should be UPPERCASE
- Always use `[[ ]]` instead of `[ ]` for conditionals
- Use `set -euo pipefail` at the top of scripts

### Project Structure

```
zenyatta/
├── lib/              # Shared functions
│   ├── zen-core.sh
│   └── zen-backup.sh
├── zen-*             # Command scripts
├── setup.sh          # Installation script
└── *.md              # Documentation
```

### Testing

Test your changes by:
1. Running the command directly: `./zen-push test-project`
2. Testing error cases (missing args, invalid projects)
3. Verifying the container still works: `zen-enter`

## Types of Contributions

### Bug Fixes

- Describe the bug in the PR description
- Include steps to reproduce
- Show the fix working

### New Features

- Open an issue first to discuss the feature
- Explain why it would be useful
- Keep changes minimal and focused

### Documentation

- Fix typos and clarify explanations
- Add examples where helpful
- Update both README.md and command help text

## Pull Request Process

1. Ensure your code follows the style guidelines
2. Update documentation if needed
3. Test your changes thoroughly
4. Write a clear PR description explaining what and why
5. Reference any related issues

## Code of Conduct

- Be respectful and constructive
- Welcome newcomers and help them learn
- Focus on what's best for the community

## Questions?

- Open an issue for bugs or feature requests
- Check existing issues and PRs first
- Join discussions in open issues

Thank you for contributing to Zenyatta! 🧘
