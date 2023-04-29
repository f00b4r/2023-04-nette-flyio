DOCKER_IMAGE ?= f00b4r/nettefly
DOCKER_PLATFORM ?= linux/amd64,linux/arm64
DOCKER_VERSION ?= latest

############################################################
# PROJECT ##################################################
############################################################
.PHONY: install
install:
	composer install

.PHONY: project
project:
	mkdir -p var/tmp var/log
	chmod 0777 var/tmp var/log

.PHONY: clean
clean:
	find var/tmp -mindepth 1 ! -name '.gitignore' -type f,d -exec rm -rf {} +
	find var/log -mindepth 1 ! -name '.gitignore' -type f,d -exec rm -rf {} +

############################################################
# DEVELOPMENT ##############################################
############################################################
.PHONY: dev
dev:
	NETTE_DEBUG=1 NETTE_ENV=dev php -S 0.0.0.0:8080 -t www

############################################################
# DOCKER ###################################################
############################################################
.PHONY: docker-build
docker-build:
	docker buildx \
		build \
		--platform ${DOCKER_PLATFORM} \
		--pull \
		-t ${DOCKER_IMAGE}:${DOCKER_VERSION} \
		.

############################################################
# DEPLOYMENT ###############################################
############################################################
.PHONY: setup
setup:
	$(MAKE) project
	$(MAKE) clean

.PHONY: deploy
deploy:
	flyctl deploy
