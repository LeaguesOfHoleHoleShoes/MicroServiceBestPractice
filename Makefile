# note: call scripts from /scripts

# project name
PROJECTNAME=$(shell basename "$(PWD)")

# project path
ROOT=$(shell pwd)

.PHONY: help
all: help
help: Makefile
	@echo
	@echo " Choose a command run in "$(PROJECTNAME)":"
	@echo
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo

## test: run prject all unit tests
test:
	@echo "run project unit test"
	#@./scripts/shell.sh

## build: build project, all binaries for programs to $GOPATH/bin
build:
	@echo "build project"
	#@./scripts/shell.sh

checkx:
	@echo "build project"
	#@./scripts/shell.sh