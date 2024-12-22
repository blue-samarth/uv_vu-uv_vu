#!/bin/bash

# This script is used to run the tests of the project

# Run the tests
set -euo pipefail # Exit on error

echo "🧪 Running tests with verbose output..."
uv run pytest -vvv -s tests/*.py

echo "📊 Generating coverage report..."
uv run pytest --cov=libs --cov-report=html tests/*.py

echo "🌐 Opening coverage report..."
if command -v xdg-open &> /dev/null; then
    xdg-open htmlcov/index.html
elif command -v open &> /dev/null; then    # For macOS
    open htmlcov/index.html
else
    echo "⚠️  Could not open coverage report automatically. Please open htmlcov/index.html manually."
fi