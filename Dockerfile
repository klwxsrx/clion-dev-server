FROM ubuntu:bionic


### Required packages ###

RUN apt update && apt upgrade -y && apt install -y \
    cmake gcc g++ gdb gdbserver build-essential \
    rsync openssh-server


### Setup ssh for debugging ###

RUN echo 'root:root' | chpasswd

RUN mkdir /var/run/sshd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

EXPOSE 22


### Google Test ###

RUN apt install -y libgtest-dev

RUN cd /usr/src/gtest && \
    cmake CMakeLists.txt && \
    make -f Makefile

RUN mv /usr/src/gtest/*.a /usr/lib/


### Delete cache ###

RUN apt clean autoclean
RUN apt autoremove -y
RUN rm -rf /var/lib/{apt,dpkg,cache,log}/


### Entrypoint ###

CMD ["/usr/sbin/sshd", "-D"]