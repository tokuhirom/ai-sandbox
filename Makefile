INSTALL_DIR := $(HOME)/.local/bin

.PHONY: install uninstall

install:
	install -d $(INSTALL_DIR)
	install -m 755 ai-sandbox $(INSTALL_DIR)/ai-sandbox

uninstall:
	rm -f $(INSTALL_DIR)/ai-sandbox
