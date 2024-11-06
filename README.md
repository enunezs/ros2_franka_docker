# ros2_franka_docker

A simple Docker container for using the Franka Panda Emika arm with ROS2. Environment has been prepared accoridng to the installation setup described in [https://support.franka.de/docs/franka_ros2.html](https://support.franka.de/docs/franka_ros2.html)

Simply run:

```
./dockerscript.sh
```

To launch rviz and attempt connection to the franka arm. 


Due to issues given recent changes to the `ros_franka` library for foxy, we recommend running the included `franka_ros_foxy.sh`, which will first pull a ROS2 image for Foxy, then initiate connection with the arm. 
In case connection to the default IP address fails, please try:

```bash
sudo apt update &&  sudo apt install ros-foxy-rmw-fastrtps-cpp ros-foxy-rmw-fastrtps-shared-cpp
ros2 launch franka_moveit_config moveit.launch.py robot_ip:=172.16.0.2

```


Afterwards, Attach to the running container in VSCode using the Dev Containers extension

Also available in the docker store [https://hub.docker.com/repository/docker/enunezs/ros2_franka](https://hub.docker.com/repository/docker/enunezs/ros2_franka)


For debugging purposes,  2 scripts have been included to start an instance of `rviz2_script.sh` and `rqt_script.sh`



## Quick actions to try

```bash
ros2 launch franka_bringup move_to_start_example_controller.launch.py robot_ip:=172.16.0.2
```

### Set to open
```bash
ros2 action send_goal /panda_gripper/gripper_action control_msgs/action/GripperCommand "{command: {position: 0.027, max_effort: 0.1}}"
```
### Set to closed
```bash
ros2 action send_goal /panda_gripper/gripper_action control_msgs/action/GripperCommand "{command: {position: 0.012, max_effort: 0.1}}"
```
### Get info 
```bash
ros2 action info /panda_gripper/gripper_action
```
