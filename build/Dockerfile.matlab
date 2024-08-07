#######################################################################
# USAGE
#
# To build and run:
#   - docker build -f Dockerfile.matlab -t xfce-matlab .
#   - docker run --rm -e USER=root -p 5901:5901 xfce
#
# Steps to connect via VNC on a Mac:
#   - Open Finder > Go > Connect to server...
#   - Enter "vnc://root@localhost:5901" 
#   - Enter "password" when prompted for the password
#
#######################################################################
FROM ubuntu:20.04

# prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

# install dependencies
RUN apt-get install -y \
    xfce4 \
    xfce4-goodies \
    xfce4-terminal \
    tightvncserver \
    dbus-x11 \
    curl \
    wget \
    unzip \
    git \
    vim \
    nano \
    net-tools \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# xfce4 fixes
RUN update-alternatives --config x-terminal-emulator

# Setup VNC server
RUN mkdir /root/.vnc \
    && echo "password" | vncpasswd -f > /root/.vnc/passwd \
    && chmod 600 /root/.vnc/passwd \
    && echo "#!/bin/bash\nstartxfce4 &" > /root/.vnc/xstartup \
    && chmod +x /root/.vnc/xstartup \
    && touch /root/.Xauthority

EXPOSE 5901

WORKDIR /app

# Copy a script to start the VNC server
COPY start-vnc.sh start-vnc.sh
RUN chmod +x start-vnc.sh

RUN mkdir /opt/MATLAB
COPY matlab_R2024a_Linux.zip /tmp
RUN unzip /tmp/matlab_R2024a_Linux.zip -d /opt/MATLAB

COPY installer_input.txt /opt/MATLAB
COPY network.lic /opt/MATLAB
#RUN /opt/MATLAB/install -inputFile /opt/MATLAB/installer_input.txt

ENTRYPOINT ["/app/start-vnc.sh"]
