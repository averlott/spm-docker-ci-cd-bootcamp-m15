# obtiene la imagen de openjdk desde dockerhub con el fin de tener disponible el entorno
# necesario para ejecutar la aplicacion elegida
FROM adoptopenjdk/openjdk11:jdk-11.0.12_7-ubuntu-slim

# crea una variable de entorno que variabiliza la version de la aplicacion a utilizar
ENV SPM_VER 1.0.0

# actualiza paquetes, instala la herramienta wget y tambien unzip, y por ultimo limpia el cache
RUN apt-get update && apt-get install wget && apt-get install unzip && apt-get clean

# download el .zip del repositorio github donde se encuentra la ultima version de la aplicacion a utilizar,
# luego deszipea dicho archivo y por ultimo lo borra
RUN wget https://github.com/averlott/spm/releases/download/v1.0.0/spm-$SPM_VER.zip && \
    unzip spm-$SPM_VER.zip && \
	rm -rf spm-$SPM_VER.zip

# expone el puerto 8001 desde el cual se invocara la aplicacion
EXPOSE 8001

# setea el comando/ejecutable inicial en el momento de ejecutar el contenedor,
# en este caso ejecutara un archivo java que inicia la aplicacion elegida
ENTRYPOINT ["/bin/bash", "-c", "java -jar ./spm-$SPM_VER.jar"]
