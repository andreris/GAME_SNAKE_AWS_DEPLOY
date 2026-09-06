# Instrucciones Python y Flask para este proyecto

Usar estas reglas antes de escribir o modificar codigo Python. La app sera una web app con Flask para el juego Snake, asi que el codigo debe ser simple, legible, mantenible y facil de ejecutar en un entorno aislado.

## Entorno virtual obligatorio

- Crear un entorno virtual por proyecto para no mezclar versiones ni paquetes globales.
- Nombre recomendado: `.venv` en la raiz del proyecto.
- En Windows PowerShell:

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
```

- Si PowerShell bloquea la activacion, usar una sola vez:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

- Instalar paquetes siempre con el entorno activado y usando `python -m pip`, por ejemplo:

```powershell
python -m pip install flask
python -m pip freeze > requirements.txt
python -m pip install -r requirements.txt
```

- No subir `.venv/` al repositorio. El entorno es desechable y debe poder recrearse con `requirements.txt`.
- No poner codigo del proyecto dentro de `.venv/`.
- Para salir del entorno usar `deactivate`.

## Calidad de codigo Python

- El codigo debe ser funcional, legible, mantenible, testeable, robusto y seguro.
- Seguir PEP 8 salvo que el proyecto ya tenga una convencion local diferente.
- Usar 4 espacios por nivel de indentacion; no mezclar tabs y espacios.
- Usar nombres descriptivos en `snake_case` para variables, funciones y metodos.
- Usar `CapWords` para clases y `UPPER_CASE_WITH_UNDERSCORES` para constantes.
- Evitar nombres de una sola letra, especialmente `l`, `O` e `I`.
- Mantener imports al inicio del archivo, separados en grupos: libreria estandar, paquetes externos y modulos locales.
- Evitar `from module import *`.
- Usar imports absolutos cuando sean mas claros.
- Preferir funciones pequenas con una sola responsabilidad.
- Evitar duplicacion: extraer helpers solo cuando reduzcan complejidad real.
- Usar type hints en funciones nuevas cuando aclaren entradas y salidas.
- Usar docstrings en modulos, clases, funciones y metodos publicos.
- Usar comentarios con moderacion: explicar decisiones no obvias, no narrar codigo evidente.
- Manejar excepciones especificas; evitar `except:` y `except Exception` salvo que se registre o se relance correctamente.
- Limitar el bloque `try` al minimo codigo que puede fallar.
- Usar `with` para recursos que deban cerrarse, como archivos o conexiones.
- Comparar con `None` usando `is None` o `is not None`.
- Para secuencias, usar `if items:` o `if not items:` en vez de comparar longitudes.
- Validar entradas de usuario antes de procesarlas.
- No usar `eval()`, `exec()`, secretos hardcodeados ni SQL construido con strings sin parametros.

## Formato y herramientas recomendadas

- Automatizar calidad mientras se escribe codigo.
- Usar un formateador consistente, preferiblemente `ruff format` o `black` si el proyecto lo adopta.
- Usar un linter, preferiblemente `ruff`; alternativas aceptables: `flake8` o `pylint`.
- Usar `pytest` para pruebas.
- Usar `mypy` o `pyright` si el proyecto empieza a necesitar chequeo estatico de tipos.
- Usar `bandit` o revision equivalente cuando haya manejo de entradas, archivos, autenticacion o comandos del sistema.
- Antes de cerrar una tarea, ejecutar al menos formato/lint/pruebas disponibles para el alcance cambiado.

## Estructura Flask recomendada

- Para algo minimo se puede iniciar con `app.py`, pero si la app crece usar paquete y application factory.
- Preferir esta estructura base:

```text
app/
	__init__.py        # create_app()
	routes/            # vistas o endpoints por area
	services/          # logica de negocio
	models/            # modelos/datos si aplica
	schemas/           # validacion/serializacion si aplica
	templates/         # Jinja templates
	static/            # CSS, JS, imagenes
tests/
requirements.txt
```

- Crear la app con una factory `create_app()` para facilitar configuracion, pruebas y crecimiento.
- Registrar rutas con Blueprints cuando haya varias areas funcionales.
- Mantener las rutas delgadas: recibir request, validar entrada, llamar servicios y devolver respuesta.
- Poner la logica del juego o reglas reutilizables en `services/`, no mezclada dentro de funciones de ruta.
- Usar `templates/base.html` con herencia de Jinja para layout comun.
- Usar `url_for()` para generar URLs de rutas y archivos estaticos.
- Guardar CSS, JS e imagenes en `static/` y referenciarlos con `url_for('static', filename='...')`.
- No activar `debug=True` en produccion.
- Leer configuracion desde variables de entorno cuando sean valores cambiantes o sensibles.
- Nunca guardar secretos, tokens, claves o passwords en el codigo.

## Buenas practicas para APIs Flask

- Disenar endpoints REST consistentes y faciles de entender.
- Usar sustantivos plurales para recursos: `/users`, `/games`, `/scores`.
- Usar minusculas en URLs.
- Usar guiones para separar palabras en URLs: `/high-scores`, no `/highScores` ni `/high_scores`.
- Usar `/` para jerarquia: `/users/{user_id}/scores`.
- No poner acciones CRUD en la URL: evitar `/users/get-all`, `/users/create` o `/scores/delete`.
- Usar verbos HTTP correctamente:
	- `GET` para leer datos.
	- `POST` para crear recursos o ejecutar acciones como `/games/{game_id}/restart`.
	- `PUT` para reemplazar un recurso completo.
	- `PATCH` para cambios parciales.
	- `DELETE` para eliminar.
- Para acciones que no son CRUD, usar verbos claros al final de la ruta: `/games/{game_id}/restart`.
- Devolver codigos HTTP apropiados: `200`, `201`, `204`, `400`, `401`, `403`, `404`, `409`, `422`, `500`.
- Devolver errores en JSON con un formato consistente, por ejemplo `message`, `code` y detalles opcionales.
- Validar y serializar entradas/salidas con schemas si el API empieza a crecer.
- Documentar endpoints desde el codigo cuando haya API publica o consumo externo.
- Mantener documentados inputs, outputs, codigos de respuesta y errores esperados.

## Seguridad Flask

- Tratar toda entrada del cliente como no confiable.
- Validar tipos, rangos y campos permitidos antes de actualizar estado del juego o guardar scores.
- Si se agrega login, usar autenticacion probada y tokens/sesiones con expiracion; no inventar criptografia propia.
- Proteger rutas privadas con autenticacion y autorizacion explicitas.
- Configurar CORS solo para origenes necesarios, no con comodines si hay credenciales.
- Usar HTTPS en despliegues reales.
- No exponer trazas internas ni errores crudos al usuario final.
- Registrar errores del servidor, pero sin imprimir secretos ni datos sensibles.

## Pruebas

- Escribir pruebas para reglas del juego que puedan vivir fuera del navegador: movimiento, colisiones, score, reinicio y estados finales.
- Probar rutas Flask con el test client de Flask o `pytest`.
- Cubrir casos felices, errores de validacion y casos limite.
- Preferir funciones que devuelven valores sobre funciones que solo imprimen o dependen de efectos secundarios; son mas faciles de probar.
- Cuando se arregle un bug, agregar una prueba que falle antes del arreglo si el alcance lo permite.

## Criterio de aceptacion para codigo Python

El codigo es aceptable si se puede instalar en un entorno virtual limpio, ejecutar sin dependencias globales, leer sin adivinar intenciones, probar en partes pequenas y extender sin mezclar rutas, logica de negocio, templates y configuracion.
