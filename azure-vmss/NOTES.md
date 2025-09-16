

# customizations

```bash
/bin/bash -c '( echo "[$(date)] Starting bootstrap"; clish -c "lock database override"; clish -c "set ntp server primary pool.ntp.org version 3"; clish -c "set ntp active on"; clish -c "save config"; echo "[$(date)] Finished bootstrap" ) >> /var/log/bootstrap.log 2>&1 &'
```