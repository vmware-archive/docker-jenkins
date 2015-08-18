# docker-jenkins

Builds a docker image for running jenkins in container.

# Requirements

A working Docker setup and a valid shell (e.g., bash).

## Getting Started
Build the container and run it. Thereafter, configure jenkins plugins and also perform backups by saving the mapped (/var/lib/jenkins) directory housing the configuration, jobs, etc.

```
./build.sh
docker run -d -v /var/run/docker.sock:/var/run/docker.sock -p 8080:8080 -p 50000:50000 -v /var/lib/jenkins:/var/jenkins_home openedge/jenkins
```
Note that by the above command, the docker client will execute in the container
though operates against the host Docker daemon.

# License and Author

Copyright: Copyright (c) 2015 VMware, Inc. All Rights Reserved

Author: Tom Hite

License: Apache License, Verison 2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

