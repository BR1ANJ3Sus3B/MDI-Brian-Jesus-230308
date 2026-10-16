import os
from contextlib import contextmanager

import psycopg
from psycopg.rows import dict_row
from pymongo import MongoClient

mongo_client = MongoClient(
    os.getenv("MONGO_URL", "mongodb://localhost:27017/app_mobile"),
    username=os.getenv("MONGO_USER", "developer"),
    password=os.getenv("MONGO_PASSWORD", ""),
    authSource=os.getenv("MONGO_DB", "app_mobile"),
    serverSelectionTimeoutMS=3000,
    connectTimeoutMS=3000,
    socketTimeoutMS=3000,
)
mongo_db = mongo_client[os.getenv("MONGO_DB", "app_mobile")]


@contextmanager
def connection():
    # PGHOST/PGUSER/etc. are standard libpq environment variables.
    with psycopg.connect(connect_timeout=5, row_factory=dict_row) as conn:
        yield conn


def query(sql, params=(), *, one=False):
    with connection() as conn:
        cursor = conn.execute(sql, params)
        return cursor.fetchone() if one else cursor.fetchall()
