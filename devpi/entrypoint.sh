#!/usr/bin/env bash
supervisord -c gen-config/supervisord.conf  && \
sleep 30s && \
devpi use http://localhost:$PORT && \
devpi user --create $USER password=$USER && \
devpi login $USER --password $USER && \
devpi index --create $USER/proxy type=mirror mirror_web_url_fmt=https://pypi.tuna.tsinghua.edu.cn/simple/{name}/ mirror_url=https://pypi.tuna.tsinghua.edu.cn/simple/ volatile=False && \
devpi logout && \
tail -f /dev/null
