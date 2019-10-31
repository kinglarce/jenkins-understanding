For create ssh key
`ssh-keygen -f remote-key`

To be able to communicate the "two" services via SSH using the SSH KEY
"**remote-host**" should have the "**remote-key.pub**" and that happens inside the "Dockerfile"
"**jenkins**" should have the origin "**remote-key**" to serve as a key going to "remote-host" because we're already authenticated using that "**remote-key**"
Using this command to exectue `sudo -i remote-key remote_user@remote_user` 
The `-i` means that we need to define the location of the SSH KEY so that it will be use for the connection

So how we move the "**remote-key**" to the "jenkins" container, we just copy using this command
`docker cp remote-key jenkins:/tmp/remote-key`

To connect to the "**remote-host**" container from "**jenkins**"
`ssh -i /tmp/remote-key remote_user@remote_host`

To see the logs of the container
`docker logs -f jenkins`

For automatically starting docker after reboot:
- Create a file
`vi /etc/systemd/system/docker-jenkins.service`
- Then add the service you want to start automatically. The `jenkins` there is the name of the container you want to start automatically.
```
[Unit]
Description=Jenkins container
Requires=docker.service
After=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker start -a jenkins
ExecStop=/usr/bin/docker stop -t 2 jenkins

[Install]
WantedBy=multi-user.target

```
- And finally, enable that service on startup
`sudo systemctl enable docker-jenkins.service`

To backup mysql database
`mysqldump -u root -h db_host -p testdb > /tmp/db.sql`

To connect to AWS. and in this way, any request that we make is gonna use this credentials
This is like a username
`export AWS_ACCESS_KEY_ID=<ACCESS KEY ID>`
This is like a password
`export AWS_SECRET_ACCESS_KEY=<SECRET ACCESS KEY>`

This is the command for copying file to s3 bucket if aws access and secret key are already provided that server or container.
`aws s3 cp /tmp/db.sql s3://jenkins-vm-mysql-backup/db.sql`

For fixing the error 
"upload failed: to s3://jenkins-vm-mysql-backupe/db.sql A client error (RequestTimeTooSkewed) occurred when calling the UploadPart operation: The difference between the request time and the current time is too large",
I had to follow this blog. Notes, this instruction should be done outside of container.
https://medium.com/@vuongtran/how-to-resolve-error-amazon-s3-requesttimetooskewed-5d723dc75735

What is Ansible?

Inventory is a files where we define all the hosts.
```
[all:vars] # which stand for all varible

ansible_connection = ssh # how ansible is connect to all the hosts and it will done through "ssh"

[test] # this is a group, a group is a name that define a bunch of servers that have things in common

# test1 - is an alias for the remote host 
# ansible_host - is the host that it will connect
# ansible_user - is the user it will use for connecting to remote host
# ansible_private_key_file - is the private that being use for connection just like the SSH(line: 14)

test1 ansible_host=remote_host ansible_user=remote_user ansible_private_key_file=/var/jenkins_home/ansible/remote-key
web1 ansible_host=web ansible_user=remote_user ansible_private_key_file=/var/jenkins_home/ansible/remote-key
```

How to check server using ansible
`ansible -i hosts -m ping test1`
`-m` is the model being use and `ping` is the model
`-i` is the hosts or inventory
`test1` is the alias created in the inventory `hosts`

Playbook is a script all of the ansible should do. all the script are written in yaml

```
- hosts: test1 # we're connecting to the "test1" hosts
  tasks: 
    - shell: echo Hello world > /tmp/ansible-file # and we're running this command on that "test1" remote host and it will create the file in there
- hosts: web1 # this means which host are we gonna use.
  tasks:
    - name: Tranfer template to web server
      template:
        src: table.j2
        dest: /var/www/html/index.php
```

In the jenkins > add parameter ANSBILE_MSG > go to ansible > Advance > Add Extra Varible > and the key there is the "MSG" 
here that the playbook is expecting. In the Jenkins paramter, we should pass is as "$ANSIBLE_MSG" in the value
```
- hosts: test1
  tasks:
   - debug:
       msg: "{{ MSG }}"
```

How to run the playbook
`ansible-playbook -i hosts play.yml` 

Running playbook with environment variable. We use the `e` 
`ansible$ ansible-playbook -i hosts people.yml -e "PEOPLE_AGE=25"`

and this will copy the jinja templte `table.j2` to the `web` host in the docker container that is running PHP webserver,
grab the environment variable and apply it in the condition.

we can also create a global environment variables since Jenkins has a built in global environment variables
https://wiki.jenkins.io/display/JENKINS/Building+a+software+project
by going to Manage Jenkins > Configure System > (tick) Environment Variables


For to us to add a crumbs for jenkins, we need to update the "hosts" in our jenkins(that is outside of the jenkins container server) and add the follow
`127.0.0.1  jenkins.vm`

Gitlab local credential
url: `larce.local:8090` / `gitlab.example.com:8090`
user: `root`
pass: `admin1234`

regular user
user: `larce`
pass: `larce1234`

What is a Seed job? 
its a job that create new jobs.


# Notes: On the jenkins > Configure Global Security > CSRF Protection 
We will uncheck the "Enable script security for Job DSL scripts" because we're 
gonna execute a job from our "dsl-job-creator" repository.
Because if it's checked, DSL doesn't allow you to execute a scripts on local file/repo.


### Mounting from local to container in command
`docker run -it -v $PWD/java-app:/app -v /root/.m2:/root/.m2 maven:3-alpine sh`

### Docker for create new image with new tag
`docker tag $IMAGE:$OLD_TAG hanzodarkria/maven-project:$NEW_TAG`

### For setting git hook for jenkins, need to go the the "git-server" to do it
`cd /var/opt/gitlab/git-data/repositories/jenkins`
Create a "custom_hooks" directory inside the desired repository
`mkdir dsl-job-creator.git/custom_hooks`
And add the "post-receive" bash file which will do the hook
`post-receive`