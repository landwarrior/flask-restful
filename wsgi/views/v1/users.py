"""ユーザーのAPI.

/v1/users
"""
from flask_restful import Resource
from flask import request
from sqlalchemy.orm.exc import NoResultFound

from models.Users import Users as Users_DB
from libs.Response import error_response


class Users(Resource):
    """ユーザー情報を取得・更新する."""

    @error_response
    def get(self, user_id=None):
        """データ取得."""
        if user_id:
            conditions = {'user_id': user_id}
        else:
            conditions = {}
        user_data = Users_DB.selects(conditions)
        return {'code': 200, 'user_data': user_data}

    @error_response
    def put(self, user_id=None):
        """データ登録."""
        if user_id:
            return ({'code': 400, 'message': 'can not set user_id'}, 400)
        j_data = request.json
        must_keys = ['user_name', 'group_id']
        for key in must_keys:
            if key not in j_data.keys():
                return ({
                    'code': 400,
                    'message': '{} must set in json'.format(key)
                }, 400)

        ins_data = {
            'user_id': j_data.get('user_id', None),
            'user_name': j_data.get('user_name'),
            'group_id': j_data.get('group_id'),
        }
        Users_DB.inserts([ins_data])
        return {'code': 200, 'message': 'ok'}

    @error_response
    def post(self, user_id=None):
        """データ更新."""
        if not user_id:
            return ({'code': 404, 'message': 'no target data'}, 404)
        j_data = request.json
        try:
            upd_data = {}
            if j_data.get('user_name'):
                upd_data['user_name'] = j_data.get('user_name')
            if j_data.get('group_id'):
                upd_data['group_id'] = j_data.get('group_id')

            Users_DB.update({'user_id': user_id}, upd_data)
        except NoResultFound:
            return ({'code': 404, 'message': 'no target data'}, 404)
        return {'code': 200, 'message': 'ok'}

    @error_response
    def delete(self, user_id=None):
        """データ削除."""
        if not user_id:
            return ({'code': 404, 'message': 'no target data'}, 404)
        try:
            Users_DB.delete({'user_id': user_id})
        except NoResultFound:
            return ({'code': 404, 'message': 'no target data'}, 404)
        return {'code': 200, 'message': 'ok'}
