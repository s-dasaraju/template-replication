# syntax=docker/dockerfile:1.2
FROM dataeditors/stata17:2022-07-19

# switch to root user to install packages
USER root
ARG DEBIAN_FRONTEND=noninteractive
RUN cd /home/statauser

############### install required software (Linux Debian)
RUN apt-get update \
    && apt-get install tzdata --yes \
    && apt-get install binutils --yes \
    && apt-get install wget --yes \
    && apt-get install software-properties-common --yes \
    && apt-get install curl --yes \
    && apt-get install git-lfs --yes \
    && apt-get install lyx --yes \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# Make lyx robust to shared library error that ocurred on Sherlock (https://stackoverflow.com/questions/63627955/cant-load-shared-library-libqt5core-so-5)
RUN strip --remove-section=.note.ABI-tag /usr/lib/x86_64-linux-gnu/libQt5Core.so.5

############### install Conda
# instructions from https://stackoverflow.com/questions/64090326/bash-script-to-install-conda-leads-to-conda-command-not-found-unless-i-run-b
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O conda.sh
COPY setup/conda_env.yaml conda_env.yaml
RUN ["/bin/bash", "conda.sh", "-b", "-p", "/home/statauser/miniconda3"]
RUN rm -f conda.sh
RUN /home/statauser/miniconda3/bin/conda init bash
############### install Conda

# https://conda-forge.org/docs/user/tipsandtricks.html
# Change channel priority setting to strict (this is robust to having Python and R dependencies simultaneously)
RUN /home/statauser/miniconda3/bin/conda config --set channel_priority strict

# https://stackoverflow.com/questions/20635472/using-the-run-instruction-in-a-dockerfile-with-source-does-not-work
RUN /home/statauser/miniconda3/bin/conda env create -f conda_env.yaml
ENV PATH "$PATH:/home/statauser/miniconda3/bin"

# Create required template directories and make sure user is owner
RUN mkdir ~/.ssh \
    && chown statauser:stata ~/.ssh 
RUN mkdir /home/statauser/dropbox \
    && chown statauser:stata /home/statauser/dropbox

# Create a folder to work in
RUN mkdir /home/statauser/template \
    && chown statauser:stata /home/statauser/template

# Stata setup from AEA Data Editor 
RUN --mount=type=secret,id=statalic,dst=/Applications/Stata/stata.lic \
    /usr/local/stata/stata-mp do /code/setup.do

# Make user root writable and set working directory
WORKDIR /home/statauser/template

# Change back to non-root user
USER statauser:stata

# Initialize conda and restart shell
RUN conda init --all
RUN exec bash

# run the master file
ENTRYPOINT ["/bin/bash"]