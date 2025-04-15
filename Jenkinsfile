pipeline {
    agent any
    environment{
         DOCKER_IMAGE="gopikondaji/newfrontend:$BUILD_NUMBER"
    }
    stages {
        stage('Checkout'){
            steps{
                checkout([$class: 'GitSCM', branches: [[name: '**/tags/**']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'git-deploy', refspec: '+refs/tags/*:refs/remotes/origin/tags/*', url: 'https://github.com/gopi-affinsys/frontend-je/']]])
            }
        }
        stage('Install dependencies') {
            steps {
                    sh 'cd frontend && npm i'
            }
        }
        stage("Build Docker image"){

            steps{
                script {
                    sh 'cd frontend && docker build -t ${DOCKER_IMAGE} .'
                }
            }
        }
        stage("Scan Docker image"){
            environment{
                SEVERITY="LOW,MEDIUM,HIGH,CRITICAL,UNKNOWN"
            }
            steps{
                sh """
                    trivy image --severity ${SEVERITY} \
                                --format json \
                                --output report.txt \
                                --ignore-unfixed $DOCKER_IMAGE 
                """
                sh """
                    cat report.txt && \
                    chmod +x values.sh && \
                    ./values.sh
                """
            }            
        }   
        stage("Verify Scan results") {
    steps {
        script {
            def output = sh(
                script: '''
                    . ./values.sh
                    echo "LOW=$low"
                    echo "MEDIUM=$medium"
                    echo "HIGH=$high"
                    echo "CRITICAL=$critical"
                    echo "UNKNOWN=$unknown"
                ''',
                returnStdout: true
            ).trim()

            def sevMap = [:]
            output.split("\n").each { line ->
                def (key, value) = line.tokenize('=')
                sevMap[key] = value
            }

            // Print parsed severity counts
            echo "Scan Summary:"
            echo "Low: ${sevMap['LOW']}"
            echo "Medium: ${sevMap['MEDIUM']}"
            echo "High: ${sevMap['HIGH']}"
            echo "Critical: ${sevMap['CRITICAL']}"
            echo "Unknown: ${sevMap['UNKNOWN']}"

            if ((sevMap['HIGH'] as Integer) > 100 || (sevMap['CRITICAL'] as Integer) > 50) {
                error("Build failed due to HIGH or CRITICAL vulnerabilities")
            }
        }
    }
    }

        stage("Push Docker image"){
            // environment{
            //     CRED=credentials('docker-cred')
            // }
            steps{
                script{
                def dockerImage = docker.image("${DOCKER_IMAGE}")
                docker.withRegistry('https://index.docker.io/v1/', "docker-cred") 
                {
                    dockerImage.push()
                }
                }
            }
        }
        stage("Update deploy repo"){
            environment{
                IMAGE_NAME="gopikondaji/newfrontend"
                GIT_REPO="deploy"
                GIT_USER_NAME="gopi-affinsys"
                NEW_TAG="$BUILD_NUMBER"
            }
            steps {
                sh 'rm -rf * && rm -rf .git'
                git branch: 'main', credentialsId: 'classic', url: 'https://github.com/gopi-affinsys/deploy'
                withCredentials([string(credentialsId: 'test', variable: 'GITHUB_TOKEN')]) {
                    sh '''
                        git config user.email "gopi.krishna@affinsys.com"
                        git config user.name "gopi-affinsys"
                        sed -i "s|${IMAGE_NAME}:.*|${IMAGE_NAME}:${NEW_TAG}|g" docker-compose.yaml
                        cat docker-compose.yaml
                        git add .
                        git commit -m "Update image version TO ${BUILD_NUMBER}"
                        git push https://${GITHUB_TOKEN}@github.com/${GIT_USER_NAME}/${GIT_REPO} HEAD:main
                '''
            }
        }
    }
}
}
