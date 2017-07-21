# FlashX Docker image with ssh port forwarding and general ubuntu hackery
# pull from a repo containing a full fngs installation, which includes ndmg
# and other useful packages prebuilt that do not do well with other things

FROM ericw95/flashx:python2
MAINTAINER Eric Bridgeford <ebridge2@jhu.edu>


#--------Environment Variables-----------------------------------------------#
ENV LIBXP_URL http://mirrors.kernel.org/ubuntu/pool/main/libx/libxp/libxp6_1.0.2-2_amd64.deb
ENV CRAN_URL https://cran.rstudio.com/

#--------Initial Configuration-----------------------------------------------#
# download/install basic dependencies, and set up python
RUN apt-get update
RUN apt-get install -y zip unzip vim git python-dev curl gsl-bin

RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py

RUN \
    apt-get install -y git libpng-dev libfreetype6-dev pkg-config \
    zlib1g-dev g++ vim

RUN apt-get install -y software-properties-common python-software-properties
RUN add-apt-repository universe
RUN apt-get update
RUN apt-get install -y tcsh xfonts-base python-qt4       \
                        gsl-bin netpbm gnome-tweak-tool   \
                        libjpeg62 xvfb xterm vim curl
RUN apt-get install -y libglu1-mesa-dev libglw1-mesa     \
                        libxm4 build-essential

RUN R -e "devtools::install_github('ebridge2/Discriminability')"
RUN R -e "install.packages(c('Rmisc', 'png', 'stringr', 'mclust'), repos='${CRAN_URL}')"
RUN R -e "source('https://bioconductor.org/biocLite.R'); biocLite('rhdf5')"
#-------JUPYTER SETUP--------------------------------------------------------#

RUN useradd -m -s /bin/bash sic-user

RUN mkdir -p /home/sic-user/.jupyter
COPY jupyter_notebook_config.py /home/sic-user/.jupyter
WORKDIR /home/sic-user

USER sic-user

EXPOSE 8888
CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0"]
