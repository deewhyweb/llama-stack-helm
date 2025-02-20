FROM docker.io/llamastack/distribution-remote-vllm

USER root

RUN mkdir -p /.llama /.cache

RUN chmod -R g+rw /app /.llama /.cache

USER 1001
