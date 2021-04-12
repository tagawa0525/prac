# https://qiita.com/satto_sann/items/fcd3832a1fea2c607b85
FROM python:3.9.4-slim

WORKDIR /app

# コンテナ内で必要なパッケージをインストール
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		libpq5 \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir --trusted-host pypi.python.org \
		uvicorn fastapi  \
		databases psycopg2-binary sqlalchemy asyncpg

# FastAPIを待機
CMD ["uvicorn", "main:app", "--reload", "--host", "0.0.0.0", "--port", "80"]

