# 1. Overview
This project consists of two main components:
- **Backend API (FastAPI)** - provides core business logic and REST endpoints.
- **Frontend (React / Next.js)** - public user-facing web application.

Both components communicate via RESTful JSON APIs.
Authentication is handled via __JWT tokens__, issued by the backend and used by the frontend part.

---

# 2. Backend Architecture (FastAPI)

```text
sep1-exhibition-online-backend/
├─ app/
│  ├─ main.py                                   # App entrypoint (likely starts the web server / routes)
│  ├─ core/                                     # Core app utilities/configuration shared across modules
│  │  └─ __init__.py                            
│  ├─ db/                                       # Database layer (connections, sessions, migrations helpers)
│  │  ├─ __init__.py                            
│  │  └─ session_postgresql.py                  # PostgreSQL session/engine configuration (e.g., SQLAlchemy)
│  ├─ users/                                    # "Users" domain module
│  │  ├─ __init__.py                            
│  │  ├─ models.py                              # ORM models for user domain
│  │  ├─ routes.py                              # API routes/endpoints for user domain
│  │  ├─ schemas.py                             # Pydantic/validation schemas for user domain
│  │  └─ services.py                            # Business logic/services for user domain
│  ├─ companies/                                # "Companies" domain module
│    ├─ __init__.py                            
│    ├─ models.py                              # ORM models for companies domain
│    ├─ routes.py                              # API routes/endpoints for companies domain
│    ├─ schemas.py                             # Pydantic/validation schemas for companies domain
│    └─ services.py                            # Business logic/services for companies domain
.................... # To be added consistently         
├─ tests/                                       # Automated tests for the application
│  └─ .gitkeep                                  
├─ .env                                         # Local environment variables for development (not for production)
├─ .env.example                                 # Example env file; template to create your local .env
├─ docker-compose.yml                           # Dev docker-compose (spins up PostgreSQL and dev services)
├─ requirements.txt                             # Python dependencies (pip freeze or curated list)
├─ README.md                                    # Project documentation and setup instructions
└─ .gitignore                                   # Git ignore rules
```

---

# 3. Architecture layers and where they live

- Presentation layer (API):
  - Folder: `app/*/routes.py`
  - Responsibility: Defines HTTP endpoints, request/response models usage, status codes, and wiring to service layer. 
  - Tech: FastAPI routers, Pydantic schemas.
- Application/Service layer (use cases):
  - Folder: `app/*/services.py`
  - Responsibility: Implements business use cases, coordinates between routes and data-access, enforces application rules, transactions boundaries. 
  - Tech: Plain Python, calls into SQLAlchemy sessions via the DB layer.
- Domain models and schemas:
  - ORM Models: `app/*/models.py` — SQLAlchemy models that map to Postgres tables. 
  - API Schemas: `app/*/schemas.py` — Pydantic models for validation and serialization at the API boundary.
- Data access layer (persistence):
  - Folder: `app/db/` (notably `session_postgresql.py`)
  - Responsibility: Database engine/session creation, session lifecycle, connection configuration.
  - Tech: SQLAlchemy Engine/Session, Postgres driver (via SQLAlchemy), env vars loaded by `python-dotenv`.
- Core/configuration:
  - Folder: `app/core/`
  - Responsibility: Cross-cutting concerns (settings, constants, utilities). Currently minimal but intended for shared configuration/utilities.
- Infrastructure:
  - Files: `docker-compose.yml` (Postgres service, persistent volume, network), `.env`/`.env.example` (configuration). 
  - Responsibility: Local development environment, containerized DB, environment provisioning.
- Testing:
  - Folder: `tests/`
  - Responsibility: Unit/integration tests (run via `pytest`).

---

# 4. Authentication & Authorization
- Users authenticate via `/auth/login` endpoint (username/password)
- Backend issues a JWT token with `role` and `user_id` claims
- Role-based access control (RBAC):
  - `user` - basic access
  - `admin` - elevated privileges

---

# 5. Notest and recommendations

- Keep domain structure consistent: each domain (`users`, `companies`, …) should have `models.py`, `schemas.py`, `services.py`, and `routes.py`.
- Centralize session management and transaction handling in `app/db/session_postgresql.py` to avoid leaks.
- Consider adding a `settings.py` under `app/core/` to consolidate configuration using Pydantic `BaseSettings` for type-safe env management.