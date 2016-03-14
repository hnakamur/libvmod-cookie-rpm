include .env

pwd := $(shell pwd)

.env:
	@./set_env.sh

build:
	docker build -t libvmod-cookie .

rpm: build .env
	@docker run --rm -e "COPR_LOGIN=$(COPR_LOGIN)" -e "COPR_USERNAME=$(COPR_USERNAME)" -e "COPR_PWD=$(COPR_PWD)" libvmod-cookie

debug: build .env
	@docker run --rm -ti --entrypoint bash -e "COPR_LOGIN=$(COPR_LOGIN)" -e "COPR_USERNAME=$(COPR_USERNAME)" -e "COPR_PWD=$(COPR_PWD)" libvmod-cookie

lint: build .env
	@docker run --rm -ti -v $(pwd)/.rpmlintrc:/root/.rpmlintrc --entrypoint bash libvmod-cookie -c "rpmlint -i /root/rpmbuild/SPECS/* /root/rpmbuild/SRPMS/*"

dockerlint:
	@docker run -v $(pwd)/Dockerfile:/Dockerfile --rm -ti lukasmartinelli/hadolint hadolint /Dockerfile

test:
	@make -s -C tests test
