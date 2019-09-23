"""ユーザーのAPI.

/v1/users
"""
from flask_restful import Resource


class Users(Resource):
    """ユーザー情報を取得・更新する."""

    def get(self):
        """Get."""
        return {'code': 200, 'message': 'ok'}

    def put(self):
        """Put."""
        return {'code': 200, 'message': 'ok'}

    def post(self):
        """Post."""
        return {'code': 200, 'message': 'ok'}
