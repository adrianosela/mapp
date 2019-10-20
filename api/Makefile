NAME:=$(shell basename `git rev-parse --show-toplevel`)
HASH:=$(shell git rev-parse --verify --short HEAD)

all: build

deploy:
	gcloud app deploy

up: build down
	docker run -d --name $(NAME)_service -p 8080:80 $(NAME)

build: decrypt-conf
	docker build -t $(NAME) .

decrypt-conf:
	sops -d config/encrypted.json > config/default.json

down:
	(docker stop $(NAME)_service || true) && (docker rm $(NAME)_service || true)
