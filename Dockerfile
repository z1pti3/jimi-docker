# Build from ubuntu
FROM ubuntu:latest

# Install requirements
RUN apt-get update && apt-get install -y --no-install-recommends python3-minimal python3-venv python3-pip python3-setuptools python3-wheel git unzip wget ca-certificates && rm -rf /var/lib/apt/lists/*

# Create and change user to jimi
RUN useradd jimi && mkdir /home/jimi && chown jimi:jimi /home/jimi
USER jimi

# Transfer jimi system files
WORKDIR /home/jimi/
RUN git clone https://github.com/z1pti3/jimi.git jimi
RUN mkdir /home/jimi/jimi/plugins && mkdir /home/jimi/jimi/data && mkdir /home/jimi/jimi/data/logs && mkdir /home/jimi/jimi/data/storage && mkdir /home/jimi/jimi/data/temp

# Building python venv
ENV VIRTUAL_ENV=/home/jimi/venv
RUN python3 -m venv venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Installing core requirements
RUN pip install wheel && pip install -r jimi/requirements.txt

# Run
WORKDIR /home/jimi/jimi
ENTRYPOINT ["python"]