FROM python:3.10-bookworm

WORKDIR /app/quetz

COPY requirements.txt config.toml quetz.sqlite init_channels.sql ./
COPY debian.sources /etc/apt/sources.list.d/debian.sources

RUN apt update && \
    apt install sqlite3 && \
    apt-get clean && \
    sqlite3 quetz.sqlite < init_channels.sql

RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple && \
    pip install --upgrade pip && \
    pip install -r requirements.txt && \
    pip cache purge && \
    mkdir channels

EXPOSE 8001
ENTRYPOINT ["quetz", "start", "/app/quetz" ]
CMD ["--host", "0.0.0.0", "--port", "8001", "--supervisor" ]
