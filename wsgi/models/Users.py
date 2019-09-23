"""Usersテーブルのクラス."""
from models import db


class Users(db.Model):
    """users テーブル定義."""

    __tablename__ = 'users'

    user_id = db.Column('user_id', db.Integer, primary_key=True)
    user_name = db.Column('user_name', db.String(16))
    age = db.Column('age', db.Integer)
    sex = db.Column('sex', db.String(8))

    def __init__(self, user_id, user_name, age, sex):
        """コンストラクタ."""
        self.user_id = user_id
        self.user_name = user_name
        self.age = age
        self.sex = sex

    def __repr__(self):
        """なんかよく分からないけど、インサートするのに必要っぽい."""
        return "<{}({}, {}, {}, {})>".format(
            self.__tablename__,
            self.user_id,
            self.user_name,
            self.age,
            self.sex,
        )
