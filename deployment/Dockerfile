FROM AWS_ECR_ID/ENV-PROJECT_NAME-base:python-3.12-slim.v1.0

WORKDIR /vova

COPY ./requirements.txt ./requirements.txt

RUN set -eux && \
    pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

COPY --chown=vova:vova ./app ./
COPY --chown=vova:vova ./tests /tests

USER vova

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]