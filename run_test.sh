
# nginx 直连测试 cond-forge
conda clean -ay
pip3 cache purge
conda create -n test -c http://localhost:8003/get/cloud/conda-forge  python=3.10
conda activate test
pip3 install -i http://localhost:8004/root/pypi/+simple/ pyspark
conda deactivate
conda env remove -n test  -y

# nginx 直连测试 conda main
conda clean -ay
pip3 cache purge
conda create -n test -c http://localhost:8003/get/pkgs/main  python=3.10
conda activate test
pip3 install -i http://localhost:8004/root/pypi/+simple/ pyspark
conda deactivate
conda env remove -n test  -y



# 修改 ~/.condarc 后验证

#验证 conda-forge
conda clean -ay
pip3 cache purge
conda create -n test python=3.10
pip3 config set global.index-url http://localhost:8004/root/pypi/+simple/
pip3 install pyspark
conda deactivate
conda env remove -n test  -y

#验证 conda main
conda clean -ay
pip3 cache purge
conda create -n test -c main python=3.10
pip3 config set global.index-url http://localhost:8004/root/pypi/+simple/
pip3 install pyspark
conda deactivate
conda env remove -n test  -y