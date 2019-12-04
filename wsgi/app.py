"""Flask Application."""

from flask import Flask

from views import heartbeat
from views import v1

from config import get_config


def create_app():
    """Flaskのアプリケーションを作成."""
    app = Flask(__name__)
    app.register_blueprint(heartbeat)
    app.register_blueprint(v1)

    app.config.from_object(get_config())

    return app
