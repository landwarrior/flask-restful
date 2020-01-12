"""View Modules."""
from flask import Blueprint
from flask_restful import Api
from flask_restful import Resource

from views.v1.users import Users
from views.v1.groups import Groups

heartbeat = Blueprint('heartbeat', __name__, url_prefix=None)
heartbeat_api = Api(heartbeat)

v1 = Blueprint('v1', __name__, url_prefix='/v1')
v1_api = Api(v1)


class HelloWorld(Resource):
    """Hello World!."""

    def get(self):
        """GETメソッドで受けるやつ."""
        return {'code': 200, 'message': 'Hello World!.'}


heartbeat_api.add_resource(HelloWorld, '/')

v1_api.add_resource(Users, '/users/<string:user_id>')
v1_api.add_resource(Users, '/users', endpoint='/users')
v1_api.add_resource(Groups, '/groups/<string:group_id>')
v1_api.add_resource(Groups, '/groups', endpoint='/groups')
