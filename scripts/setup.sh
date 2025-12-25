#!/bin/bash

set -e

echo "🚀 LoadMaster Setup Script"
echo "=========================="
echo ""

# Check prerequisites
echo "📋 Checking prerequisites..."

if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    if ! docker compose version &> /dev/null; then
        echo "❌ Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi
fi

if ! command -v node &> /dev/null; then
    echo "⚠️  Node.js is not installed. Skipping local development setup."
    LOCAL_DEV=false
else
    echo "✅ Node.js $(node --version) found"
    LOCAL_DEV=true
fi

if ! command -v cargo &> /dev/null; then
    echo "⚠️  Rust is not installed. Skipping worker development setup."
    RUST_DEV=false
else
    echo "✅ Rust $(cargo --version) found"
    RUST_DEV=true
fi

echo ""

# Setup environment files
echo "📝 Setting up environment files..."

if [ ! -f backend/.env ]; then
    cp backend/.env.example backend/.env
    echo "✅ Created backend/.env"
else
    echo "⏭️  backend/.env already exists"
fi

if [ ! -f frontend/.env.local ]; then
    cp frontend/.env.local.example frontend/.env.local
    echo "✅ Created frontend/.env.local"
else
    echo "⏭️  frontend/.env.local already exists"
fi

if [ ! -f worker/.env ]; then
    cp worker/.env.example worker/.env
    echo "✅ Created worker/.env"
else
    echo "⏭️  worker/.env already exists"
fi

echo ""

# Ask user for deployment type
echo "🎯 Choose setup type:"
echo "  1) Full Docker deployment (recommended for quick start)"
echo "  2) Development mode (infrastructure in Docker, services local)"
echo ""
read -p "Enter choice [1-2]: " choice

case $choice in
    1)
        echo ""
        echo "🐳 Starting full Docker deployment..."
        docker-compose build
        docker-compose up -d
        
        echo ""
        echo "✅ Setup complete!"
        echo ""
        echo "📍 Services are available at:"
        echo "   Frontend:  http://localhost:3000"
        echo "   Backend:   http://localhost:4000/graphql"
        echo "   RabbitMQ:  http://localhost:15672 (guest/guest)"
        echo ""
        echo "📊 View logs:"
        echo "   docker-compose logs -f"
        echo ""
        echo "⏹️  Stop services:"
        echo "   docker-compose down"
        ;;
        
    2)
        if [ "$LOCAL_DEV" = false ]; then
            echo "❌ Node.js is required for development mode."
            exit 1
        fi
        
        echo ""
        echo "🔧 Setting up development environment..."
        
        # Start infrastructure
        docker-compose -f docker-compose.dev.yml up -d
        
        # Install dependencies
        echo ""
        echo "📦 Installing backend dependencies..."
        cd backend && npm install && cd ..
        
        echo "📦 Installing frontend dependencies..."
        cd frontend && npm install && cd ..
        
        if [ "$RUST_DEV" = true ]; then
            echo "📦 Building Rust worker..."
            cd worker && cargo build && cd ..
        fi
        
        echo ""
        echo "✅ Setup complete!"
        echo ""
        echo "📍 Infrastructure is running (PostgreSQL, RabbitMQ)"
        echo ""
        echo "🚀 Start services in separate terminals:"
        echo "   Terminal 1: cd backend && npm run start:dev"
        echo "   Terminal 2: cd frontend && npm run dev"
        if [ "$RUST_DEV" = true ]; then
            echo "   Terminal 3: cd worker && cargo run"
        fi
        echo ""
        echo "⏹️  Stop infrastructure:"
        echo "   docker-compose -f docker-compose.dev.yml down"
        ;;
        
    *)
        echo "❌ Invalid choice"
        exit 1
        ;;
esac

echo ""
echo "📖 Documentation:"
echo "   README.md           - Getting started"
echo "   ARCHITECTURE.md     - System architecture"
echo "   DEPLOYMENT.md       - Deployment guide"
echo ""
echo "Happy load testing! 🎉"

