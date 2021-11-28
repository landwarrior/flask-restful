FROM python:3.9-slim

RUN mkdir -p /var/app 2> /dev/null
RUN mkdir -p /var/app/flask 2> /dev/null
RUN apt update
RUN apt install -y gcc
COPY requirements.txt /var/app/flask/
RUN pip3 install -r /var/app/flask/requirements.txt

COPY wsgi /var/app/flask/wsgi/
EXPOSE 5000

CMD ["uwsgi", "--ini", "/var/app/flask/wsgi/uwsgi.ini"]
