"""Viewのサブモジュール的なやつ.

元のViewに対してBlueprintを使って参照してもらうやつら
"""
from flask import Blueprint
from flask_restful import Api
from flask_restful import Resource

from v1.users import Users

app = Blueprint('api', __name__, url_prefix=None)
api = Api(app)


class HelloWorld(Resource):
    """Hello World!."""

    def get(self):
        """GETメソッドで受けるやつ."""
        return {'code': 200, 'message': 'Hello World!.'}


# クラスを指定して、次にルートディレクトリからのURIを記載するっぽい
api.add_resource(HelloWorld, '/')


if __name__ == '__main__':
    app.run(debug=True)
