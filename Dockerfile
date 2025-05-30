FROM debian:latest

RUN mkdir /fooocus
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install git python3 python3-pip python3-venv

RUN cd /fooocus

RUN python3 -m venv /opt/venv
# Enable venv
ENV PATH="/opt/venv/bin:$PATH"

#RUN git clone https://github.com/lllyasviel/Fooocus.git
COPY Fooocus /fooocus/Fooocus
RUN cd /fooocus/Fooocus
#COPY ./requirements_versions.txt /fooocus/Fooocus/requirements_versions.txt
RUN pip3 install -r /fooocus/Fooocus/requirements_versions.txt
RUN pip3 uninstall -y torch torchvision torchaudio torchtext functorch xformers
RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm5.6

WORKDIR /fooocus/Fooocus/
ENV PATH="/opt/venv/bin:$PATH"

EXPOSE 7865

CMD ["python3", "entry_with_update.py", "--listen", "0.0.0.0"]