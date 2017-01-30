dependencies:
	@apt-get install $$(awk '/^\s*[^#]/' dependencies | xargs)

install:
	stow -R -t $(HOME)/.config conf

uninstall:
	stow -D -t $(HOME)/.config conf

.PHONY: dependencies install uninstall
