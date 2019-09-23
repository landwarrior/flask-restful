"""モデルモジュール.

データベースとやり取りするためのモジュール
"""
import sqlalchemy as sa
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

from ..config import get_config

CONF = get_config()

Base = declarative_base()


class TableBase:

    @classmethod
    def selects(cls, filters):
        conditions = []
        try:
            with get_conn(CONF.DB_READONLY) as session:
                session.query(cls).filters(*conditions)
        except Exception:
            pass


def get_conn(connstr):
    return __MyDB(connstr)


class __MyDB:

    def __init__(self, connstr):
        self.conn = sa.create_engine(connstr)
        self.session = None

    def __enter__(self):
        Session = sessionmaker(bind=self.conn)
        self.session = Session()
        return self.session

    def __exit__(self):
        self.session.close()
        self.session.dispose()
        self.session = None
