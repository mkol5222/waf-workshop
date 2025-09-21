# WAF in Docker

https://killercoda.com/playgrounds/scenario/ubuntu

```bash
curl -OL https://gist.githubusercontent.com/mkol5222/3e1076bb7a5d366df03cf05320715c7c/raw/9611c01c3f688eea6b2971ec42dca6db0a0fa94a/docker-compose.yaml

echo "TOKEN=cp-aaaa" > .env

docker-compose pull

docker-compose up -d
```