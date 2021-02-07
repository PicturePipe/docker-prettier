FROM node:12.14.1-alpine@sha256:1dd4309479f031295f3dfb61cf3afc3efeb1a991b012e105d1a95efc038b72f6

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
