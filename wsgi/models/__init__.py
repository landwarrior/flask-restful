"""モデルモジュール.

データベースとやり取りするためのモジュール
"""
from typing import Dict, List

import sqlalchemy as sa
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

from config import get_config
from libs.MyLogger import logger

CONF = get_config()

Base = declarative_base()


class TableBase:
    """各テーブルクラスでデフォルトで使うメソッドを定義しておきたい."""

    @classmethod
    def selects(cls, conditions: dict) -> List[Dict]:
        """データ取得."""
        if not conditions:
            conditions = {}
        filter = []
        for key, val in conditions.items():
            if getattr(cls, key, False):
                filter.append(getattr(cls, key) == val)
        with get_conn(CONF.DB_URI) as session:
            response = []
            for data in session.query(cls).filter(*filter):
                # 余計なのがあるので削除する
                if data.__dict__.get('_sa_instance_state'):
                    del data.__dict__['_sa_instance_state']
                response.append(data.__dict__)
            return response

    @classmethod
    def inserts(cls, items: List[Dict]) -> None:
        """データ登録(bulk insert)."""
        inserts = []
        for item in items:
            inserts.append(cls(**item))
        with get_conn(CONF.DB_URI) as session:
            session.bulk_save_objects(inserts)
            session.commit()

    @classmethod
    def update(cls, pkey: dict, upd_items: dict) -> None:
        """データ更新."""
        filter = []
        for key, val in pkey.items():
            if getattr(cls, key, False):
                filter.append(getattr(cls, key) == val)
        with get_conn(CONF.DB_URI) as session:
            data = session.query(cls).filter(*filter).one()
            for key, val in upd_items.items():
                setattr(data, key, val)
            session.commit()

    @classmethod
    def delete(cls, pkey: dict) -> None:
        """データ削除."""
        filter = []
        for key, val in pkey.items():
            if getattr(cls, key, False):
                filter.append(getattr(cls, key) == val)
        with get_conn(CONF.DB_URI) as session:
            session.query(cls).filter(*filter).one()
            session.query(cls).filter(*filter).delete()
            session.commit()


def get_conn(connstr):
    return __MyDB(connstr)


class __MyDB:

    def __init__(self, connstr: str):
        self.conn = sa.create_engine(connstr)
        self.session = None

    def __enter__(self):
        Session = sessionmaker(bind=self.conn)
        self.session = Session()
        return self.session

    def __exit__(self, *args, **kwagrs):
        try:
            self.session.close()
            self.session.dispose()
        except Exception:
            pass
        finally:
            self.session = None
