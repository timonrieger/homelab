if status is-interactive
    atuin init fish | source
end

alias ds "docker ps -a --format 'table {{.ID}}\t{{.Status}}\t{{.Names}}\t{{.Ports}}'"
