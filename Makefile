dependencies:
	@apt-get install $$(awk '/^\s*[^#]/' dependencies | xargs)

install:
	stow --no-folding -R -t $(HOME)/.config conf
	mkdir -p $(HOME)/.local/share/images
	stow --no-folding -R -t $(HOME)/.local/share/images images

uninstall:
	stow --no-folding -D -t $(HOME)/.config conf
	stow --no-folding -D -t $(HOME)/.local/share/images images

.PHONY: dependencies install uninstall
