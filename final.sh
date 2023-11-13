node {
    stage ("Code") {
        git "https://github.com/Musthafa53/one.git"
    }
    stage ("Build") {
        def mavenHome = tool name: "maven", type: "maven"
        def mavenCMD = "$mavenHome/bin/mvn"
        sh "$mavenCMD clean package"
    }
    stage ("Test") {
        withSonarQubeEnv("mysonar") {
           def mavenHome = tool name: "maven", type: "maven"
           def mavenCMD = "$mavenHome/bin/mvn"
           sh "$mavenCMD sonar:sonar" 
        }
    }
    stage ("Artifact") {
        nexusArtifactUploader artifacts: [[artifactId: 'myweb', classifier: '', file: 'target/myweb-8.5.2.war', type: 'war']], credentialsId: 'nexus', groupId: 'in.javahome', nexusUrl: '13.127.103.17:8081', nexusVersion: 'nexus3', protocol: 'http', repository: 'my-repo', version: '8.5.2'
    }
    stage ("Deloy") {
        sshagent(['697f0bbf-96eb-488a-a98f-162fc6f2ea93']) {
          sh 'scp -o StrictHostKeyChecking=no target/myweb-8.5.2.war ec2-user@13.127.232.83:/home/ec2-user/apache-tomcat-9.0.82/webapps/'
        }
    }
}
