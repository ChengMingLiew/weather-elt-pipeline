import os

PREVENT_UNSAFE_DB_CONNECTIONS = False

SQLALCHEMY_DATABASE_URI = os.environ.get(
    "SQLALCHEMY_DATABASE_URI",
    "postgresql+psycopg2://superset:superset@superset_db:5432/superset"
)

def FLASK_APP_MUTATOR(app):
    with app.app_context():
        try:
            from superset import db
            from superset.models.core import Database

            existing = db.session.query(Database).filter_by(database_name="weather_db").first()
            if not existing:
                database = Database(
                    database_name="weather_db",
                    sqlalchemy_uri="postgresql+psycopg2://user:password@postgres_db:5432/weather_db",
                    expose_in_sqllab=True,
                )
                db.session.add(database)
                db.session.commit()
        except Exception:
            db.session.rollback()