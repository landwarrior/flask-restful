"""グループのAPI.

/v1/groups
"""
from flask_restful import Resource
from flask import request
from sqlalchemy.orm.exc import NoResultFound

from models.Groups import Groups as Groups_DB
from libs.Response import error_response


class Groups(Resource):
    """ユーザー情報を取得・更新する."""

    @error_response
    def get(self, group_id=None):
        """データ取得."""
        if group_id:
            conditions = {'group_id': group_id}
        else:
            conditions = {}
        group_data = Groups_DB.selects(conditions)
        return {'code': 200, 'group_data': group_data}

    @error_response
    def put(self, group_id=None):
        """データ登録."""
        if group_id:
            return ({'code': 400, 'message': 'can not set group_id'}, 400)
        j_data = request.json
        must_keys = ['group_name']
        for key in must_keys:
            if key not in j_data.keys():
                return ({
                    'code': 400,
                    'message': '{} must set in json'.format(key)
                }, 400)

        ins_data = {
            'group_id': j_data.get('group_id', None),
            'group_name': j_data.get('group_name'),
        }
        Groups_DB.inserts([ins_data])
        return {'code': 200, 'message': 'ok'}

    @error_response
    def post(self, group_id=None):
        """データ更新."""
        if not group_id:
            return ({'code': 404, 'message': 'no target data'}, 404)
        j_data = request.json
        try:
            Groups_DB.update({'group_id': group_id}, {
                'group_name': j_data.get('group_name')
            })
        except NoResultFound:
            return ({'code': 404, 'message': 'no target data'}, 404)
        return {'code': 200, 'message': 'ok'}

    @error_response
    def delete(self, group_id=None):
        """データ削除."""
        if not group_id:
            return ({'code': 404, 'message': 'no target data'}, 404)
        try:
            Groups_DB.delete({'group_id': group_id})
        except NoResultFound:
            return ({'code': 404, 'message': 'no target data'}, 404)
        return {'code': 200, 'message': 'ok'}
