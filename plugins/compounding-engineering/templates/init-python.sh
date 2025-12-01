#!/bin/bash
# Claude Agent Dev Environment Startup - Python Template
set -e

echo "Starting development environment..."

# Activate virtual environment
if [ -d "venv" ]; then
  echo "Activating virtual environment..."
  source venv/bin/activate
elif [ -d ".venv" ]; then
  source .venv/bin/activate
else
  echo "Creating virtual environment..."
  python -m venv venv
  source venv/bin/activate
  pip install -r requirements.txt
fi

# Start any required services
if command -v docker-compose &> /dev/null; then
  echo "Starting Docker services..."
  docker-compose up -d
  sleep 2
fi

# Start the dev server
echo "Starting dev server..."
if [ -f "manage.py" ]; then
  # Django
  python manage.py runserver &
elif [ -f "app.py" ]; then
  # Flask
  flask run &
else
  # Generic
  python -m uvicorn main:app --reload &
fi

sleep 3

echo "Development environment ready!"
echo ""
echo "Quick commands:"
echo "  pytest                - Run tests"
echo "  python manage.py      - Django management"
