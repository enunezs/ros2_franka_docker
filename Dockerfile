FROM ros:foxy-ros-base
#FROM ros:foxy-ros-desktop	
LABEL maintainer="Emanuel Nunez S gmail dot com"
ENV HOME /root
WORKDIR $HOME
SHELL ["/bin/bash", "-c"]

# As per instructions on
# https://support.franka.de/docs/franka_ros2.html

# basic utilities
RUN apt-get update && apt-get install -y \
    	apt-utils \
    	dialog

# general utilities
RUN apt-get update && apt-get install -y \
    	wget \
    	curl \
    	git \
    	gdb \
    	vim \
    	nano \
    	unzip \
    	iputils-ping

# install ros2 packages
RUN apt-get update && apt-get install -y \ 
	ros-foxy-control-msgs \
	ros-foxy-xacro \
	ros-foxy-angles \
	ros-foxy-ros2-control \
	ros-foxy-realtime-tools \
	ros-foxy-control-toolbox \
	ros-foxy-moveit \
	ros-foxy-ros2-controllers \
	ros-foxy-joint-state-publisher \
	ros-foxy-joint-state-publisher-gui \
	ros-foxy-ament-cmake-clang-format \
	python3-colcon-common-extensions

RUN apt-get install iputils-ping

# SET ENVIRONMENT
WORKDIR /home/ema/workspaces/franka_emika_panda/
 
#### Step 0: Prerequisites: building and setting up libfranka
# Done
# Known bug, no real time system

RUN apt-get update && apt-get install -y \ 
	libpoco-dev \
	libeigen3-dev &&\
	git clone https://github.com/frankaemika/libfranka.git --recursive &&\
	cd libfranka &&\
	mkdir build && cd build &&\
	cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTS=OFF  .. &&\
	cmake --build . -j$(nproc) &&\
	cpack -G DEB &&\
	sudo dpkg -i libfranka-*.deb


RUN echo 'echo "Updating bash.rc" &&\
	 export RCUTILS_COLORIZED_OUTPUT=1 &&\
	 export LC_NUMERIC=en_US.UTF-8' >> $HOME/.bashrc

#### Step 1: Setup: building franka_ros2

WORKDIR /home/ema/workspaces/
RUN mkdir -p franka_ros2_ws/src   && \ 
	cd /home/ema/workspaces/franka_ros2_ws && \
	git clone https://github.com/frankaemika/franka_ros2.git src/franka_ros2 && \
	source /opt/ros/foxy/setup.bash && \
	colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release && \
	source install/setup.sh

WORKDIR /home/ema/workspaces/franka_ros2_ws/src/franka_ros2

# Source ROS2
#RUN /bin/bash -c "source /opt/ros/foxy/setup.bash && source /home/ema/workspaces/franka_ros2_ws/install/setup.bash"

RUN echo 'colcon build &&\ 
	source /opt/ros/foxy/setup.sh &&\
	source /home/ema/workspaces/franka_ros2_ws/install/local_setup.sh' >> $HOME/.bashrc


#CMD ["ros2", "launch", "franka_moveit_config", "moveit.launch.py", "robot_ip:=172.16.10.1"]

# source /opt/ros/foxy/setup.bash && source /home/ema/workspaces/franka_ros2_ws/install/setup.bash
# ros2 launch franka_moveit_config moveit.launch.py robot_ip:=172.16.10.1


