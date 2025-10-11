> Setting

```
brew install poetry

poetry init -n \
  --name "fastapi-backend" \
  --description "FastAPI backend for monorepo" \
  --license "MIT"

poetry add fastapi "uvicorn[standard]" pydantic-settings python-dotenv

poetry add -D ruff mypy pytest pytest-asyncio httpx types-python-dotenv

poetry shell

mkdir -p app/{api,core,features,__init__.d} tests

touch app/__init__.py app/main.py app/core/settings.py app/api/routes.py
```

> Run

`poetry run uvicorn app.main:app --reload --port 8080`

to check app is running, send get reuqest

```
brew install jq

curl -X GET http://localhost:8080/health | jq
```


> Docker

```
docker rm -f mysql-local

docker volume rm mysql_local_data

docker run --name mysql-local \
  -e MYSQL_ROOT_PASSWORD=1221 \
  -e MYSQL_DATABASE=fastapi_db \
  -p 3306:3306 \
  -v mysql_local_data:/var/lib/mysql \
  -d mysql:8

docker start mysql-local

docker exec -it mysql-local bash

mysql -u root -p -h 127.0.0.1 -P 3306

use fastapi_db

create schema `fastapi-ca`;
```