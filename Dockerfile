FROM elixir:1.7.2

# Install Node.js
RUN curl -sSL "https://deb.nodesource.com/setup_8.x" | bash - \
    && apt-get install -y nodejs

# Install Yarn
RUN curl -sS "https://dl.yarnpkg.com/debian/pubkey.gpg" | apt-key add - \
    && echo "deb http://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get -y install yarn

# Install inotify-tools, PostgreSQL, Redis, build tools (including gcc and make) and Git (the latter for convenience only)
RUN apt-get update && apt-get -y install inotify-tools postgresql redis-server build-essential git

# Install  Hex (Erlang/Elixir package manager), Rebar (Erlang build tool) and Phoenix (web framework):
RUN mix local.hex --force \
    && mix local.rebar --force \
    && mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new.ez

# The policy-rc.d script must exit successfully, or the invocation of the postgresql service will be denied
RUN printf '#!/bin/sh\nexit 0' >/usr/sbin/policy-rc.d

RUN printf '#!/bin/sh\n\
set -e\n\
timer="5"\n\
until pg_isready -q\n\
do\n\
  echo "Waiting for PostgreSQL - sleeping for $timer seconds" >&2\n\
  sleep "$timer"\n\
done\n' >/pg_wait.sh
RUN chmod u+x /pg_wait.sh

# Change PostgreSQL authentication method for user postgres from PEER to MD5 and set password to "postgres"
RUN invoke-rc.d postgresql start \
  && /pg_wait.sh \
  && su -c "psql -c \"ALTER USER postgres WITH ENCRYPTED PASSWORD 'postgres';\"" postgres
RUN sed -i -e 's/^\(local[[:space:]]\+all[[:space:]]\+postgres[[:space:]]\+\)peer[[:space:]]*$/\1md5/' /etc/postgresql/9.6/main/pg_hba.conf

# Create build directories, so generated don't pollute the mapped source directory, as that might cause problems,
# at least when the source directory is on a Windows host.
RUN mkdir -p /elixir-todo-workshop-build/_build /elixir-todo-workshop-build/deps /elixir-todo-workshop-build/node_modules /elixir-todo-workshop-build/static

# Entry point script: Start PostgreSQL and Redis and run command (defaults to a shell),
# and add symlinks to the build directories.
RUN printf '#!/bin/sh\n\
set -e\n\
invoke-rc.d postgresql start\n\
invoke-rc.d redis-server start\n\
test -L _build || ln -sfT /elixir-todo-workshop-build/_build _build\n\
test -L deps || ln -sfT /elixir-todo-workshop-build/deps deps\n\
mkdir -p assets && test -L assets/node_modules || ln -sfT /elixir-todo-workshop-build/node_modules assets/node_modules\n\
mkdir -p priv && test -L priv/static || ln -sfT /elixir-todo-workshop-build/static priv/static\n\
/pg_wait.sh\n\
exec "$@"\n\
fi\n' >/entry.sh
RUN chmod u+x /entry.sh

# Fetch and bulid dependencies to facilitate getting started quicker with experimenting and devlopment.
# For this the source directory is needed, but it's deleted afterwards since when running this image,
# the source directory will be mapped from the host computer to better support editing and saving the files.
COPY . /elixir-todo-workshop
WORKDIR /elixir-todo-workshop

RUN test -L _build || ln -sfT /elixir-todo-workshop-build/_build _build \
  && test -L deps || ln -sfT /elixir-todo-workshop-build/deps deps \
  && mix deps.get \
  && mix deps.compile
RUN test -L priv/static || ln -sfT /elixir-todo-workshop-build/static priv/static \
  && test -L assets/node_modules || ln -sfT /elixir-todo-workshop-build/node_modules assets/node_modules \
  && cd assets \
  && yarn install \
  && node node_modules/brunch/bin/brunch build

# Create and migrate the database.
RUN invoke-rc.d postgresql start \
  && /pg_wait.sh \
  && mix ecto.create \
  && mix ecto.migrate

RUN rm -rf -- /elixir-todo-workshop

CMD "/bin/bash"
WORKDIR /elixir-todo-workshop
ENTRYPOINT ["/entry.sh"]
