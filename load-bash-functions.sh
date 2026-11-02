#!/usr/bin/bash

# You must have a toolbox/.env for this to work. See toolbox/.env.example
if [ ! -f "toolbox/.env" ]; then
    echo "Error: File 'toolbox/.env' not found. Please copy toolbox/.env.example to toolbox/.env"
    return 1
fi

# Export every KEY=VALUE into this shell, so (docker|podman) compose can see them for
# ${VAR} substitution in compose.yml (e.g. build args) - env_file: only injects vars into
# the container at runtime, it has no effect on how compose.yml itself gets parsed.
set -a
source toolbox/.env
set +a

start-toolbox() {
  (docker compose run --rm --build toolbox bash) || (podman compose run --rm --build toolbox bash)
}
