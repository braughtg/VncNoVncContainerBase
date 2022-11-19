#!/usr/bin/env bash

SCRIPT_PATH="${BASH_SOURCE[0]}"
SCRIPT_NAME="$( basename -- "${SCRIPT_PATH}" )"
SCRIPT_DIR="$( cd -- "$( dirname -- "${SCRIPT_PATH}" )" &> /dev/null && pwd )"

main() {
    exit-if-not-installed-as-a-git-hook
    uninstall-this-git-hook
    install-kit-features-into-client
}

exit-if-not-installed-as-a-git-hook() {
    PARENT="$(basename -- "$SCRIPT_DIR" )"
    GRAND_PARENT="$(basename -- "$(dirname -- "$SCRIPT_DIR" )" )"
    if [[ "$GRAND_PARENT/$PARENT" != ".git/hooks" ]] ; then
        echo "Not running as a git hook."
        exit 0
    fi
}

uninstall-this-git-hook() {
    mv "${SCRIPT_PATH}" "${SCRIPT_DIR}/${SCRIPT_NAME}.disabled"
}

install-kit-features-into-client() {
    (
        cd "$SCRIPT_DIR/../.." || return 1
        script="./.kit/features/install-features-into-client/run.sh"
        if [[ -e "$script" ]] ; then
            "$script"
        fi
    )
}

main "$@"
