pipeline {
    agent {
        docker {
            image 'hashicorp/terraform:1.0.9'
            args '-v ~/.ssh:/root/.ssh'
        }
    }
    environment {
        DIGITALOCEAN_TOKEN = credentials('dop_v1_33f3baa138b8019c5d87dea4f0777d2a0e965f1295530e5de3f67bbd6e422a4b')
        SSH_public_key    = credentials('ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC+vJxXjlrLgk7pRClWcd3p+QiHwACOmRhpCJFpNFp3MDP1PVMKCXcutjhIci3wERCRmYVG/zB/lC1TySJtYwvIrFxRkYDixoi6sB/vWPz0QvzFA0yyZx/0Yu6I2Xi/A/ybaRyto4Daq4hpN+y/8ahqcPM20l//HaE2vNBTgUO80QxAPaPQKDvjhnV2yb4UZFOz3BaFsjj9SJ+RXMjNPSMvNI2n6IEhcEc3CYSnWyj2uz2BlYlqxa203eTrHu0XQmLFoju0wN+kAm/WO7UpOchHPsoGxsypq93WBYjsDMegmhHX7uNANHMucnbPpePzM5G0OnSSjFQzKxma42HDptY8pZdyeO/B35c2ta8J3PXV9GyxOZxc2fiZvcakj3aAUbm9aAC3BXRuFHWKClkFVxirzRzvSzSBBMHzOjx84S/oBMohQfoC4GjCrvd1xKH6F68ZNGstf1kliyUiJw/fLXuL6G1M4WBjcmT5qbzBG42CFThLDMdGBl4uIbwXIra4FBU= josue@LAPTOP-L1NK23PC')
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
                sshagent(['SSH_public_key']) {
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
