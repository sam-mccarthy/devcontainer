FROM ubuntu
USER root

RUN echo 'y\ny' | unminimize
RUN echo 'root:root' | chpasswd
RUN echo 'ubuntu:ubuntu' | chpasswd

COPY --from=golang /usr/local/go/ /usr/local/go/
COPY --from=rust /usr/local/cargo/ /usr/local/cargo/
COPY --from=python /usr/local/bin/ /usr/local/bin/

ARG APT_PKGS="curl sudo vim openssh-server build-essential cmake cppcheck valgrind clang lldb llvm gdb dotnet-sdk-8.0 git man"
RUN \
    echo "--[ Installing packages ]--" && \
    apt-get update && \
    apt-get install -y ${APT_PKGS}

RUN mkdir -p /run/sshd
RUN ssh-keygen -A

RUN echo "export PATH=${PATH}:/usr/local/go/bin:/usr/local/cargo/bin:/usr/local/rustup/bin" >> /etc/profile.d/02-path-fix.sh

RUN /usr/local/cargo/bin/rustup default stable

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
