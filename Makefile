BIN_DIR    := $(HOME)/.local/bin
SHARE_DIR  := $(HOME)/.local/share/claude-box
CONFIG_DIR := $(HOME)/.config

.PHONY: install

install:
	install -d $(BIN_DIR)
	install -d $(SHARE_DIR)
	install -d $(CONFIG_DIR)
	install -m 755 claude-box $(BIN_DIR)/claude-box
	install -m 644 Dockerfile $(SHARE_DIR)/Dockerfile
	@[ -f $(CONFIG_DIR)/claude-box.conf ] \
		&& echo "Skipping $(CONFIG_DIR)/claude-box.conf (already exists)" \
		|| install -m 644 claude-box.conf $(CONFIG_DIR)/claude-box.conf
	@echo "Installed claude-box to $(BIN_DIR)/claude-box"
	@echo "Make sure $(BIN_DIR) is in your PATH."
