ARG UBUNTU_VERSION=18.04
ARG ROS_DISTRO=melodic
ARG ROBOTIC_BRANCH=melodic-devel

FROM ubuntu:${UBUNTU_VERSION}
RUN apt -y update && \
    DEBIAN_FRONTEND=noninteractive apt -y install curl lsb-core && \
    rm -rf /var/lib/apt/lists/*
RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc |  apt-key add -
RUN apt -y update  && \
    DEBIAN_FRONTEND=noninteractive apt -y install ros-melodic-desktop-full && \
    rm -rf /var/lib/apt/lists/*

ENV LD_LIBRARY_PATH=/opt/ros/melodic/lib
ENV ROS_ETC_DIR=/opt/ros/melodic/etc/ros
ENV CMAKE_PREFIX_PATH=/opt/ros/melodic
ENV ROS_ROOT=/opt/ros/melodic/share/ros
ENV ROS_VERSION=1
ENV ROS_PYTHON_VERSION=2
ENV PYTHONPATH=/opt/ros/melodic/lib/python2.7/dist-packages
ENV ROS_PACKAGE_PATH=/opt/ros/melodic/share
ENV ROSLISP_PACKAGE_DIRECTORIES=
ENV PATH=/opt/ros/melodic/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV PKG_CONFIG_PATH=/opt/ros/melodic/lib/pkgconfig
ENV ROS_DISTRO=melodic
ENV ROS_MASTER_URI=http://localhost:11311

RUN apt -y update && \
    DEBIAN_FRONTEND=noninteractive apt -y install python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential && \
    rm -rf /var/lib/apt/lists/*

RUN rosdep init && rosdep update

RUN mkdir -p /opt/catkin_ws/src && \
    cd /opt/catkin_ws/src && \
    git clone --branch melodic-devel https://github.com/ros-industrial/universal_robot.git
RUN cd /opt/catkin_ws && rosdep update && \
    apt -y update && \
    DEBIAN_FRONTEND=noninteractive rosdep install --rosdistro melodic --ignore-src --from-paths src --default-yes  && \
    catkin_make && \
    rm -rf /var/lib/apt/lists/*
    

ENV LD_LIBRARY_PATH=/opt/catkin_ws/devel/lib:/opt/ros/melodic/lib
ENV CMAKE_PREFIX_PATH=/opt/catkin_ws/devel:/opt/ros/melodic
ENV PYTHONPATH=/opt/catkin_ws/devel/lib/python2.7/dist-packages:/opt/ros/melodic/lib/python2.7/dist-packages
ENV ROS_PACKAGE_PATH=/opt/catkin_ws/src:/opt/ros/melodic/share
ENV ROSLISP_PACKAGE_DIRECTORIES=/opt/catkin_ws/devel/share/common-lisp
ENV PKG_CONFIG_PATH=/opt/catkin_ws/devel/lib/pkgconfig:/opt/ros/melodic/lib/pkgconfig

RUN apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    libxtst6 \
    libegl1-mesa \
    libgl1-mesa-dev \
    libgl1-mesa-glx \
    libglew-dev \
    libosmesa6-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY ./virtualgl_2.6.90_amd64.deb /tmp
RUN dpkg -i /tmp/virtualgl_2.6.90_amd64.deb && rm -f /tmp/virtualgl_2.6.90_amd64.deb

RUN apt -y update && \
    DEBIAN_FRONTEND=noninteractive apt -y install locales && \
    rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8

RUN apt -y update && \
    DEBIAN_FRONTEND=noninteractive apt -y install xfce4 && \
    rm -rf /var/lib/apt/lists/*

RUN apt -y update && \
    DEBIAN_FRONTEND=noninteractive apt -y install xfce4-terminal firefox vim  && \
    rm -rf /var/lib/apt/lists/*

COPY ./code_1.60.0-1630494279_amd64.deb /tmp
RUN apt -y update && \
    DEBIAN_FRONTEND=noninteractive apt -y install  /tmp/code_1.60.0-1630494279_amd64.deb && \
    rm -rf /var/lib/apt/lists/*  /tmp/code_1.60.0-1630494279_amd64.deb

RUN apt -y update && \
    DEBIAN_FRONTEND=noninteractive apt -y install zenity && \
    rm -rf /var/lib/apt/lists/*
