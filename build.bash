# Build and push the multi-architectrue images.

# Modify the following variables as appropraite when building new base inmages.
DOCKER_HUB_USER="braughtg"
IMAGE="vnc-novnc-base"
TAG="1.0.1"
PLATFORMS=linux/amd64,linux/arm64

# Check that the DockerHub user identified above is logged in.
LOGGED_IN=$(docker-credential-desktop list | grep "$DOCKER_HUB_USER" | wc -l | cut -f 8 -d ' ')
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
docker buildx use $BUILDER_NAME

# Print some info on the images
FULL_IMAGE_NAME=$DOCKER_HUB_USER/$IMAGE:$TAG
echo
echo "Buiding image: $IMAGE"
echo "     With tag: $TAG"
echo "For platforms: $PLATFORMS."
echo "Using builder: $BUILDER_NAME."
echo "   Pushing to: $DOCKER_HUB_USER"
echo "    Full name: $FULL_IMAGE_NAME"
echo

# Build and push the images.
docker buildx build --platform $PLATFORMS -t $FULL_IMAGE_NAME --push .