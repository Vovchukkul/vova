# Exhibition.Online Backend

- [Tech Details](#tech-details)
- [Useful Commands](#how-to-run-the-app)
  - [How to run the app](#how-to-run-the-app)
  - [How to shut down the app](#how-to-shut-down-the-app)
  - [How to run tests](#how-to-run-tests)
  - [How to generate and run migrations](#how-to-generate-and-run-migrations)

---
### Tech Details
| Resource                    | Resource Name | Version | Comment |
|-----------------------------|---------------|---------|---------|
| Back-end programming language | Python        | 3.12    |         |
| Back-end web framework       | FastAPI       | 0.118.1 |         |
| Database                     | PostgreSQL    | 16.10   |         |
| Web server                   | Uvicorn       | 0.37.0  |         |

---
### How to run the app:

```shell
docker-compose up --build  # rebuilds the images after each start
```

### How to shut down the app:
Stop `docker-compose.yml` using ``Ctrl + C``

---
### How to run tests:

- Run all tests:
```shell
pytest
```
- Run tests in specific folder:
```shell
pytest tests/
```

- Run tests with specific name:
```shell
pytest -k "test_user"
pytest tests/ -k "test_database"  # run tests with specific name in specific folder
```

---
### How to generate and run migrations
1. Generate migration (automatically by SQLAlchemy models):
```shell
alembic revision --autogenerate -m 'migration description'
# --autogenerate differs models from the database and makes changes
```

2. Apply migrations:
```shell
alembic upgrade head
```

Additionally, you can check status:
```shell
alembic current
alembic history 
```