 
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
    && pip3 install pandas==1.3.0 \
    && pip3 install seaborn==0.11.1 \
    && pip3 install matplotlib==3.4.2 \
    && pip3 install numpy==1.19.2 \
    && pip3 install -U scikit-learn==0.24.2 \
    && pip3 install flowcraft==1.4.1 \
    && pip3 install multiqc \
    && pip3 install cutadapt==3.4 


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
RUN wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.5.zip
RUN unzip fastqc_v0.11.5.zip \
    && cd FastQC/ \
    && chmod 755 fastqc \
    && export PATH=$PATH:$PWD \
    && cd / 
    
ENV PATH=$PATH:/usr/games/
RUN curl -sSL https://github.com/COMBINE-lab/salmon/releases/download/v1.0.0/salmon-1.0.0_linux_x86_64.tar.gz | tar xz \
 && mv /salmon-*/bin/* /usr/bin/ \
 && mv /salmon-*/lib/* /usr/lib/
