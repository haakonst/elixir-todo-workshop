# Elixir/Phoenix TODO list application

## Requirements
I've prepared a Dockerfile which can be used to build an image with all the necessary software needed to build and run Elixir applications. So if you already have Git and Docker installed, you don't need to install other software on your computer to test this out. The image is only useful for development and experimenting, not production stuff.

### Software
* [Git for Windows](https://gitforwindows.org/)
* [Docker CE for Windows](https://store.docker.com/editions/community/docker-ce-desktop-windows)

### Editor
Use your editor of choice, or for example [Visual Studio Code](https://code.visualstudio.com/) with the `vscode-elixir` extension for syntax highlighting etc.

### Config
Ensure that the `C:` drive is shared so it will be available to your Docker containers. Right click the Docker status icon and look under "Shared Drives" in the "Settings" window.
![Docker Settings: Shared Drives](docs/images/docker-settings-shared-drives.png?raw=true "Docker Settings: Shared Drives")

## Clone the Git repository
```
> cd C:/src/
> git clone https://github.com/haakonst/elixir-todo-workshop.git
```

## Build the Docker image
This will take some time.
```
> cd C:/src/elixir-todo-workshop/
> docker build -t elixir-todo-workshop .
```

## Run the Docker image
Use either of these commands (the latter is just a script file containing the former):
```
> docker run --rm -it -p 4000:4000 -v "C:/src/elixir-todo-workshop:/elixir-todo-workshop" elixir-todo-workshop
> .\docker-run.ps1
```

## Run Elixir/Phoenix (inside the Docker container)
Now you can try out simple stuff using the `iex`, an interactive Elixir REPL, or `elixir` to run scripts:
```
# iex
# elixir docs/examples/test.exs
```

To start the Phoenix application use this command:
```
# mix phx.server
```

## Visit the web application in your web browser
http://localhost:4000/

## Start coding
Start coding by editing the files in `C:/src/elixir-todo-workshop/`. Elixir will note which files are changed, and usually recompile on the fly, so the changes will be immediately visible in the browser. In some cases (for example when the config files are changed) however this don't work and the server must be stopped and restarted manually. Elixir will print an error message when this happens.

## Rebuilding and restarting
When this happens hit <kbd>Ctrl</kbd> + C and depending on what you've changed you might only need to restart the server: `mix phx.server`. In other cases you may need to issue one of these commands first:

* If you've changed the database schema: `mix ecto.migrate`
* If you've added new Mix dependencies (in `mix.exs`): `mix deps.get && mix deps.compile`
* If you've added new Node dependencies (in `assets/package.json`): `yarn install`
* If you've added Node dependencies or changed static JavaScript/CSS files: `node assets/node_modules/brunch/bin/brunch build`

## Advanced
If you want to have another shell in the Docker container, for example to test Elixir stuff with `iex` or `elixir` while your Phoenix application is running, start another command window, with PowerShell for example, and get the id or name of the Docker container and attach to it using these commands:
```
> docker ps
> docker exec -it CONTAINER /bin/bash
```

You can also connect to your running Phoenix application using this command (from inside the Docker container):
```
# iex -S mix
```

This will let you invoke functions in the modules of your applications. For example, to get the URL of the index page:
```
iex(1)> ElixirTodoWorkshopWeb.Router.Helpers.page_url(ElixirTodoWorkshopWeb.Endpoint, :index)
"http://localhost:4000/"
```

## Learn more
* Elixir official website, including a nice getting started guide: https://elixir-lang.org/
* Elixir and Erlang package repository: https://hex.pm/
* Elixir packages docs, including the standard library: https://hexdocs.pm/
* Elixir Forum: https://elixirforum.com/
* Elixir School: https://elixirschool.com/
* Execute Elixir Online: http://www.compileonline.com/execute_elixir_online.php/
* ElixirCasts: https://elixircasts.io/
* Phoenix official website: http://www.phoenixframework.org/
* Phoenix guides: http://phoenixframework.org/docs/overview
* Phoenix docs: https://hexdocs.pm/phoenix
* Phoenix Mailing list: http://groups.google.com/group/phoenix-talk
* Phoenix Source: https://github.com/phoenixframework/phoenix
