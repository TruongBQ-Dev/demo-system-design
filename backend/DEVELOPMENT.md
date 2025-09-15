# Development Quick Start Guide

## Prerequisites

1. **Node.js** (v18+)
2. **Docker & Docker Compose**
3. **MySQL** (if running locally)

## Development Setup

### 1. Clone and Install Dependencies

```bash
git clone <repository-url>
cd nest-base
npm install
```

### 2. Environment Setup

Copy environment files:

```bash
cp .env.example .env
# Edit .env with your database configuration
```

### 3. Start MySQL Database

Using Docker:

```bash
docker-compose up -d mysql
```

Or use your local MySQL instance.

### 4. Database Setup

Generate Prisma Client:

```bash
npm run db:generate
```

Push database schema:

```bash
npm run db:push
```

Or run migrations:

```bash
npm run db:migrate
```

### 5. Start Development Server

```bash
npm run start:dev
```

The application will be available at:

- **API**: http://localhost:3000
- **API Documentation**: http://localhost:3000/api

## Docker Development

To run everything with Docker:

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop all services
docker-compose down
```

## Available Commands

### Development

- `npm run start:dev` - Start with hot reload
- `npm run start:debug` - Start with debug mode
- `npm run build` - Build for production
- `npm run start:prod` - Start production build

### Database

- `npm run db:generate` - Generate Prisma client
- `npm run db:push` - Push schema changes
- `npm run db:migrate` - Run migrations
- `npm run db:studio` - Open Prisma Studio

### Testing

- `npm run test` - Run unit tests
- `npm run test:watch` - Run tests in watch mode
- `npm run test:e2e` - Run e2e tests

## API Endpoints

### Health Check

- `GET /` - Hello World message
- `GET /health` - Health check

### Users

- `POST /users` - Create user
- `GET /users` - Get all users
- `GET /users/:id` - Get user by ID
- `PATCH /users/:id` - Update user
- `DELETE /users/:id` - Delete user

### Posts

- `POST /posts` - Create post
- `GET /posts` - Get all posts
- `GET /posts/:id` - Get post by ID
- `PATCH /posts/:id` - Update post
- `DELETE /posts/:id` - Delete post

## Database Schema

### Users Table

- `id` - Primary key
- `email` - Unique email address
- `name` - User's name (optional)
- `password` - Hashed password
- `isActive` - Account status
- `createdAt` - Creation timestamp
- `updatedAt` - Last update timestamp

### Posts Table

- `id` - Primary key
- `title` - Post title
- `content` - Post content (optional)
- `published` - Publication status
- `authorId` - Foreign key to users table
- `createdAt` - Creation timestamp
- `updatedAt` - Last update timestamp

## Troubleshooting

### Database Connection Issues

1. Check if MySQL is running
2. Verify DATABASE_URL in .env
3. Ensure database exists

### Port Already in Use

```bash
# Kill process using port 3000
lsof -ti:3000 | xargs kill -9
```

### Prisma Issues

```bash
# Reset database (DEV ONLY)
npx prisma migrate reset

# Regenerate client
npx prisma generate
```
