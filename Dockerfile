FROM ubuntu:22.04

RUN apt update && apt install -y nasm gcc make

WORKDIR /app
COPY . .

CMD ["/bin/bash"]
