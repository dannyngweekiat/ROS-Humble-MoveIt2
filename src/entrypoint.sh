#!/bin/bash
set -e

# setup ros2 environment
source "/ws_moveit2/install/setup.bash"
source "/opt/ros/$ROS_DISTRO/setup.bash" --
exec "$@"
