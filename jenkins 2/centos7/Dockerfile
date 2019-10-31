# grab the "centos" operating sysmte
FROM centos 

# instal the openssh-server library
RUN yum -y install openssh-server

# 1 - add remote_user
# 2 - set the pass using the inputted "1234" 
# which is receive wit the help of "--stdin" which receives the input
# 3 - create ".ssh" directory
# 4 - change the "mode" of that directory to be "700"
RUN useradd remote_user && \
    echo "1234" | passwd remote_user  --stdin && \
    mkdir /home/remote_user/.ssh && \
    chmod 700 /home/remote_user/.ssh

# this copy the "remote-key.pub" to the image
COPY remote-key.pub /home/remote_user/.ssh/authorized_keys

# 1 - change the "/home/remote_user" directroy to be the "remote_user" account
# and apply it recurssively using "-R"
# then change the mode of "/home/remote_user/.ssh/authorized_keys" to be 600
RUN chown remote_user:remote_user   -R /home/remote_user && \
    chmod 600 /home/remote_user/.ssh/authorized_keys

# ssh need some global keys, thats why its needed
RUN /usr/sbin/sshd-keygen > /dev/null 2>&1

RUN yum -y install mysql

RUN yum -y install epel-release && \
    yum -y install python-pip && \
    pip install --upgrade pip && \
    pip install awscli

# the last thing needed it to make this alive is to have "CMD"
# this means which command does the container needs to run
# or in our case, which command to start the "ssh" service
CMD /usr/sbin/sshd -D
