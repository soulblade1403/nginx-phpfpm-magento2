# ***Docker Magento 2.4.x***

Include: Nginx + php7.4-fpm + composer 1.19 + MySQL 5.7 + ElasticSearch 7.7.1 + Redis


## ***Prerequisites***
- docker
- docker-compose
- python3 or python2


## ***Usage:***
### Edit env file

```sh
nano .env.default
```

>
> ***## Project Env***
>
> PROJECT=mage-demo
>
>
> ***## Webserver Env***
>
> VHOST=domain
>
> APP_PORT=8000
>
> ADMIN_USER=secomm
>
> ADMIN_PASS=admin1212
>
> EMAIL=support@gmail.com
>
> DB_HOST=db
>
> DB_USER=magento
>
> DB_PASS=magento
>
> DB_NAME=magento
>
> 
> ***## DB Env***
>
> MYSQL_ROOT_PASSWORD=root
>
> MYSQL_USER=magento
>
> MYSQL_PASSWORD=magento
>
> MYSQL_DATABASE=magento
>
> 
> ***## Env PHPMyAdmin***
>
> PMA_PORT=8080
>
> PMA_HOST=db
>
> PMA_USER=magento
>
> PMA_PASSWORD=magento
>
> 
> ***## Magento Env***
>
> M2SETUP_DB_HOST=${DB_HOST}
>
> M2SETUP_DB_NAME=${DB_NAME}
>
> M2SETUP_DB_USER=${DB_USER}
>
> M2SETUP_DB_PASSWORD=${DB_PASS}
>
> M2SETUP_BASE_URL=http://${VHOST}/
>
> M2SETUP_BASE_URL_SECURE=https://${VHOST}/
>
> M2SETUP_BACKEND_FRONTNAME=admin
>
> M2SETUP_ADMIN_FIRSTNAME=Admin
>
> M2SETUP_ADMIN_LASTNAME=Secomm
>
> M2SETUP_ADMIN_EMAIL=${EMAIL}
>
> M2SETUP_ADMIN_USER=${ADMIN_USER}
>
> M2SETUP_ADMIN_PASSWORD=${ADMIN_PASS}
>
> M2SETUP_CURRENCY=AUD
>
> M2SETUP_LANGUAGE=en_US
>
> M2SETUP_TIMEZONE=Australia/Melbourne
>
> M2SETUP_USE_REWRITES=1
>
> M2SETUP_USE_SECURE=1
>
> M2SETUP_USE_SECURE_ADMIN=1
>
> M2SETUP_REDIS_HOST=redis
>
> M2SETUP_SEARCH_ENGINE=elasticsearch7
>
> M2SETUP_ES_HOST=es
>
> M2SETUP_ES_PORT=9200
>
> M2SETUP_USE_SAMPLE_DATA_STRING="true"
>

### Help
```sh
make
```

### Start all services
```sh
make start
```

### Update & Restart all services
```sh
make update
```

### Stop & Destroy all services
```sh
make destroy
```

### Check containers are running
```sh
docker ps -a
```

### SSH & Run a command in a running container
```sh
docker exec --user [USER] -it [CONTAINER_NAME/CONTAINER_ID] bash
OR
make ssh
```

### Backup Database
```sh
make backup
```
