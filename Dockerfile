FROM ubuntu
USER root

COPY --from=golang /usr/local/go/ /usr/local/go/
COPY --from=rust /usr/local/cargo/ /usr/local/cargo/
COPY --from=python /usr/local/bin/ /usr/local/bin/

ARG APT_PKGS="curl sudo vim openssh-server build-essential cmake cppcheck valgrind clang lldb llvm gdb"
RUN \
    echo "--[ Installing packages ]--" && \
    apt-get update && \
    apt-get install -y ${APT_PKGS}
RUN curl -s -L https://dot.net/v1/dotnet-install.sh | bash

RUN echo 'root:root' | chpasswd
RUN echo 'ubuntu:ubuntu' | chpasswd

RUN ssh-keygen -A

RUN echo 'y\ny' | unminimize

EXPOSE 22
VOLUME /home/ubuntu
CMD ["/usr/sbin/sshd", "-D"]
