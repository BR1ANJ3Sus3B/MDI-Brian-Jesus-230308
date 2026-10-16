import logging
from datetime import datetime, timezone

from pymongo.errors import PyMongoError

from app.database.connections import mongo_db


def record_activity(actor, action, task_id):
    event = {"actor": actor, "action": action, "task_id": task_id, "at": datetime.now(timezone.utc)}
    try:
        mongo_db.activity.insert_one(event.copy())
        mongo_db.logs.insert_one({**event, "level": "info", "source": "api"})
        return True
    except PyMongoError:
        # Task mutation already committed. Report partial auditing honestly.
        logging.warning("Activity store unavailable; task mutation committed")
        return False
