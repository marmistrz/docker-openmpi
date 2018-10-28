# How to use
First generate the SSH keys using `ssh-keygen` (or reuse the ones from the previous installation)
and put them into the `ssh` subdirectory.

Then build the image
```
docker build -t openmpi .
```

Finally run the container.
```
docker run --privileged -d --network=host -v /path/to/wd:/mnt openmpi
```

Notes:
* `--privileged` is needed for `setarch` to work (used by AMPI)
* `--network=host` is needed because OpenMPI will use high ports for inter-node communication