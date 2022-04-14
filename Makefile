.PHONY: docker docker-compose rvm rbenv nvm postgresql-12 postgresql-14 mysql-5.7 mysql-8.0
.DEFAULT_GOAL := no-choice

docker:
	@echo 'Installing Docker'
	sudo bash ./scripts/docker.sh

docker-compose:
	@echo 'Installing Docker-compose'
	sudo bash ./scripts/docker-compose.sh

rvm:
	@echo 'Installing RVM'
	sudo bash ./scripts/rvm.sh

rbenv:
	@echo 'Installing RBENV'
	sudo bash ./scripts/rbenv.sh

nvm:
	@echo 'Installing NVM'
	sudo bash ./scripts/nvm.sh

postgresql-12:
	@echo 'Installing Postgresql 12'
	sudo bash ./scripts/postgresql-12.sh

postgresql-14:
	@echo 'Installing Postgresql 14'
	sudo bash ./scripts/postgresql-14.sh

mysql-5.7:
	@echo 'Installing Mysql 5.7'
	sudo bash ./scripts/mysql-5.7.sh

mysql-8.0:
	@echo 'Installing Mysql 8.0'
	sudo bash ./scripts/mysql-8.0.sh

no-choice:
	@echo 'Необходимо указать хотя бы один из предложенных параметров:'
	@echo 'docker docker-compose rvm rbenv nvm postgresql-12 postgresql-14 mysql-5.7 mysql-8.0'