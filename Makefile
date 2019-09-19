include .env
export

STEP = "\\n\\r**************************************************\\n"

help:
	echo "-- build: builds the docker images required to run this project"; \
	echo "-- build-force: Force rebuilds the docker images required to run this project"; \
	echo "-- start: starts the project"; \
	echo "-- stop: stops the project"; \
	echo "-- down: stops and removes containers used for this project (can generate data loss)"; \
	echo "-- logs: displays real time logs of containers used for this project"; \
	echo "-- purge: Delete all container and images"; \

build: do-init do-build do-finish
do-build:
	@echo "$(STEP) Building images... $(STEP)"
	docker-compose build

build-force: do-init do-build-force do-finish
do-build-force:
	@echo "$(STEP) Building images... $(STEP)"
	docker-compose build --no-cache

start: do-init do-start do-finish
do-start:
	@echo "$(STEP) Starting up containers... $(STEP)"
	docker-compose -f docker-compose.yml up -d --remove-orphans

stop: do-init do-stop do-finish
do-stop:
	@echo "$(STEP) Stopping containers... $(STEP)"
	docker-compose stop

restart: do-init do-stop do-start do-finish

down: do-init do-down do-finish
do-down:
	@echo "$(STEP) Stopping and removing containers... $(STEP)"; \
	docker-compose down;

logs: do-init do-logs do-finish
do-logs:
	@echo "$(STEP) Displaying logs... $(STEP)"; \
	docker-compose logs -f --tail="100";

purge: do-init do-purge do-finish
do-purge:
	@echo "$(STEP) Kill all containers $(STEP)"; \
	docker kill $$(docker ps -q)
	@echo "$(STEP) Delete all containers $(STEP)"; \
	docker rm $$(docker ps -a -q)
	@echo "$(STEP) Delete all images $(STEP)"; \
	docker rmi $$(docker images -q)

do-init:
	@rm -f .docker-config; \
	touch .docker-config;
ifeq ($(OS),Darwin)
	@echo $$(docker-machine env default) >> .docker-config;
endif

do-finish:
	@rm -f .docker-config;
