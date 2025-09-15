# 1) HTTP: Fundamentos y herramientas
Creamos un entorno asilado (venv) como buena practica para instalar flask y ponemos las versiones en un requeriments.txt, esto garantiza que otra persona pueda instalar la misma
version de flask que requiera la app.
<img width="1600" height="904" alt="imagen" src="https://github.com/user-attachments/assets/de7d116c-a0a3-47b6-9c61-092a1c5d3eac" />

Primero debemos correr la app.py y dejarlo abierto.

    python app.py

<img width="1341" height="316" alt="imagen" src="https://github.com/user-attachments/assets/c56d031e-08be-462f-b9ff-b96623bcb32c" />

Luego en otra terminal hacemos los curl y ss.
Al correr:

    curl -i -X POST http://127.0.0.1:8080/

Nos damos cuentas que sale:

    HTTP/1.1 405 METHOD NOT ALLOWED

Eso quiere decir que como no hay metodo POST sale el 405, ya que solo hay metodo GET.
<img width="825" height="511" alt="imagen" src="https://github.com/user-attachments/assets/f35dcb4a-37ce-452f-b38d-d90dfbdb76c8" />

Al realizar:

    ss -ltnp | grep :8080

Nos sale:

    LISTEN 0      128          0.0.0.0:8080      0.0.0.0:*    users:(("python",pid=18281,fd=3))

Donde python3 está alojado en el puerto 8080
    
Pregunta guía: ¿Qué campos de respuesta cambian si actualizas MESSAGE/RELEASE sin reiniciar el proceso? Explica por qué.  

No hay ningun cambio porque las variables se cargan al iniciar la pp, por lo que si acitualizamos los valores sin reiniciar el proceso no cambia nada.

# 2) DNS: nombres, registros y caché

<img width="521" height="112" alt="imagen" src="https://github.com/user-attachments/assets/2fe0bf7e-7d3d-4c1c-ba76-1ad03bd8589c" />

## En la siguiente imagen veremos que por configuracion, tengo bloqueado el UDP por lo que procedo a usar el TCP en su lugar ya que se usa en caso el UDP esté bloqueado como en el mio.
En general vendrían a ser lo mismo pero el TCP es como si hicieramos "fuerza bruta".
<img width="755" height="746" alt="imagen" src="https://github.com/user-attachments/assets/93497ca2-24f2-4e2e-8d70-aa8839b1ab05" />











