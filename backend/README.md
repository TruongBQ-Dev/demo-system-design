# NestJS Base Project

A NestJS project with Prisma ORM, MySQL database, and Docker support.

## Features

- **NestJS**: A progressive Node.js framework
- **Prisma**: Next-generation ORM for Node.js and TypeScript
- **MySQL**: Relational database
- **Docker**: Containerization support
- **Swagger**: API documentation
- **Validation**: Input validation with class-validator

## Getting Started

### Prerequisites

- Node.js (v18 or higher)
- Docker and Docker Compose
- MySQL (if running locally)

### Installation

1. Clone the repository:

   ```bash
   git clone <repository-url>
   cd nest-base
   ```

2. Install dependencies:

   ```bash
   npm install
   ```

3. Set up environment variables:

   ```bash
   cp .env.example .env
   ```

4. Start the database with Docker:

   ```bash
   docker-compose up -d mysql
   ```

5. Run database migrations:

   ```bash
   npm run db:migrate
   ```

6. Start the application:
   ```bash
   npm run start:dev
   ```

### Docker

To run the entire application with Docker:

```bash
docker-compose up -d
```

## API Documentation

Once the application is running, you can access the Swagger documentation at:

- http://localhost:3000/api

## Available Scripts

- `npm run start`: Start the application
- `npm run start:dev`: Start in development mode with hot reload
- `npm run start:prod`: Start in production mode
- `npm run build`: Build the application
- `npm run test`: Run tests
- `npm run db:generate`: Generate Prisma client
- `npm run db:migrate`: Run database migrations
- `npm run db:studio`: Open Prisma Studio

## Project Structure

```
src/
├── app.controller.ts
├── app.module.ts
├── app.service.ts
├── main.ts
├── prisma/
│   ├── prisma.module.ts
│   └── prisma.service.ts
└── users/
    ├── dto/
    ├── entities/
    ├── users.controller.ts
    ├── users.module.ts
    └── users.service.ts
```

## License

This project is licensed under the MIT License.
