FROM ruby:3.0.1-alpine

ARG WORKDIR
ARG API_PORT
ARG RUNTIME_PACKAGES="nodejs tzdata postgresql-dev postgresql git"
ARG DEV_PACKAGES="build-base curl-dev"

ENV HOME=/${WORKDIR} \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo \
    API_PORT=${API_PORT}

WORKDIR ${HOME}

COPY Gemfile* ./

RUN apk update && \
    apk upgrade && \
    apk add --no-cache ${RUNTIME_PACKAGES} && \
    apk add --virtual build-dependencies --no-cache ${DEV_PACKAGES} && \
    bundle install -j4 && \
    apk del build-dependencies

COPY . .

EXPOSE ${API_PORT}

CMD ["rails" "server" "-b" "0.0.0.0"]