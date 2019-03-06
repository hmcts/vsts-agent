.DEFAULT=build

IMAGE=hmcts/vsts-agent

build:
	docker build -t ${IMAGE} .

run:
	docker run -it --rm ${IMAGE} bash