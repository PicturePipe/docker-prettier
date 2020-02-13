FROM node:12.16.0-alpine@sha256:aa52cfbaef33dc2f3bc41228072bce75705733d4d90cf086260df15fd7c65319

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
