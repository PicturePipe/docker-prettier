FROM node:12.22.12-alpine@sha256:d4b15b3d48f42059a15bd659be60afe21762aae9d6cbea6f124440895c27db68

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
