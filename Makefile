# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: user42 <user42@student.42.fr>              +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/08/07 03:30:27 by mcesar-d          #+#    #+#              #
#    Updated: 2023/08/17 09:58:12 by user42           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

COMPOSE := srcs/docker-compose.yml
ENV_FILE := srcs/.env
VOLUMES_PATH :=/home/mcesar-d/data
LOGIN := mcesar-d

all: $(ENV_FILE)
	@make setup
	@make assemble

assemble:
	docker-compose --file=$(COMPOSE) up --build --detach

down:
	docker-compose --file=$(COMPOSE) down || true

rb: down fclean all

setup: $(ENV_FILE)
	@sudo mkdir -p $(VOLUMES_PATH)/wordpress
	@sudo mkdir -p $(VOLUMES_PATH)/mariadb
	@sudo grep $(LOGIN).42.fr /etc/hosts || sudo bash -c 'echo "127.0.0.1 $(LOGIN).42.fr" >> /etc/hosts'

clean:
	@rm -f srcs/.env || true

fclean:
	@docker rmi -f $$(docker images -q) || true
	@docker volume rm $$(docker volume ls -q) || true
	@sudo rm -rf $(VOLUMES_PATH) || true

re: fclean all
	@echo "[Success]: Completely restarted."


.PHONY: all assemble down setup clean fclean re