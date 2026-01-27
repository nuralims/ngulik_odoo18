.PHONY: help up up-d down restart ps logs logs-odoo logs-db shell-odoo shell-db psql perms upgrade restart-upgrade wait-db

COMPOSE ?= docker compose
PROJECT ?= odoo-one

help:
	@echo "Targets:"
	@echo "  up         Start containers (foreground)"
	@echo "  up-d       Start containers (detached)"
	@echo "  down       Stop and remove containers"
	@echo "  restart    Restart containers"
	@echo "  ps         Show container status"
	@echo "  logs       Follow all logs"
	@echo "  logs-odoo  Follow Odoo logs"
	@echo "  logs-db    Follow Postgres logs"
	@echo "  shell-odoo Open shell in Odoo container"
	@echo "  shell-db   Open shell in DB container"
	@echo "  psql       Open psql in DB container"
	@echo "  perms      Fix permissions for mounted folders"
	@echo "  upgrade    Upgrade Odoo module (MODULE=estate)"
	@echo "  restart-upgrade Restart containers and upgrade module"
	@echo "  wait-db    Wait until Postgres is ready"

up:
	$(COMPOSE) -p $(PROJECT) up

up-d:
	$(COMPOSE) -p $(PROJECT) up -d

down:
	$(COMPOSE) -p $(PROJECT) down

restart:
	$(COMPOSE) -p $(PROJECT) restart

ps:
	$(COMPOSE) -p $(PROJECT) ps

logs:
	$(COMPOSE) -p $(PROJECT) logs -f --tail=200

logs-odoo:
	$(COMPOSE) -p $(PROJECT) logs -f --tail=200 odoo18

logs-db:
	$(COMPOSE) -p $(PROJECT) logs -f --tail=200 db

shell-odoo:
	$(COMPOSE) -p $(PROJECT) exec odoo18 bash

shell-db:
	$(COMPOSE) -p $(PROJECT) exec db bash

psql:
	$(COMPOSE) -p $(PROJECT) exec db psql -U odoo -d postgres

perms:
	@echo "Fixing permissions for addons, etc, postgresql..."
	@chmod -R 777 addons
	@chmod -R 777 etc
	@chmod -R 777 postgresql

# Upgrade Odoo module
CONTAINER ?= $(PROJECT)-odoo18-1
DB_CONTAINER ?= $(PROJECT)-db-1
DB_NAME ?= rd-demo
DB_HOST ?= db
DB_USER ?= odoo
DB_PASSWORD ?= odoo18@2024
MODULE ?= estate

# Allow: make upgrade estate  /  make restart-upgrade estate
ifneq (,$(filter upgrade restart-upgrade,$(firstword $(MAKECMDGOALS))))
ifneq (,$(word 2,$(MAKECMDGOALS)))
MODULE := $(word 2,$(MAKECMDGOALS))
define _DUMMY_TARGET
$1:
	@:
endef
$(eval $(call _DUMMY_TARGET,$(word 2,$(MAKECMDGOALS))))
endif
endif

upgrade:
	docker exec -it $(CONTAINER) odoo --db_host=$(DB_HOST) -d $(DB_NAME) -r $(DB_USER) -w $(DB_PASSWORD) -u $(MODULE) --stop-after-init

wait-db:
	docker exec -it $(DB_CONTAINER) sh -c 'until pg_isready -U $(DB_USER) -d $(DB_NAME) -h 127.0.0.1; do echo "Waiting for DB..."; sleep 2; done'

restart-upgrade: restart wait-db upgrade
