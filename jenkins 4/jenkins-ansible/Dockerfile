# Here we're telling docker to use "jenkins/jenkins" as the base image 
FROM jenkins/jenkins 

# we're telling docker to change and use the user "root" to be executing 
# all of the command that is passing below
USER root
# here's the command that user execute
RUN curl -O https://bootstrap.pypa.io/get-pip.py  && \
    python get-pip.py && \
    pip install ansible --upgrade
# and then switch back to "jenkins" user
USER jenkins