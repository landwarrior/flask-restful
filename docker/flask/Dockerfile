FROM python:3.6-alpine

RUN mkdir -p /var/app 2> /dev/null
RUN mkdir -p /var/app/flask 2> /dev/null
RUN apk add gcc build-base linux-headers
COPY requirements.txt /var/app/flask/
RUN pip3 install -r /var/app/flask/requirements.txt

COPY wsgi /var/app/flask/wsgi/
EXPOSE 5000

CMD ["uwsgi", "--ini", "/var/app/flask/wsgi/uwsgi.ini"]
