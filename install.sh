#!/bin/bash
# ----------------------------------------------------------------------
# | Helper Functions                                                   |
# ----------------------------------------------------------------------
print_error() {
	printf "\\e[0;31m%s\\e[0m\\n" " [ ✖ ] $1 $2"
}

print_info() {
	printf "\\e[0;35m%s\\e[0m\\n" "$1"
}

print_result() {
	if [ "$1" -eq 0 ]; then
		printf "\\e[0;32m%s\\e[0m\\n" " [ ✔ ] $2"
	else
		print_error "$2"
	fi

	return "$1"
}

ask_for_sudo() {
	sudo -v &>/dev/null
	# Update existing `sudo` time stamp until this script has finished
	# https://gist.github.com/cowboy/3118588
	while true; do
		sudo -n true
		sleep 60
		kill -0 "$$" || exit
	done &>/dev/null &
}

verify_os() {
	if [ ! "$(uname -s)" == "Linux" ]; then
		echo "Sorry, this script is intended only for Debain based distros!"
		exit 1
	fi
}

show_spinner() {
	local -r FRAMES='/-\|'
	# shellcheck disable=SC2034
	local -r NUMBER_OR_FRAMES=${#FRAMES}
	local -r CMDS="$2"
	local -r MSG="$3"
	local -r PID="$1"
	local i=0
	local frameText=""

	# Display spinner while the commands are being executed.
	while kill -0 "$PID" &>/dev/null; do
		frameText="   [${FRAMES:i++%NUMBER_OR_FRAMES:1}] $MSG"
		printf "%s" "$frameText"
		sleep 0.2
		printf "\\r"
	done
}

set_trap() {
	trap -p "$1" | grep "$2" &>/dev/null || trap '$2' "$1"
}

execute() {
	local -r CMDS="$1"
	local -r MSG="${2:-$1}"
	local -r TMP_FILE="$(mktemp /tmp/XXXXX)"
	local exitCode=0
	local cmdsPID=""

	# If the current process is ended,
	# also end all its subprocesses.
	set_trap "EXIT" "kill_all_subprocesses"

	# Execute commands in background
	eval "$CMDS" \
		&>/dev/null \
		2>"$TMP_FILE" &

	cmdsPID=$!

	show_spinner "$cmdsPID" "$CMDS" "$MSG"
	wait "$cmdsPID" &>/dev/null
	exitCode=$?
	print_result $exitCode "$MSG"

	if [ $exitCode -ne 0 ]; then
		print_error_stream <"$TMP_FILE"
	fi

	rm -rf "$TMP_FILE"
	return $exitCode
}

print_error_stream() {
	while read -r line; do
		print_error "↳ ERROR: $line"
	done
}

cmd_exists() {
	command -v "$1" &>/dev/null
	return $?
}

# --------------------------------------------------------------------
# | Main Functions                                                   |
# --------------------------------------------------------------------

install_apps() {

	print_info "Installing apps"

	APPS=(
		alacritty
    curl
    git
    htop
    btop
    jq
    zsh
    tmux
    fd
		aws-cli
		bandwhich
		discord
		docker
		docker-compose
		git-delta
		github-cli
		neofetch
		obs-studio
		slack-desktop
		spotify
		telegram-desktop
		tldr
		transmission-gtk
		vlc
	)

	for pkg in "${APT_APPS[@]}"; do
			execute "apt-get install $pkg"
	done
}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {
	verify_os

	ask_for_sudo

	install_apps

	echo "Success! Please restart the terminal to see the changes!"
}

main
