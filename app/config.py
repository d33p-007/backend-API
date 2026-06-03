import os


class Config:
    # Secret Manager injects these as env vars via Cloud Run
    SECRET_KEY = os.environ.get("SECRET_KEY", "dev-secret-change-me")
    JWT_SECRET_KEY = os.environ.get("JWT_SECRET_KEY", "dev-jwt-secret-change-me")

    # Cloud SQL connection via Unix socket (Cloud Run) or TCP (local)
    DB_USER = os.environ.get("DB_USER", "purevibe")
    DB_PASS = os.environ.get("DB_PASS", "purevibe")
    DB_NAME = os.environ.get("DB_NAME", "purevibe")
    DB_HOST = os.environ.get("DB_HOST", "127.0.0.1")
    INSTANCE_UNIX_SOCKET = os.environ.get("INSTANCE_UNIX_SOCKET")

    if INSTANCE_UNIX_SOCKET:
        SQLALCHEMY_DATABASE_URI = (
            f"postgresql+psycopg2://{DB_USER}:{DB_PASS}@/{DB_NAME}"
            f"?host={INSTANCE_UNIX_SOCKET}"
        )
    else:
        SQLALCHEMY_DATABASE_URI = (
            f"postgresql+psycopg2://{DB_USER}:{DB_PASS}@{DB_HOST}/{DB_NAME}"
        )

    SQLALCHEMY_TRACK_MODIFICATIONS = False
    JWT_ACCESS_TOKEN_EXPIRES = 3600  # 1 hour