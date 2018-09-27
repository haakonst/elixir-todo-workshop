# Elixir/Phoenix TODO list application

## Requirements

I've prepared a Dockerfile which can be used to build an image with all the necessary software needed to develop and run Elixir applications. So if you already have Git and Docker installed, you won't need anything else.

### Software
* [Git for Windows](https://gitforwindows.org/)
* [Docker CE for Windows](https://store.docker.com/editions/community/docker-ce-desktop-windows)

### Editor
Use your editor of choice, or for example [Visual Studio Code](https://code.visualstudio.com/) with the `vscode-elixir` extension for syntax highlighting etc.

### Config
Ensure that the `C:` drive is shared so it will be available to your Docker containers. Right click the Docker status icon and look under "Shared Drivers" in the "Settings" window.

## Clone the Git repository
```
cd C:/src/
git clone https://github.com/haakonst/elixir-todo-workshop.git
```

## Build the Docker image
```
cd C:/src/elixir-todo-workshop/
docker build -t elixir-todo-workshop .
```

## Run the Docker image
Use either of these commands (the latter is just a script file containing the former):
```
docker run --rm -it -v "C:/src/elixir-todo-workshop:/elixir-todo-workshop" elixir-todo-workshop
.\docker-run.ps1
```

## Start Elixir/Phoenix (inside the Docker container)
```
mix phx.server
```

## Visit the web application in your web browser
http://localhost:4000/

## Start coding
Start coding by editing the files in `C:/src/elixir-todo-workshop/`. Elixir will note which files are changed, and usually recompile on the fly, so the changes will be immediately visible in the browser. In some cases (for example when the config files are changed) however this don't work and the server must be stopped and restarted manually. Elixir will print an error message when this happens.
