"""全般的な設定ファイル."""


def get_config():
    """Get Config Class."""
    return DevConfig


class DevConfig:
    """開発環境用."""

    DEBUG = True
    SQLALCHEMY_DATABASE_URI = '''\
mysql+pymysql://{user}:{password}@{host}/{db}?charset=utf8'''.format(
        user='myaccount',
        password='myaccount',
        host='192.168.33.10',
        db='mydb'
    )
