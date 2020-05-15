## Repro

### Prereqs

First, download the `notary` tool from [Github](https://github.com/theupdateframework/notary/releases/tag/v0.6.1) to use for viewing local creds.
Also, can just look at files in `$HOME/.docker/trust/private` for the keys

Linux
```bash
wget -O notary https://github.com/theupdateframework/notary/releases/download/v0.6.1/notary-Linux-amd64
chmod +x notary
```

Mac
```bash
wget -O notary https://github.com/theupdateframework/notary/releases/download/v0.6.1/notary-Darwin-amd64
chmod +x notary
```

### Setup

```bash
git clone github.com/metral/notary-test
cd notary-test
export DOCKER_USERNAME='YOUR_USERNAME_HERE'
export DOCKER_PASSWORD='YOUR_PASSWORD_HERE'
```

### Build and push v0.0.1

```bash
./build_push.sh docker.io/$DOCKER_USERNAME/foobar001 v0.0.1
```

This should push and sign successfully.

Verify local key store, and inspect the image on DockerHub.

```bash
notary -s https://notary.docker.io -d ~/.docker/trust key list
docker trust inspect --pretty docker.io/$DOCKER_USERNAME/foobar001
```

### Build and push v0.0.2

```bash
./build_push.sh docker.io/$DOCKER_USERNAME/foobar001 v0.0.2
```

This should push and sign successfully.

Verify local key store, and inspect the image on DockerHub. Nothing should have
changed for the keys, and v0.0.2 should now be listed.

```bash
notary -s https://notary.docker.io -d ~/.docker/trust key list
docker trust inspect --pretty docker.io/$DOCKER_USERNAME/foobar001
```

### Build and push v0.0.3 with no `$HOME/.docker/trust`

To simulate future CI runs without the Docker trust dir for keys, move the
directory.

```bash
mv ~/.docker/trust ~/.docker/trust.bak
```

Verify local key store, and inspect the image on DockerHub.
The signing keys should be missing as expected.
This is what a future CI run would look like that does not have `$HOME/.docker/trust` locally.

```bash
notary -s https://notary.docker.io -d ~/.docker/trust key list
docker trust inspect --pretty docker.io/$DOCKER_USERNAME/foobar001
```

Try pushing v0.0.3, and notice that signing will fail based on what DockerHub
expects.

```bash
./build_push.sh docker.io/$DOCKER_USERNAME/foobar001 v0.0.3
```

This should fail to push and sign.

### Build and push v0.0.3 with `$HOME/.docker/trust`

To simulate future CI runs without the Docker trust dir for keys, move the
directory.

```bash
rm -rf ~/.docker/trust
cp -r ~/.docker/trust.bak/ ~/.docker/trust
```

```bash
./build_push.sh docker.io/$DOCKER_USERNAME/foobar001 v0.0.3
```

This should push and sign successfully.

Verify local key store, and inspect the image on DockerHub. Nothing should have
changed for the keys, and v0.0.3 should now be listed.

```bash
notary -s https://notary.docker.io -d ~/.docker/trust key list
docker trust inspect --pretty docker.io/$DOCKER_USERNAME/foobar001
```
