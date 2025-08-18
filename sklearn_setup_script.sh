# --------------------------Scikit-learn--------------------------------

# Clone the repo via SSH
git clone --depth=1 git@github.com:MrChike/scikit-learn.git

# Enter the repo
cd scikit-learn

# Create and switch to 'dev' branch
git checkout -b dev

# Start a Docker container for development
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
  -it python:3.10-bookworm \
  bash -c "$(
    cat <<EOF
    # Allow Git access to project dir
    git config --global --add safe.directory /sklearn_dev

    # Install system packages
    apt update && apt upgrade -y && apt install -y \
        python3-pip \
        build-essential \
        libffi-dev \
        libssl-dev \
        libblas3 \
        liblapack3 \
        gfortran \
        apt-utils \
        vim \
        net-tools \
        procps \
        && rm -rf /var/lib/apt/lists/*

    # Upgrade Python tools
    pip3 install --root-user-action=ignore --upgrade pip setuptools wheel

    # Install Python deps
    pip3 install --root-user-action=ignore \
        wheel numpy scipy cython \
        meson-python ninja ipython \
        notebook jupyterlab_vim jupytext

    # Inject test print into a source file
    echo "  " >> sklearn/feature_extraction/_hash.py
    echo '    print("Changes made by Mrchike")' >> sklearn/feature_extraction/_hash.py

    # Clean old builds
    rm -rf build dist *.egg-info && find . -name '*.pyc' -delete && find . -name '__pycache__' -delete

    # Install in editable mode
    pip3 install --editable . --verbose --no-build-isolation --config-settings editable-verbose=true --root-user-action=ignore

    # Start Jupyter Lab
    jupyter-lab . --allow-root --ip=0.0.0.0 --port=8888
EOF
)"

# --------------------------Usage Notes----------------------------

# Code changes apply instantly (editable mode)
# Just restart Python or re-import the module

# Example test:
# from sklearn.feature_extraction import FeatureHasher
