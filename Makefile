IMAGE_NAME := ai-sandbox
INSTALL_DIR := $(HOME)/.local/bin

.PHONY: build install uninstall

build:
	docker build --build-arg UID=$$(id -u) -t $(IMAGE_NAME) .

install: build
	install -d $(INSTALL_DIR)
	install -m 755 ai-sandbox $(INSTALL_DIR)/ai-sandbox

uninstall:
	rm -f $(INSTALL_DIR)/ai-sandbox
