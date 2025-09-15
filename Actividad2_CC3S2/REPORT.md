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
    
### Pregunta guía: ¿Qué campos de respuesta cambian si actualizas MESSAGE/RELEASE sin reiniciar el proceso? Explica por qué.  

No hay ningun cambio porque las variables se cargan al iniciar la pp, por lo que si acitualizamos los valores sin reiniciar el proceso no cambia nada.

# 2) DNS: nombres, registros y caché

<img width="521" height="112" alt="imagen" src="https://github.com/user-attachments/assets/2fe0bf7e-7d3d-4c1c-ba76-1ad03bd8589c" />

## En la siguiente imagen veremos que por configuracion, tengo bloqueado el UDP por lo que procedo a usar el TCP en su lugar ya que se usa en caso el UDP esté bloqueado como en el mio.
En general vendrían a ser lo mismo pero el TCP es como si hicieramos "fuerza bruta".
<img width="755" height="746" alt="imagen" src="https://github.com/user-attachments/assets/93497ca2-24f2-4e2e-8d70-aa8839b1ab05" />

y como nos podemos dar cuenta, arriba no puse el +ttlunits y en esta imagin si, lo que puedo notar
son los cambias en el formato que da el tiempo, SIN el +ttlunits nos da el tiempo en segundos
y CON el +ttlunits no da el tiempo en formato minutos y segundos (en hora tambien, dependiendo de cuanto tarde).
<img width="732" height="378" alt="imagen" src="https://github.com/user-attachments/assets/01687856-cc37-42c1-ba8a-a45ef250f894" />

### Pregunta guía: ¿Qué diferencia hay entre /etc/hosts y una zona DNS autoritativa? ¿Por qué el hosts sirve para laboratorio?

El /etc/host es de uso local, solo funcionaria en mi maquina, mientras que el DNS autoritativo es un dominio mas publico que publica un dominio
y responde a cualquier cliente siempre que este apunte al DNS de mi host.


# 3) TLS: seguridad en tránsito con Nginx como reverse proxy

## Certificado de laboratorio: genera autofirmado (usa el target make tls-cert si existe) y coloca crt/key donde lo espera Nginx (ver guía).

Como no tenía make, lo generé manualmente.

    sudo mkdir -p /etc/nginx/ssl
    sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/miapp.local.key \
    -out /etc/nginx/ssl/miapp.local.crt \
    -subj "/CN=miapp.local"

## Configura Nginx: usa el ejemplo provisto para terminación TLS y proxy_pass a http://127.0.0.1:8080 con cabeceras X-Forwarded-*. Luego nginx -t y reinicia el servicio. Incluye el snippet clave de tu server en el reporte.

<img width="969" height="101" alt="imagen" src="https://github.com/user-attachments/assets/48b7e8c6-670a-4ea9-8c3d-19ea51af885e" />

se puede ver en la salida que está todo correcto:

    nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
    nginx: configuration file /etc/nginx/nginx.conf test is successful



## Valida el handshake: openssl s_client -connect miapp.local:443 -servername miapp.local -brief (muestra TLSv1.2/1.3, cadena, SNI). curl -k https://miapp.local/ (explica el uso de -k con certificados autofirmados).

<img width="979" height="230" alt="imagen" src="https://github.com/user-attachments/assets/ec3ffe54-c8e5-4013-900d-6bf01adbcef2" />

En la imagen se ve la salida y sale el error: self-signed certificate, ya que es un certificado
creado manualmente. Y con el -k se ignora el error de certificado autofirmado.


## Puertos y logs:

    sep 14 23:21:19 tush systemd[1]: Started nginx.service - A high performance web server and a reverse proxy server.
    sep 14 23:23:16 tush systemd[1]: Stopped nginx.service - A high performance web server and a reverse proxy server.
    sep 14 23:23:16 tush systemd[1]: Started nginx.service - A high performance web server and a reverse proxy server.

<img width="1049" height="315" alt="imagen" src="https://github.com/user-attachments/assets/893fd8af-8e63-4e71-bddf-7f323cbb567c" />

Nos damos cuenta que flask y Nginx escuchan a sus puertos respectivos: 8080 y 443

# 4) 12-Factor App: port binding, configuración y logs

## Port binding: muestra que la app escucha en el puerto indicado por PORT (evidencia ss).
<img width="778" height="59" alt="imagen" src="https://github.com/user-attachments/assets/8d7b5a62-b855-408f-bff7-de490f322b18" />

## Config por entorno: ejecuta dos veces con distintos MESSAGE/RELEASE y documenta el efecto en la respuesta JSON.
Entrada 1
    export MESSAGE="Hola Mundo" RELEASE="v1"
    curl http://127.0.0.1:8080/
Salida 1:
    {"message":"Hola Mundo","release":"v1"}

Entrada 2
    $ export MESSAGE="Deploy en Producción" RELEASE="v2"
    $ curl http://127.0.0.1:8080/
Salida 2:
    {"message":"Deploy en Producción","release":"v2"}

## Logs a stdout: redirige a archivo mediante pipeline de shell y adjunta 5 líneas representativas. Explica por qué no se configura log file en la app.

<img width="1600" height="294" alt="imagen" src="https://github.com/user-attachments/assets/23f32080-4dbc-4583-9107-c1bf3fa96021" />
<img width="1011" height="109" alt="imagen" src="https://github.com/user-attachments/assets/47968df6-17da-4371-9e85-482baa8c8abf" />

























