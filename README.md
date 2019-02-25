# How to use
First generate the SSH keypair using `ssh-keygen` (or reuse the ones from the previous installation).
```
mkdir ssh
ssh-keygen -f ssh/mpi
```
Make sure that you're using the same keypair across all your nodes.

Then build the image
```
docker build -t openmpi .
```

Finally run the container.
```
docker run --privileged -d --network=host --shm-size=32g -v /path/to/wd:/mnt openmpi
```

Notes:
* `--privileged` is needed for `setarch` to work (used by AMPI)
* `--network=host` is needed because OpenMPI will use high ports for inter-node communication
