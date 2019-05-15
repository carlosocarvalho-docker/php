## PHP 7.3 docker support

### Drivers database support

<img src="https://img.shields.io/badge/Driver_For-Sql_Server_13-green.svg?style=flat-square"></a>
<img src="https://img.shields.io/badge/Driver_For-Mongo_DB-green.svg?style=flat-square"></a>
<img src="https://img.shields.io/badge/Driver_For-MySQL_| Mariadb-green.svg?style=flat-square"></a>
<img src="https://img.shields.io/badge/Driver_For-Redis-green.svg?style=flat-square"></a>

### Frameworks support

<img src="https://img.shields.io/badge/Laravel- >=5-red.svg?style=flat-square"></a>
<img src="https://img.shields.io/badge/Codeigniter- 3 -red.svg?style=flat-square"></a>

### Use with docker swarm file-compose 

For use this exemple with **docker-compose** check guide from docker.

```js

version: "3.7"
services:
  redis:
    networks: 
      - api_esnet 
    image: redis:alpine
    deploy:
      resources:
        limits:
          cpus: '0.50'
          memory: 256M
  mongodb:
    networks: 
      - api_esnet 
    image: bitnami/mongodb:4.1
    ports: 
      - target: 27017
        published: 27018
        mode: host
    volumes:
      - mongodbVolume:/bitnami
  database:
    image: mariadb
    environment:
      MYSQL_ROOT_PASSWORD: 123456
      MYSQL_DATABASE: deloitte
    ports: 
      - target: 3306
        published: 3308
        mode: host  
    deploy:
      resources:
        limits:
          cpus: '0.50'
          memory: 256M
    volumes:
      - dbVolume:/var/lib/mysql      
    networks: 
      - api_esnet
  php:
    image: carlosocarvalho/php-api-laravel-es:1.0.1
    working_dir: /application
    volumes: &applicationVolume
        - ./:/application
        - ./docker/php-fpm/php-ini-overrides.ini:/etc/php/7.2/fpm/conf.d/99-overrides.ini
    depends_on:
      - mongodb
      - redis
      - elasticsearch
      - database
    deploy:
      resources:
        limits:
          cpus: '0.50'
          memory: 256M
    networks: 
      - api_esnet
//use schedule wiht horizon      
  queue:
    networks: 
      - api_esnet 
    image: carlosocarvalho/php-api-laravel-es:1.0.0
    depends_on:
       - php
    volumes: *applicationVolume
    command: php artisan horizon
    deploy:
      resources:
        limits:
          cpus: '0.50'
          memory: 256M
//use schedule with kernel          
  schedule:
    networks: 
      - api_esnet 
    image: carlosocarvalho/php-api-laravel-es:1.0.0
    depends_on:
       - php
    volumes: *applicationVolume
    environment:
       - CONTAINER_ROLE=scheduler
    command: start
    deploy:
      resources:
        limits:
          cpus: '0.50'
          memory: 256M
  nginx:
    image: nginx:alpine
    working_dir: /application
    volumes:
    - .:/application
    - ./docker/nginx/nginx.conf:/etc/nginx/conf.d/default.conf
    ports: 
      - target: 80
        published: 8083
        mode: host
    depends_on:
      - php
      - audix
    networks: 
      - api_esnet
      - audix_net
    deploy:
      replicas: 1
      resources:
        limits:
          cpus: '0.50' 
          memory: 512M           
volumes:
  mongodbVolume:
    driver: local
  dbVolume:
    driver: local
networks:
  api_esnet:
```