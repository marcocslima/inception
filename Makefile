# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mcesar-d <mcesar-d@student.42sp.org.br>    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/08/07 03:30:27 by mcesar-d          #+#    #+#              #
#    Updated: 2023/08/08 20:04:52 by mcesar-d         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Set the default target.
.DEFAULT_GOAL := all

# Set the Docker Compose file.
COMPOSE := srcs/docker-compose.yml

# Set the enviroment file.
ENV_FILE := srcs/.env

# Set the columes path.
VOLUMES_PATH := /home/mcesar-d/data

# Set the login name
LOGIN := mcesar-data

# Define the 'all' target.
all: add_host_entry
	@sudo mkdir -pv $(VOLUMES_PATH)/wordpress
	@sudo mkdir -pv $(VOLUMES_PATH)/mariadb
	docker-compose -f $(COMPOSE) --env-file $(ENV_FILE) up -d --build

# Define the 'add_host_entry' target.
add_host_entry:
	@ if ! grep -q "${LOGIN}.42.fr" /etc/hosts; then \
		echo "127.0.0.1 "${LOGIN}.42.fr" | sudo tee --append /etc/hosts; \
		echo "The entry was add in file /etc/hosts."; \
	else \
		echo "There is entry alredy in file /etc/hosts."; \
	fi

# Define the 'down' target.
down:
	docker-compose -f $(COMPOSE) --env-file $(ENV_FILE) down

# Define the 'clean' target.
clean: remove_host_entry
	docker stop $$(docker ps -qa);\
	docker rm $$(docker ps -qa);\
	docker rmi $$(docker images -qa);\
	docker volume rm $$(docker volume ls -q);\
	docker network rm $$(docker network ls -q);\
	sudo rm -rf $(VOLUMES_PATH)/wordpress
	sudo rm -rf $(VOLUMES_PATH)/mariadb

# Define the 'remove_host_entry' target.
remove_host_entry:
	@ if grep -q "${LOGIN}.42.fr" /etc/hosts; then \
		sudo sed -i '/\${LOGIN}\.42\.fr/d' /etc/hosts; \
		echo "The entry was removed in file /etc/hosts."; \
	else \
		echo "There is not entry in file /etc/hosts."; \
	fi

# Define the '.PHONY' target.
.PHONY: all down clean add_host_entry remove_host_entry