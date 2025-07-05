# Paths
WP_DATA := /home/khammadi/data/wordpress/*
DB_DATA := /home/khammadi/data/mariadb/*
COMPOSE := ./srcs/docker-compose.yml

# Declare phony targets to avoid conflicts with files of the same name
.PHONY: all up down stop start build logs clean re

# Default target
all: up

# Docker Compose commands
up: build
	docker compose -f $(COMPOSE) up --build

down:
	docker compose -f $(COMPOSE) down

stop:
	docker compose -f $(COMPOSE) stop

start:
	docker compose -f $(COMPOSE) start

build:
	docker compose -f $(COMPOSE) build

logs:
	docker compose -f $(COMPOSE) logs

# Clean all Docker containers, volumes, and local data
clean:
	@echo "Stopping all running containers..."
	@containers=$(shell docker ps -qa) && [ -n "$$containers" ] && docker stop $$containers || true

	@echo "Pruning Docker system..."
	@docker system prune -a -f

	@echo "Removing Docker volumes..."
	@volumes=$(shell docker volume ls -q) && [ -n "$$volumes" ] && docker volume rm $$volumes || true

	@echo "Removing WordPress data..."
	@sudo test -e $(WP_DATA) && sudo rm -rf $(WP_DATA) || true

	@echo "Removing MariaDB data..."
	@sudo test -e $(DB_DATA) && sudo rm -rf $(DB_DATA) || true

# Rebuild from scratch
re: clean up	
