xhost +local:root

docker build --target ros-kinova -t ros-kinova .    
 
docker run -it \
	--env="DISPLAY" --device=/dev/video0:/dev/video0 \
	-e DISPLAY=$DISPLAY --env="QT_X11_NO_MITSHM=1" \
	--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
	--privileged \
	-e "ROS_DOMAIN_ID=7" \
	--net=host -v /dev/shm:/dev/shm \
	-u 0 \
	ros-kinova

export containerId=$(docker ps -l -q)


