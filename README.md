# OOD Remote Desktop - ROS / Gazebo / Matlab

This repo contains a working configuration to run a remote desktop in an apptainer configuration in Open OnDemand in the HUIT OOD environment. It requires a [spack](https://spack.io/) environment to use [apptainer](https://apptainer.org/) commands, and also requires a built container that exists in a location accessible to compute nodes. In this case that's a shared EFS volume.

## Compute Nodes

This app is configured to run on desktop nodes configured by Parallel Cluster, assumed to be in a queue called `desktop`. This will ensure that VNC is available for the remote desktop connection. 

## Spack Environment

The spack environment is articulated in `spack-environment/apptainer/spack.yml`. The environment can be created with a command like `spack env create apptainer ./spack-environment/apptainer/spack.yml` from the root of this repo. The run script at `template/script.sh.erb` will activate the spack installation at `/shared/spack` and then the environment called `apptainer` in order to run the container.

## Apptainer container

The desktop image, built in build/rosgazebo.def, will set up a desktop image containing [ROS Noetic](https://www.ros.org/), [Gazebo](https://gazebosim.org/home), [Matlab](https://matlab.com), and [VS Codium](https://vscodium.com/). The Matlab installation requires some additional setup in advance. There must be a Matlab installation directory at /shared/MATLAB, and it must contain an appropriate `network.lic` file and `installer_input.txt` file. These are used in the installation process, but are not included in this repository.

The Matlab installation directory must be downloaded from Matlab, following the instructions to [Download Products without Installing](https://www.mathworks.com/help/install/ug/download-without-installing.html). The installation and configuration files are stored in an S3 bucket called `ood-software` for easier access.

The image can be built after the apptainer module is loaded with `apptainer build /shared/apptainerImages/rosgazebo.sif ./build/rosgazebo.def` from the root of this repo. This is a native apptainer image build, primarily using shell scripting in the `%post` section. See the build definition itself for full details on the image.
