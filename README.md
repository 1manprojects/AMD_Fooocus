# AMD Dockerfile for FOOOCUS

Big Thanks to [Fooocus](https://github.com/lllyasviel/Fooocus) please check it out.

The following is a Dockerbuild file to create a docker image to utalize AMD - GPU with Fooocus.

# Build Docker Image
checkout this repository and enter the directory.
Install the following dependencies

`sudo dnf install rocminfo rocm-opencl rocm-hip`

Then we have to clone the Fooocus repository from github with
`git clone https://github.com/lllyasviel/Fooocus.git`

build with
`sudo docker build -t fooocus .`

and run with
`sudo docker run --rm -p 7865:7865 -v ./models:/fooocus/Fooocus/models -v ./output:/fooocus/Fooocus/outputs -it --device=/dev/kfd --device=/dev/dri --security-opt seccomp=unconfined --group-add video fooocus`