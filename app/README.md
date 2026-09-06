# Viborita

Primera version del juego Snake hecha con Flask, Jinja, CSS y JavaScript.

## Ejecutar en local

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
flask --app app run --debug --port 8000
```

Despues abre `http://127.0.0.1:8000`.

El entorno `.venv/` es local y no debe subirse al repositorio.