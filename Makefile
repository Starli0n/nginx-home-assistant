-include .env
export $(shell sed 's/=.*//' .env)

export HOME_ASSISTANT_HOSTNAME=${HOME_ASSISTANT_CONTAINER}.${NGINX_HOSTNAME}
export HOME_ASSISTANT_HTTP_URL=http://${HOME_ASSISTANT_HOSTNAME}:${NGINX_PROXY_HTTP}
export HOME_ASSISTANT_HTTPS_URL=https://${HOME_ASSISTANT_HOSTNAME}:${NGINX_PROXY_HTTPS}

.PHONY: env_var
env_var: # Print environnement variables
	@cat .env
	@echo
	@echo HOME_ASSISTANT_HOSTNAME=${HOME_ASSISTANT_HOSTNAME}
	@echo HOME_ASSISTANT_HTTP_URL=${HOME_ASSISTANT_HTTP_URL}
	@echo HOME_ASSISTANT_HTTPS_URL=${HOME_ASSISTANT_HTTPS_URL}

.PHONY: env
env: # Create .env and tweak it before initialize
	cp .env.default .env

.PHONY: initialize
initialize: init

.PHONY: init
init:
	mkdir -p home-assistant

.PHONY: erase
erase:
	rm -rf home-assistant

.PHONY: pull
pull: # Pull the docker image
	docker pull homeassistant/home-assistant:${TAG}

.PHONY: config
config: # Show docker-compose configuration
	docker-compose config

.PHONY: up
up: # Start containers and services
	docker-compose up -d
	docker-compose ps

.PHONY: down
down: # Stop containers and services
	docker-compose down

.PHONY: start
start: # Start containers
	docker-compose start

.PHONY: stop
stop: # Stop containers
	docker-compose stop

.PHONY: restart
restart: # Restart container
	docker-compose restart

.PHONY: delete
delete: down erase

.PHONY: mount
mount: init up

.PHONY: reset
reset: down up

.PHONY: hard-reset
hard-reset: delete mount

.PHONY: logs
logs: # Show logs of the services
	docker-compose logs -f

.PHONY: shell
shell: # Open a shell on a started container
	docker exec -it ${HOME_ASSISTANT_CONTAINER} /bin/bash

.PHONY: url
url:
	@echo ${HOME_ASSISTANT_HTTP_URL}
	@echo ${HOME_ASSISTANT_HTTPS_URL}
