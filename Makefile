.PHONY: install uninstall emulator/init emulator/start emulator/version
.DEFAULT_GOAL := help

NAMESPACE := tomdewildt
NAME := minimal-grub-theme

THEME_NAME := minimal
THEME_DIR := /boot/grub/themes
GRUB_CONFIG := /etc/default/grub

help: ## Show this help
	@echo "${NAMESPACE}/${NAME}"
	@echo
	@fgrep -h "##" $(MAKEFILE_LIST) | \
	fgrep -v fgrep | sed -e 's/## */##/' | column -t -s##

##

install: ## Install theme
	@echo "INFO: Saving config as ${GRUB_CONFIG}.backup"
	@sudo cp -f ${GRUB_CONFIG} ${GRUB_CONFIG}.backup

	@echo "INFO: Copying '${THEME_NAME}' to '${THEME_DIR}'"
	@sudo mkdir -p ${THEME_DIR}
	@sudo rm -rf ${THEME_DIR}/${THEME_NAME}
	@sudo cp -rf ./${THEME_NAME} ${THEME_DIR}

	@echo "INFO: Setting 'GRUB_BACKGROUND' to '${THEME_DIR}/${THEME_NAME}/background.png'"
	@if grep "GRUB_BACKGROUND=" ${GRUB_CONFIG} 2>&1 >/dev/null; then \
		sudo sed -i "s|.*GRUB_BACKGROUND=.*|GRUB_BACKGROUND=\"${THEME_DIR}/${THEME_NAME}/background.png\"|" ${GRUB_CONFIG}; \
	else \
		sudo echo "GRUB_BACKGROUND=\"${THEME_DIR}/${THEME_NAME}/background.png\"" | sudo tee -a ${GRUB_CONFIG}; \
	fi
	
	@echo "INFO: Setting 'GRUB_THEME' to '${THEME_DIR}/${THEME_NAME}/theme.txt'"
	@if grep "GRUB_THEME=" ${GRUB_CONFIG} 2>&1 >/dev/null; then \
		sudo sed -i "s|.*GRUB_THEME=.*|GRUB_THEME=\"${THEME_DIR}/${THEME_NAME}/theme.txt\"|" ${GRUB_CONFIG}; \
	else \
		sudo echo "GRUB_THEME=\"${THEME_DIR}/${THEME_NAME}/theme.txt\"" | sudo tee -a ${GRUB_CONFIG}; \
	fi

	@echo "INFO: Updating grub"
	@sudo update-grub

uninstall: ## Uninstall theme
	@echo "INFO: Removing '${THEME_NAME}' from '${THEME_DIR}'"
	@sudo rm -rf ${THEME_DIR}/${THEME_NAME}

	@echo "INFO: Setting 'GRUB_THEME' to ''"
	@if grep "GRUB_THEME=" ${GRUB_CONFIG} 2>&1 >/dev/null; then \
		sudo sed -i "s|.*GRUB_THEME=.*|GRUB_THEME=\"\"|" ${GRUB_CONFIG}; \
	fi

	@echo "INFO: Updating grub"
	@sudo update-grub

##

emulator/init: ## Setup emulator
	sudo apt install grub-common qemu-system-x86 ovmf mtools
	pip install grub2-theme-preview 

emulator/start: ## Start emulator
	grub2-theme-preview minimal

emulator/version: ## Check emulator version
	grub2-theme-preview --version
