pipeline{
	agent any

	environment {
		DOCKERHUB_CREDENTIALS=credentials('dockerHub')
		DockerHub_UserName = 'averlott'
		DockerHub_RepoName = 'spm-openjdk-bootcamp-m14'
		Application_Port = '8001'
	}

	stages {

		stage('contruir imagen docker a partir de dockerfile') {
			steps {
				echo 'inicia contruir imagen docker a partir de dockerfile'
				sh 'docker build -t ${env.DockerHub_UserName}/${env.DockerHub_RepoName}:${env.BUILD_NUMBER} .'
			}
		}

		stage('ejecutar contenedor con la imagen docker creada anteriormente') {
			steps {
				echo 'inicia ejecutar contenedor con la imagen docker creada anteriormente'
				sh 'docker run --d --rm -p ${env.Application_Port}:${env.Application_Port} ${env.DockerHub_UserName}/${env.DockerHub_RepoName}:${env.BUILD_NUMBER}'
			}
		}

		stage('test del contenedor ejecutado anteriormente haciendo un request al localhost') {
			steps {
				echo 'inicia test del contenedor ejecutado anteriormente haciendo un request al localhost'
				sh 'curl localhost:8001'
			}
		}

		stage('login en el repositorio dockerhub') {
			steps {
				echo 'inicia login en DockerHub'
				sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
			}
		}

		stage('push en el repositorio dockerhub de la imagen creada en el primer stage') {
			steps {
				echo 'inicia push en el repositorio dockerhub de la imagen creada en el primer stage'
				sh 'docker push ${env.DockerHub_UserName}/${env.DockerHub_RepoName}:${env.BUILD_NUMBER}'
			}
		}

        	stage('eliminar contenedores e imagenes no usadas') {
            		steps {
				echo 'inicia eliminar contenedores e imagenes no usadas'
                		sh 'docker ps -aq | xargs --no-run-if-empty docker rm'
                		// unicamente elimina la imagen final
                		sh 'docker images -q | xargs --no-run-if-empty docker rmi'
            		}
		}

	post {
		always {
			echo 'inicia logout en el repositorio dockerhub'
			sh 'docker logout'
		}
	}
}
