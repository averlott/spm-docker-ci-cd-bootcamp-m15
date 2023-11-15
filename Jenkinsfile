pipeline{
	agent any

	environment {
		DOCKERHUB_CREDENTIALS=credentials('dockerHub')
		DockerHub_UserName = 'averlott'
		DockerHub_RepoName = 'spm-openjdk-bootcamp-m14'
		Application_Original_Port = '3456'
		Application_Expose_Port = '8001'
	}

	stages {

		stage('detener y eliminar contenedor') {
			steps {
				echo 'inicia detener y eliminar contenedor'
				sh "docker stop ${env.DockerHub_RepoName} || true && docker rm -f ${env.DockerHub_RepoName} || true"
			}
		}

		stage('eliminar imagenes') {
			steps {
				echo 'inicia eliminar imagenes'
				sh "docker rmi --force \$(docker images -q '${env.DockerHub_UserName}/${env.DockerHub_RepoName}' | uniq) || true"
			}
		}
		
		stage('contruir imagen docker a partir de dockerfile') {
			steps {
				echo 'inicia contruir imagen docker a partir de dockerfile'
				sh "docker build -t ${env.DockerHub_UserName}/${env.DockerHub_RepoName}:$BUILD_NUMBER ."
			}
		}

		stage('ejecutar contenedor con la imagen docker creada anteriormente') {
			steps {
				echo 'inicia ejecutar contenedor con la imagen docker creada anteriormente'
				sh "docker run -d --name ${env.DockerHub_RepoName} -p ${env.Application_Expose_Port}:${env.Application_Original_Port} ${env.DockerHub_UserName}/${env.DockerHub_RepoName}:$BUILD_NUMBER"
			}
		}

		stage('login en el repositorio dockerhub') {
			steps {
				echo 'inicia login en DockerHub'
				sh "echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin"
			}
		}

		stage('push en el repositorio dockerhub de la imagen creada en el primer stage') {
			steps {
				echo 'inicia push en el repositorio dockerhub de la imagen creada en el primer stage'
				//sh "docker push ${env.DockerHub_UserName}/${env.DockerHub_RepoName}:$BUILD_NUMBER"
			}
		}
		
	}
	
	post {
		always {
			echo 'inicia logout en el repositorio dockerhub'
			sh 'docker logout'
		}
	}
}
