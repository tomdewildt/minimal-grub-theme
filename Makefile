.PHONY: install uninstall emulator/start emulator/version
.DEFAULT_GOAL := help

NAMESPACE := tomdewildt
NAME := minimal-grub-theme

THEME_NAME := minimal
THEME_DIR := /boot/grub/themes
GRUB_CONFIG := /etc/default/grub
GRUB_GFXMODE := 1920x1080,auto

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
	
	@echo "INFO: Setting 'GRUB_GFXMODE' to '${GRUB_GFXMODE}'"
	@if grep "GRUB_GFXMODE=" ${GRUB_CONFIG} 2>&1 >/dev/null; then \
		sudo sed -i "s|.*GRUB_GFXMODE=.*|GRUB_GFXMODE=${GRUB_GFXMODE}|" ${GRUB_CONFIG}; \
	else \
		sudo echo "GRUB_GFXMODE=${GRUB_GFXMODE}" | sudo tee -a ${GRUB_CONFIG}; \
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

emulator/start: ## Start emulator
	@echo "NOTE: The emulator will only respond to input in this shell window."
	@echo "      Use 'c' to access the grub command prompt then type 'exit' to exit."
	@sleep 5
	sudo grub-emu

emulator/version: ## Check emulator version
	sudo grub-emu --version
