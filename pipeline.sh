pipeline {
    agent any

    stages {
        stage('Code') {
            steps {
                git "https://github.com/Musthafa53/one.git"
            }
        }
        stage ('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage ('Deploy') {
            steps {
                sshagent(['new']) {
                   sh 'scp -o StrictHostKeyChecking=no /var/lib/jenkins/workspace/FirstJob/target/*.war root@3.7.45.143:/root/apache-tomcat-9.0.82/webapps/'
               }
            }
        }
    }
}
