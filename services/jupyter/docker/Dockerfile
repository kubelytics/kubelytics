ARG DOCKER_USER
ARG HADOOP_VERSION
ARG SPARK_VERSION
FROM ${DOCKER_USER}/spark:${SPARK_VERSION}-${HADOOP_VERSION}

ARG MINICONDA_VERSION="4.5.11"
ARG JUPYTER_VERSION
ARG MINICONDA_BIN="https://repo.continuum.io/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh"
ENV PYTHONPATH "$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.7-src.zip"

USER root

ENV CONDA_HOME "/conda"
ENV PATH=$CONDA_HOME/bin:$PATH
ENV XDG_CACHE_HOME ${HOME}/.cache/

RUN set -x && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
    /bin/bash Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -f -b -p $CONDA_HOME && \
    rm Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
    $CONDA_HOME/bin/conda config --system --prepend channels conda-forge && \
    $CONDA_HOME/bin/conda config --system --set auto_update_conda false && \
    $CONDA_HOME/bin/conda config --system --set show_channel_urls true && \
    $CONDA_HOME/bin/conda install --quiet --yes conda="${MINICONDA_VERSION}" && \
    apt-get update && apt-get install -yq --no-install-recommends \
    build-essential \
    git \
    inkscape \
    jed \
    libsm6 \
    libxext-dev \
    libxrender1 \
    lmodern \
    netcat \
    pandoc \
    texlive-fonts-extra \
    texlive-fonts-recommended \
    texlive-generic-recommended \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-xetex \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /etc/ipython && \
    { \
      echo 'c = get_config()'; \
      echo 'c.IPKernelApp.extensions = ["sql"]'; \
      echo 'c.InteractiveShellApp.extensions.append("sql")'; \
      echo 'c.SqlMagic.autocommit=False'; \
	  } > /etc/ipython/ipython_config.py && \
    conda install --quiet --yes 'tini=0.18.0' \
    'notebook=5.6.*' \
    "jupyterhub==${JUPYTER_VERSION}" \
    'conda-forge::blas=*=openblas' \
    'ipywidgets=7.2*' \
    'pandas=0.23*' \
    'numexpr=2.6*' \
    'matplotlib=2.2*' \
    'scipy=1.1*' \
    'seaborn=0.9*' \
    'scikit-learn=0.19*' \
    'scikit-image=0.14*' \
    'sympy=1.1*' \
    'cython=0.28*' \
    'patsy=0.5*' \
    'statsmodels=0.9*' \
    'cloudpickle=0.5*' \
    'dill=0.2*' \
    'numba=0.38*' \
    'bokeh=0.12*' \
    'sqlalchemy=1.2*' \
    'hdf5=1.10*' \
    'h5py=2.7*' \
    'vincent=0.4.*' \
    'beautifulsoup4=4.6.*' \
    'protobuf=3.*' \
    'xlrd' \
    'pyarrow' \
    'tensorflow=1.5*' \
    'keras=2.1*' \
    'jupyterlab==0.35.2' && \
    pip install ipython-sql \
    pyhive[presto] \
    nuclio-jupyter \
    nbgitpuller \
    jupyterlab-git && \
    pip install --no-cache-dir \
    https://dist.apache.org/repos/dist/dev/incubator/toree/0.3.0-incubating-rc1/toree-pip/toree-0.3.0.tar.gz && \
    jupyter toree install --sys-prefix && \
    jupyter labextension install @jupyterlab/hub-extension@^0.12.0 && \
    jupyter notebook --generate-config && \
    jupyter nbextension enable --py widgetsnbextension --sys-prefix && \
    jupyter labextension install @jupyter-widgets/jupyterlab-manager@^0.38.1 && \
    jupyter labextension install jupyterlab_bokeh@^0.6.3 && \
    jupyter labextension install @mflevine/jupyterlab_html && \
    jupyter labextension install @jupyterlab/toc  && \
    jupyter labextension install @jupyterlab/hub-extension  && \
    jupyter labextension install @jupyterlab/git  && \
    jupyter serverextension enable --user jupyterlab_discovery  && \
    jupyter serverextension enable --py jupyterlab_git && \
    jupyter serverextension enable --py nbgitpuller --sys-prefix && \
    git clone https://github.com/PAIR-code/facets.git && \
    cd facets && \
    jupyter nbextension install facets-dist/ --sys-prefix && \
    cd .. && \
    rm -rf facets && \
    MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
    npm cache clean --force && \
    rm -rf $CONDA_HOME/share/jupyter/lab/staging && \
    conda list tini | grep tini | tr -s ' ' | cut -d ' ' -f 1,2 >> $CONDA_HOME/conda-meta/pinned && \
    conda remove --quiet --yes --force qt pyqt && \
    conda clean -tipsy && \
    rm -rf ${HOME}/.cache && \
    rm -rf ${HOME}/.node-gyp && \
    chown -R ${CONTAINER_USER}:${CONTAINER_USER} $CONDA_HOME

USER $CONTAINER_USER
