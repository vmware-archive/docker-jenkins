#!/bin/bash
#
#
# Copyright (c) 2015 VMware, inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Get the group id of docker (needed in the jenkins container.
# The purpose here is that the jenkins user needs to be a member of the docker
# group within the container and that group id must match that of the Docker
# Engine host. Otherwise, the docker socket will, given file permissions, not
# allow access and jobs will fail if attempting to perform docker operations.
gid=$(awk -F : '/^docker/ {print $3}' /etc/group)

# setup the URL to pull the go compiler (don't use package managers to do this
# since they are often quite a ways behind.
gourl="https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz"

# setup the URL to pull the docker binary
dockerurl="https://get.docker.com/builds/Linux/x86_64/docker-latest"

# generate a dockerfile with any replacements in place
cat >Dockerfile <<-EOF
	# Copyright (c) 2015 VMware, inc.
	#
	# Licensed under the Apache License, Version 2.0 (the "License");
	# you may not use this file except in compliance with the License.
	# You may obtain a copy of the License at
	#
	#     http://www.apache.org/licenses/LICENSE-2.0
	#
	# Unless required by applicable law or agreed to in writing, software
	# distributed under the License is distributed on an "AS IS" BASIS,
	# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	# See the License for the specific language governing permissions and
	# limitations under the License.
	#
	FROM jenkins
	MAINTAINER VMware, Inc.
	COPY plugins.txt /usr/share/jenkins/plugins.txt
	RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt
	USER root
	RUN mkdir /opt/gopkg
	ENV GOPATH="/opt/gopkg"
	ENV GOROOT="/opt/go"
	ENV PATH=\$PATH:\$GOPATH/bin:\$GOROOT/bin
	RUN ( \\
	  groupadd -g ${gid} docker && \\
	  gpasswd -a jenkins docker && \\
	  wget -O /usr/local/bin/docker ${dockerurl} && \\
	  chmod +x /usr/local/bin/docker \\
	)
	RUN ( \\
		  wget -O /tmp/go.tar.gz ${gourl} && \\
		  cd /opt && \\
		  tar -xf /tmp/go.tar.gz && \\
		  rm -f go.tar.gz \\
	)
	USER jenkins
EOF

# build the container itself
docker build -t openedge/jenkins .
