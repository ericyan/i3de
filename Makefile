dependencies:
	@apt-get install $$(awk '/^\s*[^#]/' dependencies | xargs)

install:
	stow --no-folding -R -t $(HOME)/.config conf

uninstall:
	stow --no-folding -D -t $(HOME)/.config conf

.PHONY: dependencies install uninstall
