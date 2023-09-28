# TDP Hue Notes

## Build a Hue release with TDP version

From your hue and after checkout the adequate branch, you must first build the image (one image for specific hue|python|os version) that will build the release with:

```bash
docker build . -t hue-tdp-builder-py3.8-rockylinux8 -f tdp/Dockerfile
```
PS: this image will copy your local hue directory, if you want to use another one you can adjust it like this:

```bash
docker build . -t hue-tdp-builder-py3.8-rockylinux8 -f tdp/Dockerfile
```


Then, you can execute the build container with the following arguments:

```bash
mkdir target
docker run --rm -v "./target:/opt/tdp" -it hue-tdp-builder-py3.8-rockylinux8  bash
```

And now, execute the following commands from the container: 
```bash
cd /hue
export ROOT=/hue;PREFIX=/opt/tdp PYTHON_VER=python3.8 make install
export ROOT=/hue;PREFIX=/opt/tdp PYTHON_VER=python3.8 make locales

cd /opt/tdp/hue
sh tools/relocatable.sh
rm -Rf node_modules/

cd -
mv /opt/tdp/hue /opt/tdp/hue-release-4.11.0
tar cvzf /opt/tdp/hue-release-4.11.0-python38.tar.gz -C /opt/tdp/ hue-release-4.11.0
```

This command generates a `tar.gz` file of the release at target/
