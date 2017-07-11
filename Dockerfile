# FlashX Docker image with ssh port forwarding and general ubuntu hackery
# pull from a repo containing a full fngs installation, which includes ndmg
# and other useful packages prebuilt that do not do well with other things

FROM flashx/flashx
MAINTAINER Eric Bridgeford <ebridge2@jhu.edu>


#--------Environment Variables-----------------------------------------------#
ENV NDMG_URL https://github.com/neurodata/ndmg.git
ENV ATLASES http://openconnecto.me/mrdata/share/atlases/
ENV AFNI_URL https://afni.nimh.nih.gov/pub/dist/bin/linux_fedora_21_64/@update.afni.binaries
ENV LIBXP_URL http://mirrors.kernel.org/ubuntu/pool/main/libx/libxp/libxp6_1.0.2-2_amd64.deb
ENV CRAN_URL https://cran.rstudio.com/
ENV NDEB_URL http://neuro.debian.net/lists/xenial.us-ca.full

#--------Initial Configuration-----------------------------------------------#
# download/install basic dependencies, and set up python
RUN apt-get update
RUN apt-get install -y zip unzip vim git python-dev curl gsl-bin

RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py

RUN \
    apt-get install -y git libpng-dev libfreetype6-dev pkg-config \
    zlib1g-dev g++ vim

COPY docker/neurodebian.gpg /root/.neurodebian.gpg

RUN apt-get install -y software-properties-common python-software-properties
RUN add-apt-repository universe
RUN apt-get update
RUN apt-get install -y tcsh xfonts-base python-qt4       \
                        gsl-bin netpbm gnome-tweak-tool   \
                        libjpeg62 xvfb xterm vim curl
RUN apt-get install -y libglu1-mesa-dev libglw1-mesa     \
                        libxm4 build-essential
RUN chsh -s /usr/bin/tcsh && \
    curl -O https://afni.nimh.nih.gov/pub/dist/bin/linux_fedora_21_64/@update.afni.binaries && \
    tcsh @update.afni.binaries -package linux_ubuntu_16_64  -do_extras && \
    chsh -s /bin/bash && \
    cp $HOME/abin/AFNI.afnirc $HOME/.afnirc && \
    echo "PATH=$PATH:/root/abin" >> ~/.bashrc

#-------AFNI INSTALL----------------------------------------------------------#
# setup of AFNI, which provides robust modifications of many of neuroimaging
# algorithms


#---------FSL INSTALL---------------------------------------------------------#
# setup FSL using debian
RUN \
    curl -sSL $NDEB_URL >> /etc/apt/sources.list.d/neurodebian.sources.list && \
    apt-key add /root/.neurodebian.gpg && \
    (apt-key adv --refresh-keys --keyserver hkp://ha.pool.sks-keyservers.net 0xA5D32F012649A5A9 || true) && \
    apt-get update
RUN \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        fsl-core=5.0.9-4~nd16.04+1 \
        fsl-mni152-templates=5.0.7-2

ENV \
    FSLDIR=/usr/share/fsl/5.0 \
    FSLOUTPUTTYPE=NIFTI_GZ \
    FSLMULTIFILEQUIT=TRUE \
    POSSUMDIR=/usr/share/fsl/5.0 \
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/fsl/5.0 \
    FSLTCLSH=/usr/bin/tclsh \
    FSLWISH=/usr/bin/wish

ENV PATH=$FSLDIR/bin:$PATH

RUN \
    echo ". $FSLDIR/etc/fslconf/fsl.sh" >> ~/.bashrc && \
    echo "export FSLDIR PATH" >> ~/.bashrc

#--------NDMG SETUP-----------------------------------------------------------#
# setup of python dependencies for ndmg itself, as well as file dependencies
RUN \
    pip install numpy==1.12.1 networkx>=1.11 nibabel>=2.0 dipy>=0.1 scipy \
    boto3 awscli matplotlib==1.5.3 plotly==1.12.1 nilearn>=0.2 sklearn>=0.0 \
    pandas

RUN \
    git clone -b eric-dev-gkiar-fmri $NDMG_URL /ndmg && \
    cd /ndmg && \
    python setup.py install 

RUN \
    mkdir /ndmg_atlases && \
    cd /ndmg_atlases && \
    wget -rnH --cut-dirs=3 --no-parent -P /ndmg_atlases $ATLASES

