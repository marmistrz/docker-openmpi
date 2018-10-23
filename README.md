# How to use
First generate the SSH keys using `ssh-keygen` (or reuse the ones from the previous installation)
and put them into the `ssh` subdirectory.

Then build the image
```
docker build -t openmpi .
```

Finally run to forward the SSH port
```
docker run --privileged -d -p 4222:22 -v /path/to/wd:/mnt openmpi
```