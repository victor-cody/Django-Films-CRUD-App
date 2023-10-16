# syntax=docker/dockerfile:1.4

# ARG PYTHON_VERSION=3.11-slim-bullseye

# FROM python:${PYTHON_VERSION}

# ENV PYTHONDONTWRITEBYTECODE 1
# ENV PYTHONUNBUFFERED 1


# RUN mkdir -p /code

# WORKDIR /code

# COPY requirements.txt /tmp/requirements.txt
# RUN set -ex && \
#     pip install --upgrade pip && \
#     pip install -r /tmp/requirements.txt && \
#     rm -rf /root/.cache/
# COPY . /code

# CMD ["gunicorn", "--bind", ":8000", "--workers", "2", "project.wsgi"]


FROM python:latest

# install psycopg2 dependencies.
RUN apt-get update && apt-get install -y \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 8000

WORKDIR /app 

COPY requirements.txt /app

RUN pip3 install -r requirements.txt --no-cache-dir

COPY . /app 

RUN python manage.py collectstatic --noinput

CMD ["gunicorn", "--bind", ":8000", "project.wsgi"]
