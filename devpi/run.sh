# init network
docker network create python_proxy

# start
docker run -d --name pypi_proxy \
          --network python_proxy \
          -p 8002:8002 \
          -v ~/Downloads/20231114/pypi_proxy:/app/devpi \
          pypi_proxy:latest

# logs
docker logs -f pypi_proxy

# inter
docker exec -it pypi_proxy bash

# stop
docker stop pypi_proxy && docker rm pypi_proxy

# run test
pip install -i http://localhost:8002/root/pypi/+simple/ flask




docker stop pypi_proxy && docker rm pypi_proxy
docker run -it --rm --name pypi_proxy \
          --network python_proxy \
          -p 8002:8002 \
          -v ~/Downloads/20231114/pypi_proxy:/app/devpi/+files \
          pypi_proxy:latest bash

 docker stop pypi_proxy && docker rm pypi_proxy && \
docker run -d --name pypi_proxy \
          --network python_proxy \
          -p 8002:8002 \
          -v ~/Downloads/20231114/pypi_proxy:/app/devpi \
          pypi_proxy:latest && \
        docker logs -f pypi_proxy