# What we're gonna od here is to trigger a Job in Jenkins by a script using a "crumb" that is the CSRF of jenkins
# This line here:
# curl -u jenkins_user:jenkins_user" -s 'http://jenkins.vm:8080/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)
# the "curl" is the one is the one that is gonna connect us
# ' -u "jenkins_user:jenkins_user" ' is the once that is gonna authentication us
# "-s 'http://jenkins.vm:8080/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)" is the one who is gonna silently 
# give us the crumb using the constant url.

# And the whole like is the one that will give the crumb is the gonna be use later on
# and it will stored in the variable "crumb" as a result of crumb=$(curl.....)
# the result of the command when we "echo $crumb" is gonna be like this
# Jenkins-Crumb:09ef997d7b35d2c2107f05bfa2f5b173
crumb=$(curl -u "jenkins_user:jenkins_user" -s 'http://jenkins.vm:8080/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)')

# The line below is the one that is gonna trigger a Job from the script without "parameters" using the "$crumb" we just got from previous line
# the '-H "$crumb"' means we're gonna use the "$crumb" as the header in the POST request going to jenkins for trigger the job
# "-X POST" this is a POST request
# "http://jenkins.vm:8080/job/ENV/build?delay=0sec" and this is the URL of the "Build Now" for a specific a job
# you can grab this by doing a "Copy Link Address" in the "Build Now" button in jenkins
curl -u "jenkins_user:jenkins_user" -H "$crumb" -X POST http://jenkins.vm:8080/job/ENV/build?delay=0sec

# The line below work same as above but for triggering a job with a parameter. 
# This will trigger the backing up of db to AWS using script
# NOTE: "buildWithParameters" must be specify instead of "build"
curl -u "jenkins_user:jenkins_user" -H "$crumb" -X POST http://jenkins.vm:8080/job/Back%20up%20to%20AWS/buildWithParameters?MYSQL_HOST=db_host&DATABASE_NAME=testdb&AWS_BUCKET_NAME=jenkins-vm-mysql-backup