# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: user42 <user42@student.42.fr>              +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/08/07 03:30:27 by mcesar-d          #+#    #+#              #
#    Updated: 2023/08/19 09:41:54 by user42           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

COMPOSE := srcs/docker-compose.yml
ENV_FILE := srcs/.env
LOGIN := mcesar-d
VOLUMES_PATH :=/home/$(LOGIN)/data

ENV_CONTENT := \
    WORDPRESS_DATABASE=wordpress_db\
    \nWORDPRESS_USER=wuser\
	\nWORDPRESS_USER_EMAIL=mcl@studant.42sp.org.br\
    \nWORDPRESS_PASSWORD=wpass\
    \nMYSQL_ROOT_PASSWORD=rpass\
    \nWORDPRESS_HOSTNAME=mariadb\
    \nDOMAIN_NAME=https://$(LOGIN).42.fr\
    \nLOGIN_42=$(LOGIN)\
    \nWP_TITLE=INCEPTION\
    \nWP_ADMIN_USER=mcl\
    \nWP_ADMIN_PASSWORD=123\
    \nWP_ADMIN_EMAIL=$(LOGIN)@studant.42sp.org.br\
    \nWP_URL=http://localhost

all: $(ENV_FILE)
	@make env
	@make setup
	@make assemble

assemble:
	docker-compose --file=$(COMPOSE) up --build --detach

setup: $(ENV_FILE)
	@sudo mkdir -p $(VOLUMES_PATH)/wordpress
	@sudo mkdir -p $(VOLUMES_PATH)/mariadb
	@sudo grep $(LOGIN).42.fr /etc/hosts || sudo bash -c 'echo "127.0.0.1 $(LOGIN).42.fr" >> /etc/hosts'

env:
	@echo "$(ENV_CONTENT)" > $(ENV_FILE)
	@echo "Arquivo $(ENV_FILE) criado ou atualizado."

rb: down fclean all

down:
	docker-compose --file=$(COMPOSE) down || true

rt:
	@docker stop $$(docker ps -qa) || true
	@docker rm $$(docker ps -qa) || true
	@docker rmi -f $$(docker images -qa) || true
	@docker volume rm $$(docker volume ls -q) || true
	@docker network rm $$(docker network ls -q) 2>/dev/null || true
	@sudo rm -rf /home/$(LOGIN) || true

clean:
	@rm -f srcs/.env || true

fclean: down
	@docker rmi -f $$(docker images -q) || true
	@docker volume rm $$(docker volume ls -q) || true
	@sudo rm -rf /home/$(LOGIN) || true

re: fclean all
	@echo "[Success]: Completely restarted."


.PHONY: all assemble setup env rb down rt clean fclean re