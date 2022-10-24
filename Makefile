#!make
include .env.default
export $(shell sed 's/=.*//' .env.default)

ifndef PROJECT
$(error PROJECT is not set)
endif

.PHONY: help start update stop destroy backup ssh
SHELL := /bin/bash

    help:              ### Show this help.
		@awk 'BEGIN {FS = ":.*###"; \
		printf "\nUSAGE:\n  make \033[33m[command]\033[0m\n\nCOMMANDS:\n"} /^[$$()% a-zA-Z_-]+:.*?###/ \
		{ printf "  \033[32m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ \
		{ printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST) 
		@printf "\n"

    start:             ### Start all services container
		y| bash services-start.sh

    update:            ### Update app container based on deployment
		y| bash services-restart.sh
  
    stop:           	 ### Stop all services container
		y| bash services-stop.sh

    destroy:           ### Stop & Destroy all services container
		y| bash services-destroy.sh

    backup:            ### Backup DB 
		y| bash backup-db.sh; \

    ssh:               ### SSH to Application service container
		docker exec --user ${USER_PHP} -it ${PROJECT}-php /bin/bash

    all: help

