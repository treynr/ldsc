
## Multi-stage build to slim down on the file size
FROM python:2.7-slim AS compile-image

WORKDIR /ldsc

## Install packages for python and poetry
RUN apt-get -y update && apt-get -y install build-essential curl zlib1g-dev

## Install poetry
RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python

## Poetry/Python 2.7 will throw a unicode error during installation if the 
## locale isn't set
ENV PATH="/root/.poetry/bin:$PATH"
ENV LC_ALL=en_US.UTF-8

COPY . .

## Don't create a virtualenv, all installed packages go in system dirs
RUN poetry config virtualenvs.create false
RUN poetry install

FROM python:2.7-slim AS runtime-image

WORKDIR /ldsc
COPY --from=compile-image /ldsc .
COPY --from=compile-image /usr/local /usr/local

ENV PATH="/ldsc:$PATH"

