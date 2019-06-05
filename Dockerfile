FROM node:12.4.0-alpine@sha256:25d56cf8f21a33f61415bcde0dd7fb1e1d46ecdb9b3b6d39e4846570cc235a81

ENV APP_DIR /home/node/app
ENV NODE_DIR /home/node/node_modules/app
ENV PATH $PATH:$NODE_DIR/node_modules/.bin

# Install git and openssh-client for CircleCI
RUN apk add \
    --no-cache \
    --no-progress \
    --update \
    git openssh-client

USER 1000

RUN mkdir -p "$APP_DIR" \
    && mkdir -p "$NODE_DIR"

WORKDIR $NODE_DIR

COPY --chown=1000:1000 .npmrc package.json package-lock.json ./

RUN npm install

WORKDIR $APP_DIR

CMD ["prettier", "--check", "./**"]
