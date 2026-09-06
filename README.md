# 🐍 Viborita: Snake Game en la Nube

**Bienvenido al proyecto Agentic DevOps.** Este repositorio contiene un juego Snake completamente funcional hecho con Python, Flask, Docker, Terraform y desplegado en AWS ECS. Es el proyecto principal del curso donde aprendes a desplegar aplicaciones reales en la nube con DevOps profesional.

---

## 📋 Tabla de Contenidos

- [Descripción del Proyecto](#descripción-del-proyecto)
- [Cómo Fork y Descargar el Repositorio](#cómo-fork-y-descargar-el-repositorio)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Instalación Local](#instalación-local)
- [Ejecución Local](#ejecución-local)
- [Personalizar la Interfaz del Juego](#personalizar-la-interfaz-del-juego)
- [Dockerizar la Aplicación](#dockerizar-la-aplicación)
- [Desplegar en AWS](#desplegar-en-aws)
- [CI/CD con GitHub Actions](#cicd-con-github-actions)
- [Limpieza de Recursos](#limpieza-de-recursos)
- [Solución de Problemas](#solución-de-problemas)

---

## 📖 Descripción del Proyecto

**Viborita** es un juego Snake clásico con:

- ✅ **Backend:** Python + Flask (framework web ligero)
- ✅ **Frontend:** HTML5 + CSS3 + JavaScript vanilla
- ✅ **Containerización:** Docker para reproducibilidad
- ✅ **Infraestructura:** Terraform & AWS ECS Fargate
- ✅ **Automatización:** GitHub Actions CI/CD
- ✅ **Monitoreo:** Logs en CloudWatch

### Objetivo del Curso

1. **Desarrollar** el juego usando Copilot Agent + Claude Code
2. **Containerizar** con Docker
3. **Automatizar** infraestructura con Terraform
4. **Deployar** en AWS ECS
5. **Automatizar** el pipeline con GitHub Actions
6. **Optimizar costos** y limpiar recursos

---

## 🍴 Cómo Fork y Descargar el Repositorio

### Opción 1: Fork en GitHub (Recomendado)

1. **Ve al repositorio original:**
   ```
   https://github.com/AlanJ97/snake-game-training
   ```

2. **Haz clic en "Fork"** (esquina superior derecha)
   - Esto crea una copia bajo tu cuenta

3. **Clona tu fork localmente:**
   ```bash
   git clone https://github.com/TU-USERNAME/snake-game-training.git
   cd snake-game-training
   ```

4. **Agrega el repositorio original como "upstream" (opcional):**
   ```bash
   git remote add upstream https://github.com/AlanJ97/snake-game-training.git
   ```

### Opción 2: Descarga como ZIP (Sin Git)

1. **Ve a:** https://github.com/AlanJ97/snake-game-training

2. **Click en "Code" → "Download ZIP"**

3. **Extrae el archivo** en tu computadora

4. **Abre la carpeta en VS Code**

---

## 📁 Estructura del Proyecto

```
snake-game-training/
│
├── app/                           # Aplicación Flask
│   ├── app.py                     # Punto de entrada (main)
│   ├── Dockerfile                 # Instrucciones para Docker
│   ├── requirements.txt           # Dependencias Python
│   ├── README.md                  # Instrucciones locales
│   ├── snake_game/                # Lógica de la app Flask
│   │   ├── __init__.py           # Inicialización Flask
│   │   ├── views.py              # Rutas y controladores
│   │   ├── static/               # CSS y JavaScript (cliente)
│   │   │   ├── style.css         # Estilos del juego
│   │   │   └── game.js           # Lógica del juego (cliente)
│   │   └── templates/            # HTML (Jinja)
│   │       ├── base.html         # Plantilla base
│   │       ├── index.html        # Página principal
│   │       └── 404.html          # Página de error
│   │
├── infra/                         # Infraestructura Terraform
│   ├── modules/                   # Módulos reutilizables
│   │   ├── ecr/                  # Registro Docker en AWS
│   │   ├── ecs/                  # Orquestación de contenedores
│   │   └── networking/           # VPC, subnets, security groups
│   └── prod/                     # Configuración de producción
│       ├── main.tf              # Recursos principales
│       ├── variables.tf         # Variables de entrada
│       ├── outputs.tf           # Salidas (URLs, ARNs)
│       ├── providers.tf         # Configuración AWS
│       └── terraform.tfvars     # Valores de variables
│
├── .github/workflows/             # GitHub Actions (CI/CD)
│   ├── docker-deploy.yml         # Build y push Docker
│   └── terraform.yml             # Deploy infraestructura
│
├── instructions/                  # Guías de referencia
│   ├── python_instructions.md
│   └── colors_web_game_instructions.md
│
└── README.md                      # Este archivo
```

---

## 🚀 Instalación Local

### Requisitos

- **Python 3.12+** - [Descargar](https://www.python.org/downloads/)
- **VS Code** - [Descargar](https://code.visualstudio.com/)
- **Git** - [Descargar](https://git-scm.com/)
- **Docker** (opcional, para desarrollo) - [Descargar](https://www.docker.com/products/docker-desktop)

### Pasos

1. **Clona el repositorio:**
   ```bash
   git clone https://github.com/TU-USERNAME/snake-game-training.git
   cd snake-game-training
   ```

2. **Crea un entorno virtual:**
   ```bash
   # Windows (PowerShell)
   python -m venv .venv
   .\.venv\Scripts\Activate.ps1
   
   # macOS/Linux (Bash)
   python3 -m venv .venv
   source .venv/bin/activate
   ```

3. **Instala dependencias:**
   ```bash
   python -m pip install --upgrade pip
   pip install -r app/requirements.txt
   ```

---

## ▶️ Ejecución Local

### Con Flask (Desarrollo)

```bash
cd app
flask --app app run --debug --port 8000
```

**Abre en tu navegador:** http://127.0.0.1:8000

### Con Docker (Producción Local)

```bash
cd app
docker build -t snake-game:local .
docker run -p 8000:8000 snake-game:local
```

**Abre en tu navegador:** http://localhost:8000

---

## 🎨 Personalizar la Interfaz del Juego

### Cambiar Colores

**Archivo:** `app/snake_game/static/style.css`

```css
/* Busca estas líneas y cambia los colores */

body {
    background-color: #1a1a1a;  /* Color fondo */
}

canvas {
    background-color: #000;     /* Color del tablero */
}

.game-container {
    border: 3px solid #00ff00;  /* Color borde */
}

/* Colores en game.js (abajo) */
```

**Archivo:** `app/snake_game/static/game.js`

```javascript
// Busca estas líneas en game.js
const SNAKE_COLOR = '#00ff00';    // Verde de la serpiente
const FOOD_COLOR = '#ff0000';     // Rojo de la comida
const GRID_COLOR = '#333333';     // Color del grid

// Cambia los valores hexadecimales (#RRGGBB) por los colores que prefieras
```

### Cambiar Tamaño del Tablero

**Archivo:** `app/snake_game/static/game.js`

```javascript
const CANVAS_WIDTH = 400;    // Ancho en píxeles (aumenta para tablero más grande)
const CANVAS_HEIGHT = 400;   // Alto en píxeles
const GRID_SIZE = 20;        // Tamaño de cada celda (aumenta para juego más grande)
```

### Cambiar la Velocidad del Juego

```javascript
// En game.js
const GAME_SPEED = 100;  // Milisegundos entre movimientos (menor = más rápido)
```

### Cambiar HTML/Texto

**Archivo:** `app/snake_game/templates/index.html`

```html
<h1>Viborita</h1>          <!-- Título del juego -->
<p>Score: <span id="score">0</span></p>  <!-- Texto de puntuación -->
<button id="startBtn">Comenzar</button>   <!-- Texto botones -->
```

### Cambiar Estilos Generales

**Archivo:** `app/snake_game/static/style.css`

```css
/* Fuente */
body {
    font-family: 'Arial', sans-serif;  /* Cambia la fuente */
    font-size: 16px;                   /* Tamaño texto */
}

/* Espaciado */
.game-container {
    padding: 20px;      /* Espacio interno */
    margin: 20px auto;  /* Espacio externo */
}

/* Botones */
button {
    background-color: #00ff00;
    color: #000;
    padding: 10px 20px;
    font-size: 16px;
    cursor: pointer;
    border: none;
    border-radius: 5px;
}
```

---

## 🐳 Dockerizar la Aplicación

### Build Local

```bash
cd app
docker build -t snake-game:1.0 .
docker run -p 8000:8000 snake-game:1.0
```

### Push a AWS ECR

```bash
# Conectarse a AWS
aws ecr get-login-password --region us-east-1 | \
    docker login --username AWS --password-stdin YOUR_AWS_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com

# Taggear la imagen
docker tag snake-game:1.0 YOUR_AWS_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com/snake-game:1.0

# Push
docker push YOUR_AWS_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com/snake-game:1.0
```

---

## ☁️ Desplegar en AWS

### Configuración Inicial

1. **Crea una cuenta AWS** (si no tienes): https://aws.amazon.com/

2. **Configura AWS CLI:**
   ```bash
   aws configure
   # Ingresa: Access Key, Secret Access Key, Region (us-east-1), Output (json)
   ```

3. **Actualiza variables en `infra/prod/terraform.tfvars`:**
   ```hcl
   aws_region       = "us-east-1"
   app_name         = "snake-game"
   container_port   = 8000
   ```

### Deploy con Terraform

```bash
cd infra/prod

# Inicializa Terraform
terraform init

# Revisa qué se va a crear
terraform plan

# Crea los recursos en AWS
terraform apply

# Guarda los outputs (URL del juego)
terraform output
```

**Accede a tu juego en:** El URL que te muestre `terraform output`

---

## 🚀 CI/CD con GitHub Actions

### Cómo Funciona

1. **Push a `main` branch** → GitHub Actions detecta el cambio
2. **Docker Build** → Construye la imagen
3. **Push a ECR** → Sube a AWS
4. **Terraform Apply** → Despliega en ECS
5. **Tu juego está en vivo** en AWS

### Archivos

- `.github/workflows/docker-deploy.yml` - Build y push Docker
- `.github/workflows/terraform.yml` - Deploy infraestructura

### Habilitar en GitHub

1. Ve a **Settings → Secrets and variables → Actions**
2. Agrega estos secrets:
   ```
   AWS_ACCESS_KEY_ID       = tu_access_key
   AWS_SECRET_ACCESS_KEY   = tu_secret_key
   AWS_ACCOUNT_ID          = 123456789012
   AWS_REGION              = us-east-1
   ```

---

## 🧹 Limpieza de Recursos

**Importante:** Elimina los recursos para evitar cargos en tu tarjeta AWS.

```bash
cd infra/prod

# Revisa qué se va a eliminar
terraform plan -destroy

# Elimina todos los recursos
terraform destroy
```

**Confirma con `yes`** cuando te pregunte.

---

## 🆘 Solución de Problemas

### Error: `ModuleNotFoundError: No module named 'flask'`

```bash
# Asegúrate de estar en el entorno virtual
.\.venv\Scripts\Activate.ps1

# Reinstala dependencias
pip install -r app/requirements.txt
```

### Error: `Port 8000 is already in use`

```bash
# Cambia el puerto
flask --app app run --debug --port 9000

# O cierra el proceso que usa el puerto
# Windows: netstat -ano | findstr :8000
# macOS/Linux: lsof -i :8000
```

### Docker build falla

```bash
# Limpia caché
docker system prune -a

# Intenta de nuevo
cd app
docker build -t snake-game:latest .
```

### Terraform apply falla

```bash
# Verifica que AWS CLI esté configurado
aws sts get-caller-identity

# Revisa los logs
terraform plan -out=tfplan
terraform show tfplan
```

---

## 📚 Recursos Útiles

- [Flask Documentation](https://flask.palletsprojects.com/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest)
- [Docker Documentation](https://docs.docker.com/)
- [AWS ECS Fargate](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/what-is-fargate.html)
- [GitHub Actions](https://docs.github.com/en/actions)

---

## 🤝 Conecta Conmigo

¿Completaste el curso? ¡Comparte tu logro!

- 🔗 **LinkedIn:** https://www.linkedin.com/in/alan-jesus-segundo-nava/
- 🐙 **GitHub:** https://github.com/AlanJ97
- 📧 **Preguntas:** Deja un comentario en el curso de Udemy

---

## 📄 Licencia

Este proyecto es para fines educativos. Siéntete libre de usarlo, modificarlo y compartirlo.

---

**Hecho con ❤️ para el curso Agentic DevOps**

**¡Felicidades por completar tu primer Deploy profesional en la nube!** 🚀
