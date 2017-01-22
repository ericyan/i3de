install:
	stow -R -t $(HOME)/.config conf

uninstall:
	stow -D -t $(HOME)/.config conf

.PHONY: install uninstall
