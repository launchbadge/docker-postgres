#!/usr/bin/env bash

# Ensure ownership of the volumes is consistent
chown -R postgres "$PGDATA"
chmod g+s /run/postgresql
chown -R postgres:postgres /run/postgresql

# When data directory is empty ..
if [ -z "$(ls -A "$PGDATA")" ]; then
  # Initiaize the database (for the first time)
  setuser postgres $PGBIN/initdb -D $PGDATA

  if [ "$POSTGRES_USER" = 'postgres' ]; then
    op='ALTER'
  else
    op='CREATE'
  fi

  # Create the initial user
  setuser postgres $PGBIN/postgres --single -jE <<-EOSQL
    $op USER "$POSTGRES_USER" WITH SUPERUSER PASSWORD '$POSTGRES_PASSWORD' ;
EOSQL

  # Allow all hosts to authenticate
  { echo; echo "host all all 0.0.0.0/0 md5"; } >> "$PGDATA"/pg_hba.conf
fi

# Force the usage of our provided configuration
cp /srv/postgresql.conf $PGDATA/postgresql.conf

# Startup postgres
setuser postgres $PGBIN/postgres -D $PGDATA
