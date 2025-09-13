## Issue sonarqube service can not access via web-browser!

```
Fix step-by-step (for persistent volumes)

docker rm -f sonarqube

sudo mkdir -p /var/sonarqube/{data,logs,extensions}

sudo chown -R 1000:1000 /var/sonarqube

## Run SonarQube again

docker run -d --name sonarqube \
  -p 9000:9000 \
  -v /var/sonarqube/data:/opt/sonarqube/data \
  -v /var/sonarqube/logs:/opt/sonarqube/logs \
  -v /var/sonarqube/extensions:/opt/sonarqube/extensions \
  sonarqube:latest


## Check logs

docker logs -f sonarqube
```