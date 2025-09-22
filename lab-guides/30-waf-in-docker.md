# WAF in Docker

Login with Github account to
https://killercoda.com/playgrounds/scenario/ubuntu

```bash
curl -OL https://gist.githubusercontent.com/mkol5222/3e1076bb7a5d366df03cf05320715c7c/raw/9611c01c3f688eea6b2971ec42dca6db0a0fa94a/docker-compose.yaml

# create WAF profile, type Docker, single contaniner, managed - Publish and Enforce first
# save to .env file
echo "TOKEN=cp-aaaa" | tee .env

# fetch image
docker-compose pull

# start demo
docker-compose up -d

# make WAF asset with frontend URL http://demo.local and backend http://ip.iol.cz
# assign it to previously created WAF profile (Docker single managed)
# publish and enforce 

# access demo
curl http://demo.local/ip/ --resolve demo.local:80:127.0.0.1
# try some attack
curl "http://demo.local/?a=<script>alert(1)</script>" --resolve demo.local:80:127.0.0.1

# enter diagnostics
docker exec -it cloudguard-waf /bin/bash

# in the container
cpnano -s
nginx -T
cat /var/log/nginx/error.log

# you can also use Killercoda's URL as frontend (but HTTP as it is proxied by Killercoda)
```