"""Flask アプリケーション準備."""
from views import heartbeat_api
from views import v1_api
from flask import Flask

from database import init_db
from config import get_config


def create_app():
    """Flaskのアプリケーションを作成."""
    app = Flask(__name__)
    app.register_blueprint(heartbeat_api)
    app.register_blueprint(v1_api)

    app.config.from_object(get_config())
    init_db(app)

    return app
