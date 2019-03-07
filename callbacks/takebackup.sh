#!/bin/bash
export LC_ALL="POSIX"
ssh pgbackrest@pgbackrest "export LC_ALL=\"POSIX\" && pgbackrest --stanza=demo --log-level-console=info backup"
