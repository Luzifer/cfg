local GPG_ENV=$HOME/.gnupg/gpg-agent.env

function start_agent_nossh {
    eval $(/usr/bin/env gpg-agent --quiet --daemon --write-env-file ${GPG_ENV} --allow-preset-passphrase 2> /dev/null)
    chmod 600 ${GPG_ENV}
}

# source settings of old agent, if applicable
if [ -f "${GPG_ENV}" ]; then
    source ${GPG_ENV} > /dev/null
    export GPG_AGENT_INFO
fi

# check again if another agent is running using the newly sourced settings
if ! gpg-connect-agent --quiet /bye > /dev/null 2> /dev/null; then
    start_agent_nossh;
fi

GPG_TTY=$(tty)
export GPG_TTY
