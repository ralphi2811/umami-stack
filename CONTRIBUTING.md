# Contributing to Umami Stack

Thank you for your interest in contributing to the Umami Stack project!

## How to Contribute

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/your-feature-name`
3. **Make your changes**
4. **Test your changes**: Ensure docker-compose configuration is valid
5. **Commit your changes**: Use clear, descriptive commit messages
6. **Push to your fork**: `git push origin feature/your-feature-name`
7. **Open a Pull Request**

## Testing Changes

Before submitting a PR, please test your changes:

```bash
# Validate docker-compose configuration
docker compose config --quiet

# Test the stack
docker compose up -d
docker compose ps
docker compose logs
docker compose down
```

## Code Style

- Use clear, descriptive names for services and variables
- Add comments for complex configurations
- Follow Docker Compose best practices
- Keep configurations production-ready

## Reporting Issues

If you find a bug or have a feature request:

1. Check if the issue already exists
2. Create a new issue with a clear title and description
3. Include steps to reproduce (for bugs)
4. Include your environment details (OS, Docker version, etc.)

## Questions?

Feel free to open an issue for questions or discussions!
