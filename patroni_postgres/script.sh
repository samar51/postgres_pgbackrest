sudo /usr/sbin/sshd &
sudo chown -R postgres:postgres /data
patroni /run/secrets/patroni.yml
exec "$@"
