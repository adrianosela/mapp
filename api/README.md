## Mapp API

The back end is written in Node (JavaScript) using the [Express](https://expressjs.com/) web framework.

### Run on Your Machine

```
node index.js
```

### Run In Docker

##### build docker image:

```
docker build -t mapp
```

or using the makefile target:
```
make build
```


##### run docker image:

```
docker run -d --name mapp_service -p 8080:80 mapp
```

or using the makefile target:
```
make up
```
