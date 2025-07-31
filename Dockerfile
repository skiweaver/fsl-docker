#syntax=docker/dockerfile:1

# Build with CUDA runtime base
ARG CUDA_IMAGE=nvidia/cuda:12.9.0-runtime-ubuntu24.04
FROM ${CUDA_IMAGE} AS base

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Atlantic/Bermuda

RUN --mount=type=cache,target=/var/cache/apt \
        apt-get update -o Acquire::Retries=3 \
        && apt-get install --no-install-recommends -y \
              # base libs
              ca-certificates \
              git \
              tini \
              tzdata \
              python3 \
              bash \
              # libs for fsl
              file \
              wget \
              curl \
              bzip2 \
              dc \
              mesa-utils \
              pulseaudio \
              libquadmath0 \
              libgtk2.0-0 \
              firefox \
              libgomp1 \ 
              # x-forwarding
              xorg \
              # text editor
              vim \
        && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
        && echo $ TZ > /etc/timezone \
        && apt-get clean && rm -rf /var/lib/apt/lists/*

        
RUN curl -Ls https://fsl.fmrib.ox.ac.uk/fsldownloads/fslconda/releases/getfsl.sh | sh -s

ENTRYPOINT ["tini","--"]

CMD ["bash"]

# RUN wget https://git.fmrib.ox.ac.uk/fsl/installer/-/raw/3.3.0/fslinstaller.py
# RUN python3 ./fslinstaller.py -d /usr/local/fsl/
# ENV FSLDIR=/usr/local/fsl
# ENTRYPOINT [ "sh", "-c", "./usr/local/fsl/etc/fslconf/fsl.sh && /bin/bash"]



