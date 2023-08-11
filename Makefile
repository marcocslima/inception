# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mcesar-d <mcesar-d@student.42sp.org.br>    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/08/07 03:30:27 by mcesar-d          #+#    #+#              #
#    Updated: 2023/08/10 21:38:58 by mcesar-d         ###   ########.fr        #
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

setup: $(ENV_FILE)
	@sudo mkdir -p $(VOLUMES_PATH)/wordpress
	@sudo mkdir -p $(VOLUMES_PATH)/mariadb
	@sudo grep $(LOGIN).42.fr /etc/hosts || sudo bash -c 'echo "127.0.0.1 $(LOGIN).42.fr" >> /etc/hosts'
	@grep VOLUMES_PATH srcs/.env || echo "VOLUMES_PATH=$(VOLUMES_PATH)" >> srcs/.env

clean:
	@rm -f srcs/.env || true

fclean:
	@docker rmi -f $$(docker images -q) || true
	@docker volume rm $$(docker volume ls -q) || true
	@sudo rm -rf $(VOLUMES_PATH) || true

re: fclean all
	@echo "[Success]: Completely restarted."


.PHONY: all assemble down setup clean fclean re