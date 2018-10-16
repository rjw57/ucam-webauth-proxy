# Simple UcamWebAuth Proxy

This container provides a basic Apache configuration which can be used to proxy
another container and protect resources via UcamWebAuth. By default resources
may be accessed by any valid UcamWebAuth user. Optionally resources may be
further constrained by Lookup group.

## Example

```bash
$ docker run --rm -it \
    -e SERVER_NAME=localhost \
    -e BACKEND_URL=http://www.example.com/ \
    -p 8080:80 \
    rjw57/ucam-webauth-proxy
```

Visiting http://localhost:8080/ results in a UcamWebAuth-protected instance of
http://example.com/.

Access may be further restricted to a given Lookup group. For example, to
restrict a resource to members of the [UIS
group](https://www.lookup.cam.ac.uk/group/uis-members):

```bash
$ docker run --rm -it \
    -e SERVER_NAME=localhost \
    -e BACKEND_URL=http://www.example.com/ \
    -e LOOKUP_GROUP_ID=101611 \
    -p 8080:80 \
    rjw57/ucam-webauth-proxy
```

## Configuration

The following environment variables are used for configuration:

* BACKEND_URL (required) - URL of site to proxy. Example: http://example.com/
* SERVER_NAME (required) - FQDN of site. Used by mod_ucam_webauth module to
    ensure that the user is on the "canonical" site.
* LOOKUP_GROUP_ID (optional) - Lookup group ID to further restrict valid users.

## Replicated deployment

For convenience, the container generates a random key used to encrypt the
session cookie if one is not specified. For a replicated deployment, you will
want to use the same cookie for each replica. It can be mounted inside the
container via a volume:

```bash
# Generate the cookie
$ head -c 64 /dev/urandom > webauthcookie.key

# Launch the proxy
$ docker run --rm -it \
    -e SERVER_NAME=localhost \
    -e BACKEND_URL=http://www.example.com/ \
    -v $PWD/webauthcookie.key:/etc/apache2/webauthcookie.key:ro \
    -p 8080:80 \
    rjw57/ucam-webauth-proxy
```

## Building the container

The container is available on Docker hub but may be built explicitly via the
usual ``docker build -t rjw57/ucam-webauth-proxy .`` command issued in the root
of the repository.
