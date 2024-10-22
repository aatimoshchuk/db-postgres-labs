set container-name=postgres-with-logs
set image-name=db-postgres-labs-postgres

docker stop %container-name%
docker rm %container-name%
docker rmi %image-name%
docker compose up -d
timeout /t 5