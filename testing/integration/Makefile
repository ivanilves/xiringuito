REPO = ivanilves
DIST = ubuntu
TAG  = latest

NAME  = xiri-$(DIST)
IMAGE = $(REPO)/$(NAME):$(TAG)

docker-build:
	docker build -f Dockerfile.$(DIST) --no-cache -t $(IMAGE) .

docker-pull:
	docker pull $(IMAGE)

docker-push:
	docker push $(IMAGE)

docker-start:
	docker run -d --name $(NAME) $(IMAGE)

docker-bash:
	docker run -ti --name $(NAME) --rm $(IMAGE) bash

docker-logs:
	docker logs $(NAME)

docker-stop:
	docker kill $(NAME)

docker-rm:
	docker rm $(NAME)

docker-ip:
	@docker inspect --format '{{ .NetworkSettings.IPAddress }}' $(NAME)
