"""レスポンスを書き換えるデコレータを定義."""
import traceback

from libs.MyLogger import logger


def error_response(func):
    """Flask-RESTful の標準機能でハンドリングできるはずだけど分からなかったので用意."""
    def _wrap(*args, **kwargs):
        try:
            return func(*args, **kwargs)
        except Exception:
            logger.error(traceback.format_exc().replace('\n', '\\n'))
            return ({'code': 500, 'message': 'internal server error'}, 500)
    return _wrap
