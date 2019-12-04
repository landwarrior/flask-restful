"""全般的な設定ファイル."""


def get_config():
    """Get Config Class."""
    # 将来的には環境ごとに分けたい
    return DevConfig


class BaseConfig:
    """ベースとなるもの."""

    DEBUG = True
    DB_URI = ''


class DevConfig(BaseConfig):
    """開発環境用."""

    DB_URI = '''\
mysql+pymysql: // {user}: {password}@{host}/{db}?charset = utf8'''.format(
        user='myaccount',
        password='myaccount',
        host='192.168.33.10',
        db='mydb'
    )
