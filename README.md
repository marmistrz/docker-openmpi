# How to use
First generate the SSH keys using `ssh-keygen` and put them into the `ssh` subdirectory.

Then build the image
```
docker build -t openmpi .
```

Finally run to forward the SSH port
```
docker run -d -p 2222:22 openmpi
