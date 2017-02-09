dependencies:
	@apt-get install $$(awk '/^\s*[^#]/' dependencies | xargs)

install:
	stow --no-folding -R -t $(HOME)/.config conf
	mkdir -p $(HOME)/.local/share/images
	stow --no-folding -R -t $(HOME)/.local/share/images images
	mkdir -p $(HOME)/.local/bin
	stow --no-folding -R -t $(HOME)/.local/bin bin

uninstall:
	stow --no-folding -D -t $(HOME)/.config conf
	stow --no-folding -D -t $(HOME)/.local/share/images images
	stow --no-folding -D -t $(HOME)/.local/bin bin

.PHONY: dependencies install uninstall
