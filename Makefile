AGENTS := claude

.PHONY: install $(AGENTS)

install: $(AGENTS)

$(AGENTS):
	$(MAKE) -C $@ install
