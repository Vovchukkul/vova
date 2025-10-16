FROM python:3.12-slim

WORKDIR /usr/src/app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONBUFFERED=1
# bigger size of image for dev, but in prod version is preferable change to `on`
ENV PIP_NO_CACHE_DIR=off

RUN apt-get update && apt-get install -y --no-install-recommends  \
    build-essential \
    dos2unix \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

COPY app ./app
COPY ./commands /commands

RUN dos2unix /commands/*.sh
RUN chmod +x /commands/*.sh # make them executable

RUN adduser --disabled-password --gecos '' backend
USER backend

EXPOSE 8000