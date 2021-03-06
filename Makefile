.PHONY: ci-web-echo web-test names-db-prelude

# Variables ====================================================================
WEB_DIR := client/web
LIB_DIR := library
PLUGINS_DIR := plugin

# Prelude ======================================================================
ci-web-echo:
	pwd
	node -v
	npm -v

ci-web-prelude: ci-web-echo core-javascript-build web-install

names-db-prelude:
	pwd
	rustc --version
	cargo --version

# Install ======================================================================
web-install:
	cd ${WEB_DIR} && \
	yarn install

# Build ========================================================================
web-build:
	cd ${WEB_DIR} && \
	yarn run build

names-db-build-unoptimized:
	cd ${PLUGINS_DIR}/names_db && \
	cargo build

names-db-build:
	cd ${PLUGINS_DIR}/names_db && \
	cargo build --release

core-javascript-build:
	cd ${LIB_DIR}/javascript && \
	yarn install && \
	yarn build

# Lint =========================================================================
web-lint:
	cd ${WEB_DIR} && \
	yarn run lint

core-javascript-lint:
	cd ${LIB_DIR}/javascript && \
	yarn run lint

# Test =========================================================================
web-test:
	cd ${WEB_DIR} && \
	yarn run test:ci

core-javascript-test:
	cd ${LIB_DIR}/javascript && \
	yarn run test && \
	yarn run relink-features && \
	yarn run test-features
