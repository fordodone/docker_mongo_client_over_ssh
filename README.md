# Docker MongoDB Client Over SSH Tunnels

Connect to a MongoDB Atlas Cluster over SSH Tunnels

## Primary Concerns

- MongoDB Atlas replica sets have multiple nodes/hosts
- the MongoDB client is node aware and might be "redirected" via hostname and standard MongoDB TCP port to other nodes in the replica set
- because of this hostnames and ports used locally must match hostnames and ports used remotely
- MongoDB Atlas permits network access only from user defined IP addresses and networks
- connecting to MongoDB Atlas hosted service requires TLS
- using TLS properly requires clients to use hostnames that match the TLS certificates of the server hostname (IP addresses won't work)
- docker and compose can be used as a well defined setup and repeatability tool, as well as help to avoid network changes or installing software to the docker host
- at the time of this writing assigning multiple static IPs to the same interface with docker is not possible

## Running

Clone this repo:
```
git clone https://github.com/fordodone/docker_mongo_client_over_ssh.git
cd docker_mongo_client_over_ssh
```
Edit `mongorc.js` with appropriate `mongodb://` connect string
Edit `docker-compose.yml` with the 3 (or more) MongoDB Atlas Shard Hostnames
Run the compose project to bring up the ssh tunnels
```
docker-compose up
```
Open a new terminal, run mongo shell, and `mongorc.js` gets run connecting the client to the remote MongoDB Atlas replica set
```
cd docker_mongo_client_over_ssh
docker-compose exec mongossh mongo --nodb
```


## Alternatively Using Loopback Interface

The loopback interface on Linux listens for any IP address in 127.0.0.0/8 subnet. This means you can just pick `127.anything` and use it for ssh tunneling instead of setting up subnets and static IPs.


docker-compose.yml host mapping for lo:
```
    extra_hosts:
      - 'mycluster0-shard-00-00-example.mongodb.net:127.0.0.2'
      - 'mycluster0-shard-00-01-example.mongodb.net:127.0.0.3'
      - 'mycluster0-shard-00-02-example.mongodb.net:127.0.0.4'
```
docker-compose.yml ssh tunnel config for lo:
```
      - -L
      - 127.0.0.2:27017:mycluster0-shard-00-00-example.mongodb.net:27017
      - -L
      - 127.0.0.3:27017:mycluster0-shard-00-01-example.mongodb.net:27017
      - -L
      - 127.0.0.4:27017:mycluster0-shard-00-02-example.mongodb.net:27017
```

## TODO
- add user known host keys for ssh connection
- write import/export wrappers
