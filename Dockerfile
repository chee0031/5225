FROM amazonlinux:2

WORKDIR /

# Install necessary packages, including make and gzip
RUN yum install -y gcc openssl-devel wget tar gzip make zip

# Download Python source
RUN wget https://www.python.org/ftp/python/3.9.0/Python-3.9.0.tgz

# Extract the tarball
RUN tar -xzvf Python-3.9.0.tgz

# Set working directory to the extracted Python source
WORKDIR /Python-3.9.0

# Configure and install Python
RUN ./configure --enable-optimizations
RUN make altinstall

# Create a directory for the packages
RUN mkdir -p /packages/python

# Install pip and opencv-python
RUN /usr/local/bin/python3.9 -m ensurepip
RUN /usr/local/bin/python3.9 -m pip install --target=/packages/python opencv-python

# Zip the installed package for Lambda layer
WORKDIR /packages
RUN zip -r opencv-python-3.9.zip python/

# CMD to copy the zip file to the host machine
CMD cp /packages/opencv-python-3.9.zip /data
