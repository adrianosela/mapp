NAME:=$(shell basename `git rev-parse --show-toplevel`)
HASH:=$(shell git rev-parse --verify --short HEAD)

all: build

up: build down
	docker run -d --name $(NAME)_service -p 8080:80 $(NAME)

build:
	docker build -t $(NAME) .

down:
	(docker stop $(NAME)_service || true) && (docker rm $(NAME)_service || true)
