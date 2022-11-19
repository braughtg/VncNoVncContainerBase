# Build and push the multi-architectrue images.

DOCKER_HUB_USER="braughtg"
IMAGE="vnc-novnc-base"
TAG="1.0.0"

LOGGED_IN=$(cat ~/.docker/config.json 2> /dev/null | grep "index.docker.io" | wc -l | cut -f 8 -d ' ')
if [ "$LOGGED_IN" == "0" ];
then
  echo "Please log into Docker Hub as $DOCKER_HUB_USER before building images."
  echo "  Use: docker login"
  echo "This allows multi architecture images to be pushed."
  exit -1
fi

# Create a builder for this image if it doesn't exist.
BUILDER_NAME=vncbuilder
GIT_KIT_BUILDER=$(docker buildx ls | grep "$BUILDER_NAME" | wc -l | cut -f 8 -d ' ')
if [ "$GIT_KIT_BUILDER" == "0" ];
then
  echo "Making new builder for $BUILDER_NAME images."
  docker buildx create --name $BUILDER_NAME
fi

# Switch to use the builder for this image.
echo "Using the $BUILDER_NAME."
docker buildx use $BUILDER_NAME

# Build and push the images.
FULL_IMAGE=$DOCKER_HUB_USER/$IMAGE:$TAG
PLATFORMS=linux/amd64,linux/arm64

docker buildx build --platform $PLATFORMS -t $FULL_IMAGE --push .