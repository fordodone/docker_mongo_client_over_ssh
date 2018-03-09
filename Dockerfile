FROM mongo:3.6

RUN apt-get update \
      && apt-get install -y \
        openssh-client \
      && apt-get clean -y \
      && rm -rf /var/lib/apt/lists/*
