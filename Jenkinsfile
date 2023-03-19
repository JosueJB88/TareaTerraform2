pipeline {
    agent {
        docker {
            image 'hashicorp/terraform:1.0.9'
            args '-v ~/.ssh:/root/.ssh'
        }
    }
    environment {
        DIGITALOCEAN_TOKEN = credentials('digitalocean-token')
        SSH_PRIVATE_KEY    = credentials('ssh-private-key')
    }
    stages {
        stage('Terraform Apply') {
            steps {
                sh '''
                    terraform init
                    terraform plan
                    terraform apply -auto-approve
                '''
            }
        }
        stage('SSH Commands') {
            agent {
                label 'remote-ssh'
            }
            steps {
                sshagent(['SSH_PRIVATE_KEY']) {
                    sh '''
                        sudo apt-get update
                        sudo apt-get install -y git
                        sudo snap install docker
                        git clone https://github.com/JosueJB88/PostgreSQL.git
                        cd PostgreSQL
                        sudo docker-compose up
                    '''
                }
            }
        }
    }
    post {
        always {
            sh 'terraform destroy -auto-approve'
        }
    }
}
