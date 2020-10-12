#!groovy

// imports
import jenkins.model.Jenkins
import jenkins.model.JenkinsLocationConfiguration

// parameters
def jenkinsParameters = [
  email:  'Oleksandr Briukhanov <Oleksandr_Briukhanov@epam.com>',
  url:    ${jenkins_dns}
]

// get Jenkins location configuration
def jenkinsLocationConfiguration = JenkinsLocationConfiguration.get()

// set Jenkins URL
jenkinsLocationConfiguration.setUrl(jenkinsParameters.url)

// set Jenkins admin email address
jenkinsLocationConfiguration.setAdminAddress(jenkinsParameters.email)

// save current Jenkins state to disk
jenkinsLocationConfiguration.save()
