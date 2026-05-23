#!/bin/bash

COMPOSE_FILE=""
IMAGE_NAME="harbor.edgesync.cloud/nycu-cosmos-lab/onnxruntime-on-qualcomm-hexagon:v1"
MODEL=$(tr -d '\0' < /proc/device-tree/model)
OS=$(tr -d '\0' < /etc/os-release)
SOC=$(tr -d '\0' < /sys/firmware/devicetree/base/compatible)

# Detect SoC
if echo "$SOC" | grep -qi "qcs6490"; then
    PLATFORM="qcs6490"
elif echo "$SOC" | grep -qi "qcs9075"; then
    PLATFORM="qcs9075"
else
    echo "Unsupported SoC"
    exit 1
fi

# Detect OS
if echo "$OS" | grep -qi "QCOM Robotics Reference Distro with ROS"; then
    DISTRO="yocto"
elif echo "$OS" | grep -qi "ubuntu"; then
    DISTRO="ubuntu"
else
    echo "Unsupported OS"
    exit 1
fi

# Compose file selection
case "${PLATFORM}_${DISTRO}" in
    qcs6490_yocto)
        COMPOSE_FILE="docker-compose-qcs6490-yocto.yml"
        ;;

    qcs6490_ubuntu)
        COMPOSE_FILE="docker-compose-qcs6490-ubuntu.yml"
        ;;

    qcs9075_ubuntu)
        COMPOSE_FILE="docker-compose-qcs9075-ubuntu.yml"
        ;;

    *)
        echo "Unsupported platform/OS combination"
        exit 1
        ;;
esac

export SERVICE_NAME=onnxruntime-on-qualcomm-hexagon

echo "Platform: $PLATFORM"
echo "OS: $DISTRO"
echo "Compose file: $COMPOSE_FILE"


# Detect docker compose command
if command -v docker-compose >/dev/null 2>&1; then
    DOCKER_COMPOSE="docker-compose"
elif docker compose version >/dev/null 2>&1; then
    DOCKER_COMPOSE="docker compose"
else
    echo "Neither docker-compose nor docker compose is available"
    exit 1
fi

echo "Using compose file: $COMPOSE_FILE"
# 1. Start the container in the background
$DOCKER_COMPOSE -f "$COMPOSE_FILE" pull
$DOCKER_COMPOSE -f "$COMPOSE_FILE" up -d

echo "Connecting to container..."

# 2. Enter the container
# When you type 'exit' or press Ctrl+D, the script continues to the next line
docker exec -it $SERVICE_NAME bash

# 3. Cleanup after exiting the bash session
echo "Exited container. Cleaning up..."
$DOCKER_COMPOSE -f "$COMPOSE_FILE" down