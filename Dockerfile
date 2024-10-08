FROM python:3-alpine

LABEL maintainer="xnetcat (Jakub)"

# Install dependencies
RUN apk add --no-cache \
    ca-certificates \
    ffmpeg \
    openssl \
    aria2 \
    g++ \
    git \
    py3-cffi \
    libffi-dev \
    zlib-dev

# Install poetry and update pip/wheel
RUN pip install --upgrade pip poetry wheel spotipy

# Copy requirements files
COPY poetry.lock pyproject.toml /

# Install spotdl requirements
RUN poetry install

# Add source code files to WORKDIR
ADD . .

# Install spotdl itself
RUN poetry install

# Create music directory
RUN mkdir /music

COPY dist /music/dist

# Create a volume for the output directory
VOLUME /music

# Change CWD to /music
WORKDIR /music


# Entrypoint command
ENTRYPOINT ["poetry", "run", "spotdl", "web", "--host" , "0.0.0.0", "--port" , "3000", "--keep-sessions" ,"--keep-alive" ,"--web-gui-location" , "/music/dist"]
