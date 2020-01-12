"""groupsテーブルのクラス."""
from models import Base, TableBase
import sqlalchemy as sa


class Groups(Base, TableBase):
    """groups テーブル定義."""

    __tablename__ = 'groups'

    group_id = sa.Column('group_id', sa.Integer, primary_key=True)
    group_name = sa.Column('group_name', sa.String(32))

    def __init__(self, group_id, group_name):
        """コンストラクタ."""
        self.group_id = group_id
        self.group_name = group_name

    def __repr__(self):
        """なんかよく分からないけど、インサートするのに必要っぽい."""
        return "<{}({}, {}, {}, {})>".format(
            self.__tablename__,
            self.user_id,
            self.user_name,
            self.age,
            self.sex,
        )
