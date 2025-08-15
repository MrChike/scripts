# --------------------------Scikit-learn--------------------------------
# Clone the scikit-learn repository with all submodules
git clone git@github.com:MrChike/scikit-learn.git

# Enter the cloned repository directory
cd scikit-learn

git checkout -b dev

docker run \
  --dns=8.8.8.8 \
  --privileged \
  --name sklearn_dev \
  --add-host="host.docker.internal:host-gateway" \
  -p 8888:8888 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(pwd):/sklearn_dev \
  -w /sklearn_dev \
  -e PYTHONDONTWRITEBYTECODE=1 \
  -e PYTHONUNBUFFERED=1 \
  -it python:3.10-bookworm bash

cat <<EOF > setup.sh
#!/bin/bash

git config --global --add safe.directory /sklearn_dev

apt update && apt upgrade -y && apt install -y \\
    python3-pip \\
    build-essential \\
    libffi-dev \\
    libssl-dev \\
    libblas3 \\
    liblapack3 \\
    gfortran \\
    apt-utils \\
    vim \\
    net-tools \\
    procps \\
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install Python build tools and dev dependencies
pip3 install --root-user-action=ignore --upgrade pip setuptools wheel
pip3 install --root-user-action=ignore \\
    wheel \\
    numpy \\
    scipy \\
    cython \\
    meson-python \\
    ninja \\
    ipython \\
    notebook \\
    jupyterlab_vim \\
    jupytext \\

echo "  " >> sklearn/feature_extraction/_hash.py
echo '    print("Changes made by Mrchike")' >> sklearn/feature_extraction/_hash.py

rm -rf build dist *.egg-info && find . -name '*.pyc' -delete && find . -name '__pycache__' -delete

pip3 install --editable . --verbose --no-build-isolation --config-settings editable-verbose=true --root-user-action=ignore
jupyter-lab . --allow-root --ip=0.0.0.0 --port=8888

EOF

# You can now start working on your changes
# NB The project has already been installed in editable mode so you don't need to rebuild upon 
# every change but just exit from your python shell where you are executing sklearn and import it again
# Then the changes will reflect

# Import the modified module to see changes
# from sklearn.feature_extraction import FeatureHasher
