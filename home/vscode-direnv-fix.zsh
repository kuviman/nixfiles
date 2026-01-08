# Copied from https://github.com/direnv/direnv-vscode/issues/561#issuecomment-1991534148
# This is a workaround to make direnv work with VS Code's integrated terminal
# when using the direnv extension, by making sure to reload
# the environment the first time terminal is opened.
#
# See https://github.com/direnv/direnv-vscode/issues/561#issuecomment-1837462994.
#
# The variable VSCODE_INJECTION is apparently set by VS Code itself, and this is how
# we can detect if we're running inside the VS Code terminal or not.
if [[ -n "$VSCODE_INJECTION" && -z "$VSCODE_TERMINAL_DIRENV_LOADED" && -f .envrc ]]; then
    cd ..
    cd -
    export VSCODE_TERMINAL_DIRENV_LOADED=1
fi
