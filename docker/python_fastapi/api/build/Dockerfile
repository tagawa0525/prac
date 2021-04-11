# https://qiita.com/satto_sann/items/fcd3832a1fea2c607b85
FROM python:3.9.4-slim

WORKDIR /app

# コンテナ内で必要なパッケージをインストール
RUN pip install --no-cache-dir --trusted-host pypi.python.org uvicorn fastapi

# FastAPIを待機
CMD ["uvicorn", "main:app", "--reload", "--host", "0.0.0.0", "--port", "80"]

