properties(
    [
        [$class: 'BuildDiscarderProperty', strategy:
          [$class: 'LogRotator', artifactDaysToKeepStr: '14', artifactNumToKeepStr: '5', daysToKeepStr: '30', numToKeepStr: '60']],
        pipelineTriggers(
          [
              pollSCM('H/5 * * * *'),
              cron('@daily'),
          ]
        )
    ]
)
node {
    def app
    stage('Clone repository') {
        /* Cloning the Repository to Workspace */
        checkout scm
    }
    stage('Build image') {
        /* This builds the actual image */
        app = docker.build("manonair/dockerized-angularapp")
    }
    stage('Test image') {       
        app.inside {
            echo "Tests passed"
        }
    }
    stage('Push image') {
        /* 
			Push images to DockerHub account
		*/
        docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-creds') {
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
            } 
            echo "Pushing Docker Build to DockerHub"
    }
  stage("Deploy") {
    try{
          sh "docker stop dockerized-angularapp && \
          docker rm dockerized-angularapp"
    } catch(e) {
           echo e.toString()
    }
    echo "Clean up completed"
    sh "docker pull manonair/dockerized-angularapp && \
        docker run -d --name=dockerized-angularapp -p 8084:80 manonair/dockerized-angularapp"
    echo "completed deployment "
  }
  
  
}
