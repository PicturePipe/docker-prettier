FROM node:10.15.2-alpine@sha256:8ac058c7735e957c455dea33bce69c90e3dd83793e0c8ef6f8d73d6a894980c3

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
