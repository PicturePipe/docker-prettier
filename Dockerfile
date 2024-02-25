FROM node:12.14.1-alpine@sha256:82cca33a2e2123ef9a7a93d6ad0d9f93ee2be8f33367b4798a677d3be5493a0b

ENV APP_DIR /home/node/app
ENV NODE_DIR /home/node/node_modules/app
ENV PATH $PATH:$NODE_DIR/node_modules/.bin

# Install git and openssh-client for CircleCI
RUN apk upgrade \
    --no-cache \
    --no-progress \
    --update \
    && apk add \
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
