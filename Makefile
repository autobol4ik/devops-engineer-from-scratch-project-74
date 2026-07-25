COMPOSE ?= docker compose --project-name hexlet-8-compose
BASE_COMPOSE = $(COMPOSE) -f docker-compose.yml
CI_COMPOSE = docker compose --project-name hexlet-8-ci -f docker-compose.yml

.PHONY: setup dev test ci build push down

setup:
	cp -n .env.example .env
	$(COMPOSE) run --rm app make setup

dev:
	$(COMPOSE) up --build

test:
	$(BASE_COMPOSE) up --build --abort-on-container-exit --exit-code-from app

ci:
	@$(CI_COMPOSE) down --volumes --remove-orphans
	@status=0; \
	$(CI_COMPOSE) up --build --abort-on-container-exit --exit-code-from app || status=$$?; \
	if [ $$status -ne 0 ]; then $(CI_COMPOSE) logs; fi; \
	$(CI_COMPOSE) down --volumes --remove-orphans; \
	exit $$status

build:
	$(BASE_COMPOSE) build app

push:
	$(BASE_COMPOSE) push app

down:
	$(COMPOSE) down --volumes --remove-orphans
