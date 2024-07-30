# init network
docker network create python_proxy

# start
docker run -d --name conda_proxy \
          --network python_proxy \
          -p 8001:8001 \
          -v ~/Downloads/20231114/conda_proxy:/app/quetz/channels \
          conda_proxy:latest

# logs
docker logs conda_proxy

# inter
docker exec -it conda_proxy bash

# stop
docker stop conda_proxy && docker rm conda_proxy

# run test
conda create -n test -c http://localhost:8001/get/conda-forge -n test python=3.10

conda env remove -n test  -y