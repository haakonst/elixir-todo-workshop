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

# Change PostgreSQL authentication method for user postgres from PEER to MD5 and set password to "postgres"
RUN invoke-rc.d postgresql start \
  && su -c "psql -c \"ALTER USER postgres WITH ENCRYPTED PASSWORD 'postgres';\"" postgres
RUN sed -ie 's/^\(local[[:space:]]\+all[[:space:]]\+postgres[[:space:]]\+\)peer[[:space:]]*$/\1md5/' /etc/postgresql/9.6/main/pg_hba.conf

# Entry point script: Start PostgreSQL and Redis and run command (defaults to a shell)
RUN printf '#!/bin/sh\n\
set -e\n\
invoke-rc.d postgresql start\n\
invoke-rc.d redis-server start\n\
exec "$@"\n\
fi\n' >/entry.sh
RUN chmod u+x /entry.sh

CMD "/bin/bash"
EXPOSE 4000
WORKDIR /elixir-todo-workshop
ENTRYPOINT ["/entry.sh"]
