# llmjail

Run a shell in an isolated docker container so you can let your llms --dangerously-skip-permissions

Very specific to my dev needs. Fork and tune to your own taste!

### Build
```sh
$ ./docker-build
```

### Usage
```sh
# Get an interactive shell in the docker container
# - Drop-in replacement for `bash`
$ llmjail

# Run a command in the docker container
# - Drop-in replacement for `bash -c <cmd>`
$ llmjail -c <cmd>
```

### Use in opencode
```sh
$ SHELL=/path/to/llmjail/llmjail opencode ...
```
