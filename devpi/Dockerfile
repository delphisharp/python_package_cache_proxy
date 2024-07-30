FROM python:3.10-bookworm

WORKDIR /app
ENV APP_DIR=/app/devpi
ENV PORT=8002

COPY requirements.txt ./

RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple && \
    pip install --upgrade pip && \
    pip install -r requirements.txt && \
    pip cache purge && \
    devpi-init --serverdir $APP_DIR --root-passwd root && \
    devpi-gen-config --host 0.0.0.0 --port $PORT --mirror-cache-expiry 86400 --serverdir $APP_DIR

COPY mirror.py /usr/local/lib/python3.10/site-packages/devpi_server/mirror.py
COPY main.py /usr/local/lib/python3.10/site-packages/devpi_server/main.py

EXPOSE $PORT

CMD ["/usr/local/bin/supervisord" ,"-c", "/app/gen-config/supervisord.conf", "-n"]