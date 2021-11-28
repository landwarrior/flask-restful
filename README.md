# flask-restful

Flask-RESTful を Docker で動かすサンプルを作成するために用意しました。
Docker Swarm での構築のサンプルのため、 VM は合計 3 台必要です。

- flask-primary
- flask-secondary
- mysq-server

# 前提条件

- Windows 11 Pro バージョン 21H2
- VirtualBox 6.1.28
- Vagrant 2.2.18

# 環境構築手順

1. VirtualBox をインストール
1. Vagrant をインストール
1. vagrant box を追加する
    ```console
    vagrant box add bento/almalinux-8.4
    ```
1. 任意のディレクトリで、 Vagrant を使用するための準備をする
    - 合計 3 台分用意してください。
    ```console
    mkdir primary
    mkdir secondary
    mkdir mysql
    cd primary
    vagrant init bento/almalinux-8.4
    cd ../secondary
    vagrant init bento/almalinux-8.4
    cd ../mysql
    vagrant init bento/almalinux-8.4
    ```
1. それぞれの Vagrantfile を編集する
    - `config.vm.box_version = "202109.10.0"` を `config.vm.box = "bento/almalinux-8.4"` の直下に追加する
    - `config.vm.network` のコメントアウトを外す
        - primary は `192.168.33.10` でアクセス可能にする
        - secondary は `192.168.33.11` でアクセス可能にする
        - mysql-server は `192.168.33.20` でアクセス可能にする
    - `config.vm.network` の下に、 `config.vm.hostname` を追加する（必須ではありません）
        - `192.168.33.10` の場合、 `config.vm.hostname = "flask-primary"`
        - `192.168.33.11` の場合、 `config.vm.hostname = "flask-secondary"`
        - `192.168.33.20` の場合、 `config.vm.hostname = "mysql-server"`
    - `config.vm.synced_folder` のコメントアウトを外し、 `../data` の部分をこのリポジトリを clone した時のルートディレクトリにする
        - つまり、 `/vagrant_data` 配下にマウントしていることが前提
        - 例として、以下のように設定する
        ```console
        config.vm.synced_folder "D:/program_src/flask-restful", "/vagrant_data"
        ```
1. Vagrant を立ち上げる（3台とも）
    ```console
    vagrant up
    ```
1. 立ち上がったかどうか確認する
    ```console
    vagrnat global-status
    ```
1. VM にログインし、シェルスクリプトを起動する
    - `vagrant ssh {id}` でそれぞれの VM にログインして作業する
    - flask-primary の場合、以下
    ```console
    sudo /vagrant_data/provisioning_primary.sh
    ```
    - flask-secondary の場合、以下
    ```console
    sudo /vagrant_data/provisioning_secondary.sh
    ```
    - mysql-server の場合、以下
    ```console
    sudo /vagrant_data/provisioning_db.sh
    ```

# コンテナのローリングアップデート

無停止でコンテナの更新ができる（はず）

1. ソース修正をしたら、 docker イメージを作り直すためにシェルをたたく
    - flask-primary の場合、以下
    ```console
    sudo /vagrant_data/provisioning_primary.sh
    ```
    - flask-secondary の場合、以下
    ```console
    sudo /vagrant_data/provisioning_secondary.sh
    ```
1. 新しいイメージが登録されたか確認する
    - flask-primary および flask-secondary それぞれで以下コマンドを実行し、作成時刻を確認
    ```console
    sudo docker images
    ```
1. 以下のコマンドを実行し、ローリングアップデートを行う（flask-primary のみでいいのかが未確認）
    - flask-primary で以下のコマンドを実行する
    ```console
    docker service update test_flask --update-parallelism 1 --update-delay 10s --image flask --with-registry-auth
    ```
