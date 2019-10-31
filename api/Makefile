NAME:=$(shell basename `git rev-parse --show-toplevel`)
HASH:=$(shell git rev-parse --verify --short HEAD)

all: build

deploy: decrypt-conf-prod
	gcloud app deploy

up: build down
	docker run -d --name $(NAME)_service -p 8080:80 $(NAME)

build: decrypt-conf-dev
	docker build -t $(NAME) .

decrypt-conf-prod:
	sops -d config/encrypted-prod.json > config/production.json

decrypt-conf-dev:
	sops -d config/encrypted-dev.json > config/default.json

down:
	(docker stop $(NAME)_service || true) && (docker rm $(NAME)_service || true)

lint:
	npm run lint

clean:
	rm config/production.json config/default.json
