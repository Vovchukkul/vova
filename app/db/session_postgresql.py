import os
from contextlib import asynccontextmanager
from typing import AsyncGenerator

from dotenv import load_dotenv
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker


load_dotenv(verbose=True)

# it can be replaced by separate pydantic_settings configuration
USER = os.getenv("POSTGRES_USER", "admin")
PASSWORD = os.getenv("POSTGRES_PASSWORD", "Super_Str0ng_Pa$$word")
HOST = os.getenv("POSTGRES_HOST", "localhost")
PORT = os.getenv("POSTGRES_PORT", "5432")
DB_NAME = os.getenv("POSTGRES_DB", "exhibition_db")
DRIVER = "postgresql+asyncpg"

POSTGRESQL_DATABASE_URL = f"{DRIVER}://{USER}:{PASSWORD}@{HOST}:{PORT}/{DB_NAME}"
postgresql_engine = create_async_engine(
    POSTGRESQL_DATABASE_URL, echo=False, future=True
)

AsyncPostgresqlSessionLocal = sessionmaker(  # type: ignore
    bind=postgresql_engine,
    class_=AsyncSession,
    autocommit=False,
    expire_on_commut=False,
)


async def get_postgresql_db() -> AsyncGenerator:
    """
    Provide and asynchronous database session.

    This function returns an async generator yielding new database session.
    It ensures that the session is properly closed after use.

    Use case: for routes via Depends().

    :return: An asynchronous generator that yields an AsyncSession instance.
    """
    async with AsyncPostgresqlSessionLocal() as session:
        yield session


@asynccontextmanager
async def get_postgresql_db_contextmanager() -> AsyncGenerator[AsyncGenerator, None]:
    """
    Provide an asynchronous database session using a context manager.

    This function allows for managing the database session within a `with` statement.
    It ensures that the session is properly initialized and closed after execution.

    Use case:
        - repository/service layers that run outside a request–response cycle;
        - unit/integration tests that don’t use FastAPI’s dependency injection.

    :return: An asynchronous generator yielding an AsyncSession instance.
    """
    async with AsyncPostgresqlSessionLocal() as session:
        yield session
