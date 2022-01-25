FROM python:3.6

RUN pip3 install django

WORKDIR /usr/src/app

COPY . .

WORKDIR ./mysite

CMD ["python3", "manage.py", "runserver", "0:8000"]

EXPOSE 8000
