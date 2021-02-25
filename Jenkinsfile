pipeline {
    options {
        // set a timeout of 60 minutes for this pipeline
        timeout(time: 60, unit: 'MINUTES')
    }
    agent {
      node {
        label 'master'
      }
    }

    environment {
        DEV_PROJECT = "fre-squid2"
        APP_GIT_URL = "https://github.com/jfreygner/squid#main"

        // DO NOT CHANGE THE GLOBAL VARS BELOW THIS LINE
        APP_NAME = "squid2"
    }


    stages {

        stage('Launch new app in DEV env') {
            steps {
                echo '### Cleaning existing resources in DEV env ###'
                sh '''
                        oc project ${DEV_PROJECT}
                        oc delete all -l app=${APP_NAME}
                        sleep 5
                   '''

                echo '### Creating a new app in DEV env ###'
                sh '''
                        oc project ${DEV_PROJECT}
                        oc new-app  --name=${APP_NAME} --strategy=docker ${APP_GIT_URL}
                   '''
            }
        }
    }
}
