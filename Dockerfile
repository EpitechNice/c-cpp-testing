FROM ubuntu:22.04

RUN apt-get update
RUN apt-get install -y gcc g++ make cmake curl gpg

COPY ./run_action.sh /run_action.sh

ENTRYPOINT [ "/run_action.sh" ]
