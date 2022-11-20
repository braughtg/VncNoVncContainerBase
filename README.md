# VncNoVncContainerBase
A base Dockerfile for building multi-architecture Debian images containing VNC and noVNC servers and an XFCE4 desktop environment.

Images such as these are ideal for building platforms for course assignments.  For example:
* An environment for teaching the linux/Unix command line.
* Providing a web server, database and API handler (e.g. express) for a web development course.
* Providing particular compilers, assemblers, etc... for a course that requires specialized tools.
* Etc.

## Requirements

* [Docker Desktop](https://docs.docker.com/desktop/install/windows-install/)
  * Or [Docker Engine on Linux](https://docs.docker.com/engine/install/)
* A VNC client (recommended)
  * E.g. [Tiger VNC](https://sourceforge.net/projects/tigervnc/files/stable/)

## Using this template repo
To use this repository to create base images for specific class of purposes (e.g. a sequence of course projects) do the following:
* Click the "Use this template" button
* Choose "Create a new repository"
* Create the new repository in your GitHub space.
* Edit the `Dockerfile` and other configuration scripts/files as appropriate (e.g. install additional software packages).
* Log into a dockerhub account where you want to store the image.
* Edit the `build.bash` script to specify the:
  * Dockerhub username
  * The image name and tag you want to use.
* Run the `build.bash` script.
* Then use the generated image as the `FROM` for new images that specialize it.

## Using to the container
In the commands below the following templates are used:
* The following are configured at the top of `build.bash`:
  * `<dockerhub user>` - The username of on dockerhub where the image was pushed.
  * `<image>` - Name of the image to be used.
  * `<tag>` - The tag of the image being used.
* The following are configured at the top of the `Dockerfile`:
  * `<username>` - The username of the non-root user in the container. 
* `<container name>` - the name you would like to use for the container created from the image.
* `<volume name>` - the name of a Docker volume that will be used to store the user's home directory contents.

### Getting the image:
The image can be pulled from Dockerhub with the following command:
```
docker pull <dockerhub user>/<image>:<tag>
```

### Creating the container:
The container can be created with the following command:

```
docker create --name <container name> --publish 5901:5901 --publish 6901:6901 <dockerhub user>/<image>:<tag>
```

#### Preserving the users home directory:
The container created by the above command works well for most basic use cases. It persists changes to the container (e.g. user installed software, changes within the user home directory) in the writeable layer of the container.  Thus, all changes are preserved across container stops and starts, so long as the container is not deleted.  If the container is deleted all changes will be lost. It is possible to preserve the changes within the user's home directory across contaner deletion using a Docker volume.  To do so add the following `mount` to the `docker create` command above:

```
--mount source=<volume name>,target=/home/<username>
```

#### Using Docker within the container:
By default Docker is not installed within the container.  If you plan to use Docker Desktop or the docker engine within a container you will need to:

* Add commands to the `Dockerfile` to install docker.
* Add the following `mount` to the `docker create` command above:
  * For Linux or MacOS:
    ```
    --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock
    ```
  * For Windows:
    ```
    --mount type=bind,source=//var/run/docker.sock,target=/var/run/docker.sock
    ```

### Starting the container:
The container can be run using the following command:
```
docker start <container name>
```

The container may also be started from the Docker Desktop application.

### Connecting to the container:
The user can connect to the container and interact with the Debian system through the XFCE4 desktop either by using an VNC client or via a browser using noVNC.  The experince is better when using a VNC client. When using noVNC copy and paste between the host machine and the Debian system in the container is inconvenient. 

#### With a VNC client
To connect to the container using a VNC Client, start your VNC Client and connect to:
```
localhost:5901
```
  
The XFCE4 desktop should appear in the VNC Client window.

#### Via a browser with noVNC
To connect to the container using a browser and noVNC, open the browser and connect to: 
```
https://localhost:6901
```

The XFCE4 desktop should appear in the browser window.  

Some tips for using the container via noVNC:
* The noVNC menu (the little tab on the left side of the desktop) provides some helpful functionality.
* To copy/paste between the host machine and the container you must use the clipboard accesed via the noVNC menu. This is a little inconvenient, but it is functional.
* To enable the XFCE4 desktop to scale with the browser window, use the settings (the the gear) on the noVNC menu to set the “Scaling Mode” to “Remote Resizing.”

#### Credentials
When connected to the container via VNC or noVNC the default (non-root) user is automatically logged in.  No credentials will need to be provided to connect to the client. However, the user also has `sudo` privlidges within the container and the password will be required to run commands with `sudo`.

The credentials for this (non-root) user are set by `ARGs` within the `Dockerfile`.  By default this user has the following credentials:
* Username: `student`
* Password: `student`

### Stopping the container:
```
docker stop <container name>
```

The container may also be stopped from the Docker Desktop application.