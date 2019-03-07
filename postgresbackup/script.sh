sudo /usr/sbin/sshd &
sudo /usr/sbin/cron &
sudo chown -R pgbackrest:pgbackrest /var/lib/pgbackrest
sleep 30
pgbackrest --stanza=demo --log-level-console=info stanza-create || pgbackrest --stanza=demo --log-level-console=info stanza-upgrade
exec "$@"
