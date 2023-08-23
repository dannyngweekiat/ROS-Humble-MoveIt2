FROM ros:humble-perception

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt install -y python3-vcstool
RUN apt install python3-colcon-common-extensions -y
RUN apt install ros-$ROS_DISTRO-rmw-cyclonedds-cpp -y

# MoveIt2 Setup
RUN colcon mixin update default
RUN mkdir -p /ws_moveit2/src
WORKDIR /ws_moveit2/src
RUN git clone https://github.com/ros-planning/moveit2_tutorials -b humble --depth 1
RUN vcs import < moveit2_tutorials/moveit2_tutorials.repos
RUN apt update && rosdep install -r --from-paths . --ignore-src --rosdistro $ROS_DISTRO -y

WORKDIR /ws_moveit2
SHELL ["/bin/bash", "-c"] 
RUN source /opt/ros/$ROS_DISTRO/setup.bash \
    && colcon build --mixin release

RUN apt install ros-humble-turtlesim -y
RUN apt install ros-humble-rqt* -y

ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp

COPY ./src/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /home

ENTRYPOINT ["/entrypoint.sh"]
