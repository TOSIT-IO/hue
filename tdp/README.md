# TDP Hue Notes

## Prepare the hue-builder container

From the cloned Hue repository and after switching to the adequate branch, use the image for python compiled components from the [TDP main repository](`https://github.com/TOSIT-IO/TDP/build-env-python`).

Then, execute the build container with the following arguments:

```bash
# Create the target folder in the hue directory
mkdir target
# Create the hue-builder container
docker run --name hue-builder --rm -w "/hue" -v "./target:/opt/tdp" -it tdp_builder_python bash
```

- `-w "/hue"` is the working directory inside the container
- `-v "./target:/opt/tdp"` is the volume which will bind the build output inside the container with the local host.

Open another window outside of the container and copy the Hue repository inside the container. The reason we do not use a volume is that the build process modifies the files and we do not want our original repository to be affected.

```sh
docker cp . hue-builder:/hue
```

## Build the Hue release

And now, execute the following commands from the container.

Create the following repositories:

```bash
mkdir /usr/include/python.3.8
mkdir /usr/local/include/python.3.8
mkdir -p /usr/local/python38/include/python3.8
mkdir -p /opt/rh/rh-python38/root/usr/include/python3.8
```

Copy the python-devel header since the `Makefile.vars` checks if it is located in the following directories, otherwise it throughs an error:

```sh
cp /opt/_internal/cpython-3.8.19/include/python3.8/Python.h /usr/include/python.3.8
cp /opt/_internal/cpython-3.8.19/include/python3.8/Python.h /usr/local/include/python.3.8/
cp /opt/_internal/cpython-3.8.19/include/python3.8/Python.h /usr/local/python38/include/python3.8/
cp /opt/_internal/cpython-3.8.19/include/python3.8/Python.h /opt/rh/rh-python38/root/usr/include/python3.8/
```

Add the Python binary path that we are using in this image to the path variable:

```sh
export PATH=/opt/_internal/cpython-3.8.19/bin:$PATH
```

Proceed with the build process with the internationalization:

```sh
export ROOT=/hue; PREFIX=/opt/tdp PYTHON_VER=python3.8 SYS_PYTHON=/opt/_internal/cpython-3.8.19/bin/python3.8 SYS_PIP=/opt/_internal/cpython-3.8.19/bin/pip3.8 make install
# Performs the internationalization.
export ROOT=/hue; PREFIX=/opt/tdp PYTHON_VER=python3.8 SYS_PYTHON=/opt/_internal/cpython-3.8.19/bin/python3.8 SYS_PIP=/opt/_internal/cpython-3.8.19/bin/pip3.8 make locales
cd /opt/tdp/hue
# Make a Hue installation relocatable.
sh tools/relocatable.sh
rm -Rf node_modules/
```

## Package the release in a tarball

Generate a `tar.gz` file of the release in the local `target/` folder:

```sh
cd -
mv /opt/tdp/hue /opt/tdp/hue-release-4.11.0
tar cvzf /opt/tdp/hue-release-4.11.0-python38.tar.gz -C /opt/tdp/ hue-release-4.11.0
```

**Note**: [Cloudera](https://docs.cloudera.com/cdp-private-cloud-base/7.1.8/installation/topics/cdpdc-install-python-3-centos.html) states to install a compiled Python with the shared library option enabled which is not the case in the [manylinux image](https://github.com/pypa/manylinux/blob/main/docker/build_scripts/build-cpython.sh#L36).
