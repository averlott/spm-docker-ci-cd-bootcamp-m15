pipeline{
	agent any

	environment {
		DOCKERHUB_CREDENTIALS=credentials('dockerHub')
		DockerHub_UserName = 'averlott'
		DockerHub_RepoName = 'spm-openjdk-bootcamp-m14'
		DockerHub_TagName = 'jenkins'
		Docker_ContainerName = "${env.DockerHub_RepoName}"
		Application_Original_Port = '3456'
		Application_Expose_Port = '8001'
	}

	stages {

		stage('detener y eliminar contenedor') {
			steps {
				echo 'inicia detener y eliminar contenedor'
				sh "docker stop ${env.Docker_ContainerName} || true && docker rm -f ${env.Docker_ContainerName} || true"
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
				sh "docker build -t ${env.DockerHub_UserName}/${env.DockerHub_RepoName}:${env.DockerHub_TagName}_$BUILD_NUMBER ."
			}
		}

		stage('ejecutar contenedor con la imagen docker creada anteriormente') {
			steps {
				echo 'inicia ejecutar contenedor con la imagen docker creada anteriormente'
				sh "docker run -d --name ${env.Docker_ContainerName} -p ${env.Application_Expose_Port}:${env.Application_Original_Port} ${env.DockerHub_UserName}/${env.DockerHub_RepoName}:${env.DockerHub_TagName}_$BUILD_NUMBER"
			}
		}

		stage('login en dockerhub') {
			steps {
				echo 'inicia login dockerhub'
				sh "echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin"
			}
		}

		stage('push en dockerhub con la imagen docker creada anteriormente) {
			steps {
				echo 'inicia push en dockerhub con la imagen docker creada anteriormente'
				//sh "docker push ${env.DockerHub_UserName}/${env.DockerHub_RepoName}:${env.DockerHub_TagName}_$BUILD_NUMBER"
			}
		}
		
	}
	
	post {
		always {
			echo 'inicia logout en dockerhub'
			sh 'docker logout'
		}
	}
}
