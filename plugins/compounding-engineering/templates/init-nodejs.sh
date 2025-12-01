#!/bin/bash
# Claude Agent Dev Environment Startup - Node.js Template
set -e

echo "Starting development environment..."

# Install dependencies if needed
if [ ! -d "node_modules" ]; then
  echo "Installing dependencies..."
  npm install
fi

# Start any required services (database, redis, etc.)
if command -v docker-compose &> /dev/null; then
  echo "Starting Docker services..."
  docker-compose up -d
  sleep 2
fi

# Start the dev server in background
echo "Starting dev server..."
npm run dev &
DEV_PID=$!

# Wait for server to be ready
echo "Waiting for server..."
sleep 5

# Health check
if curl -s http://localhost:3000/health > /dev/null 2>&1; then
  echo "Development environment ready!"
  echo ""
  echo "Server running at: http://localhost:3000"
  echo "Server PID: $DEV_PID"
else
  echo "Server may not be fully ready, but continuing..."
fi

echo ""
echo "Quick commands:"
echo "  npm test              - Run tests"
echo "  npm run lint          - Check linting"
echo "  curl localhost:3000   - Test server"
