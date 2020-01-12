"""Flaskインスタンス生成."""
import traceback
from flask import Flask
from flask import request
from flask_restful import Api

from views import heartbeat
from views import v1

from config import get_config
from libs.MyLogger import logger

app = Flask(__name__)
app.register_blueprint(heartbeat)
app.register_blueprint(v1)

app.config.from_object(get_config())
# 404 not found の場合のレスポンスを json 形式で返すために catch_all_404s を True にしておく必要あり
# こうしないと、存在しないURIを叩かれたら HTML を返してしまう
api = Api(app, catch_all_404s=True)


@app.before_request
def before():
    _headers = str(request.headers).strip().replace(
        '\r', '').replace('\n', ', ')
    _log = '[REQUEST] [URL]{} [METHOD]{} [HEADERS]{}'.format(
        request.url, request.method, _headers
    )
    try:
        j_data = request.json
        if j_data:
            _log += ' [JSON]{}'.format(j_data)
    except Exception:
        return ({'code': 400, 'message': 'not json data. {}'.format(request.data)}, 400)
    finally:
        logger.info(_log)
    if request.method in ['POST', 'PUT'] and not j_data:
        return ({'code': 400, 'message': 'not json data'}, 400)


@app.after_request
def after(response):
    try:
        _log = '[RESPONSE] [STATUS_CODE]{} [DATA]{}'.format(
            response.status_code, response.json)
        logger.info(_log)
    except Exception:
        logger.info(traceback.format_exc().replace('\n', '\\n'))
    return response


if __name__ == '__main__':
    app.run(debug=True)
