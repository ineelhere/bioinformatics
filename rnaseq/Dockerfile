FROM ubuntu:18.04
ARG DEBIAN_FRONTEND=noninteractive

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN apt-get update \
    && apt-get install -y \
        python3-dev \
        python3-pip \
        curl \
        git \
        unzip \
        wget \
    && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get install -y nodejs \
    && pip3 install --upgrade pip \
    && pip3 install pandas \
    && pip3 install seaborn \
    && pip3 install matplotlib \
    && pip3 install numpy \
    && pip3 install -U scikit-learn \
    && pip3 install flowcraft \
    && pip3 install multiqc \
    && pip3 install cutadapt 
# Install PollyCLI
RUN apt install nodejs
RUN npm install -g @elucidatainc/pollycli && polly version --version

# Install OpenJDK-8
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk && \
    apt-get install -y ant && \
    apt-get clean;
    
# Fix certificate issues
RUN apt-get update && \
    apt-get install ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f;

# Setup JAVA_HOME -- useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

#Install Nextflow
RUN curl -s https://get.nextflow.io | bash

# Install STAR
RUN apt-get update -y
RUN apt-get install -y rna-star

# Install FastQC = https://hub.docker.com/r/biocontainers/fastqc/dockerfile
ENV URL=http://www.bioinformatics.babraham.ac.uk/projects/fastqc/
ENV ZIP=fastqc_v0.11.5.zip

RUN wget $URL/$ZIP -O $DST/$ZIP && \
  unzip - $DST/$ZIP -d $DST && \
  rm $DST/$ZIP && \
  cd $DST/FastQC && \
  chmod 755 fastqc && \
  ln -s $DST/FastQC/fastqc /usr/local/bin/fastqc
  
ENV PATH /usr/local/bin:$PATH

CMD fastqc

ENV PATH=$PATH:/usr/games/
RUN curl -sSL https://github.com/COMBINE-lab/salmon/releases/download/v1.0.0/salmon-1.0.0_linux_x86_64.tar.gz | tar xz \
 && mv /salmon-*/bin/* /usr/bin/ \
 && mv /salmon-*/lib/* /usr/lib/

WORKDIR /data/
