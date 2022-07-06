FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y wget && \
    apt-get install -y unzip && \
    apt-get install -y git && \
    apt-get install -y make build-essential && \
    apt-get install -y libz-dev

WORKDIR /app/program
# step1
# fastp
RUN wget https://opengene.org/fastp/fastp && \
    chmod a+x ./fastp

# seqkit
RUN wget https://github.com/shenwei356/seqkit/releases/download/v2.1.0/seqkit_linux_amd64.tar.gz && \
    tar xvzf seqkit_linux_amd64.tar.gz && \
    rm seqkit_linux_amd64.tar.gz

# Prodigal
RUN git clone https://github.com/hyattpd/Prodigal.git && \
    cd Prodigal && \
    make install && \
    cd /app/program && \
    ln -s /usr/local/bin/prodigal ./
    # step5

# diamond
RUN wget https://github.com/bbuchfink/diamond/releases/download/v2.0.13/diamond-linux64.tar.gz && \
    tar xzf diamond-linux64.tar.gz && \
    rm diamond-linux64.tar.gz

# step2
# RUN mkdir -p /app/program
# RUN mkdir -p /app/reference

# step3
# COPY ./Reference/* /app/reference/

# step4
COPY ./Program/* /app/program/
RUN chmod +x /app/program/*

# step6 should be preprocessed
# step7 can be achieved using -v(volume mount)
# step8 is omitted
# step9 should be preprocessed
# prokaryotes.pep.uniq.diamond.dmnd is also copied in step3
# step10,11 are execution.
