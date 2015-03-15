cocuh-backward-delete-word() {
    local WORDCHARS="${WORDCHARS:s#/#}"
    local WORDCHARS="${WORDCHARS:s#.#}"
    zle backward-delete-word
}

zle -N cocuh-backward-delete-word
bindkey "^W" cocuh-backward-delete-word
