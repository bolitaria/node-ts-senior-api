# 🚀 Senior Node.js + TypeScript API

Scalable API built with Node.js, TypeScript, PostgreSQL, Redis, and ClickHouse.

## 🛠 Tech Stack

- **Runtime**: Node.js 18+
- **Language**: TypeScript
- **Database**: PostgreSQL + Redis + ClickHouse
- **Testing**: Jest + Supertest
- **Container**: Docker + Docker Compose
- **CI/CD**: GitHub Actions

## 🏗 Architecture

- Clean Architecture & Domain-Driven Design (DDD)
- RESTful & GraphQL APIs
- JWT Authentication & OAuth2
- Background Jobs (BullMQ)
- Caching Strategy (Redis)
- Monitoring & Metrics

## ✅ Key Features

- JWT authentication with refresh tokens
- PostgreSQL persistence (TypeORM)
- Redis caching and session/refresh token storage
- Analytics via ClickHouse
- Modular domain structure
- Unit & integration tests (Jest + Supertest)
- Dockerized with Docker Compose
- CI/CD with GitHub Actions

## 📁 Project Structure

- Main app: `src/app.ts`
- Auth module: `src/modules/auth/`
- User module: `src/modules/users/`
- Config: `src/config/`
- Middleware: `src/shared/middleware/`
- Validation: `src/shared/utils/validation.ts`
- Tests: `tests/integration/`
- Docker: `docker-compose.yml`, `Dockerfile`
- CI: `.github/workflows/ci.yml`
- Scripts & config: `package.json`, `tsconfig.json`, `jest.config.js`

## 🚀 Quick Start

```bash
# Clone repository
git clone https://github.com/bolitaria/node-ts-senior-api.git
cd node-ts-senior-api

# Install dependencies
npm install

# Start with Docker (recommended for all services)
npm run docker:up

# Development (hot-reload)
npm run dev
```

- Health check: [http://localhost:3000/health](http://localhost:3000/health)
- Debug: [http://localhost:3000/api/debug](http://localhost:3000/api/debug)

## ⚙️ Environment Variables (example)

```
NODE_ENV=development
PORT=3000
DB_HOST=postgres
DB_PORT=5432
DB_NAME=myapp
DB_USER=user
DB_PASSWORD=password
REDIS_HOST=redis
REDIS_PORT=6379
JWT_SECRET=your-secret
CLICKHOUSE_HOST=clickhouse
CLICKHOUSE_PORT=8123
```

## 📦 NPM Scripts

- `dev` — Start in development mode (nodemon)
- `build` — Compile TypeScript
- `start` — Run compiled app
- `test` — Run all tests
- `test:integration` — Run integration tests
- `docker:up` / `docker:down` / `docker:logs` — Manage Docker services
- `typecheck` — TypeScript type checking

## 🔗 Main API Endpoints

- `POST /api/auth/register` — Register user
- `POST /api/auth/login` — Login and get access/refresh tokens
- `POST /api/auth/refresh-token` — Refresh tokens
- `POST /api/auth/logout` — Invalidate refresh token
- `GET /api/auth/profile` — Protected route (JWT required)

## 🔒 Authentication Flow

- Access and refresh tokens issued by AuthService
- Refresh tokens stored in PostgreSQL and/or Redis
- Protected routes use `authenticateToken` middleware

## 🧪 Testing & CI

- Unit and integration tests with Jest & Supertest
- CI pipeline: lint, typecheck, test, build (see `.github/workflows/ci.yml`)

## 🐳 Docker & CI

- `docker-compose.yml` defines: API, PostgreSQL, Redis, ClickHouse
- `Dockerfile` for building the API image
- CI workflow runs all checks and tests

## 🧭 Troubleshooting

- DB connection issues: check PostgreSQL container logs and environment variables
- CI test failures: ensure all services are running in workflow
- TypeORM/decorator errors: check `tsconfig.json` for `experimentalDecorators` and `emitDecoratorMetadata`

## 🤝 Contributing

- Open PRs against `main` or `develop`
- Run typecheck and tests before pushing:
  ```bash
  npm run typecheck && npm run test
  ```

## 📜 License

MIT — see `LICENSE`