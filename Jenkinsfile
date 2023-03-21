pipeline {
    agent any
    
    tools{
        terraform 'terraform-11'
    }

    stages {
	    
        stage('Clone repository') {
            steps {
                git branch: 'main', url: 'https://github.com/JosueJB88/TareaTerraform.git'
		 
            }
        }
            

	    stage('Terraform init') {
            steps {
              bat 'terraform init'
            }
        }
        
        stage('Terraform apply') {
            steps {
            bat 'terraform apply -auto-approve'
            }
        }
        
    }
}
