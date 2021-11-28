"""Usersテーブルのクラス."""
from models import Base, TableBase
import sqlalchemy as sa


class Users(Base, TableBase):
    """users テーブル定義."""

    __tablename__ = 'mst_users'

    user_id = sa.Column('user_id', sa.Integer, primary_key=True)
    user_name = sa.Column('user_name', sa.String(16))
    group_id = sa.Column('group_id', sa.Integer)

    def __init__(self, user_id, user_name, group_id):
        """コンストラクタ."""
        self.user_id = user_id
        self.user_name = user_name
        self.group_id = group_id

    def __repr__(self):
        """なんかよく分からないけど、インサートするのに必要っぽい."""
        return "<{}({}, {}, {})>".format(
            self.__tablename__,
            self.user_id,
            self.user_name,
            self.group_id,
        )
