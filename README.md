# DevOps Flask Automation

A CI/CD automation project built around **Flaskr** — the official Flask tutorial blog application (auth + blog with SQLite) — wired up with **Docker**, **Jenkins**, and **Terraform** to demonstrate a complete build → push → deploy pipeline to AWS.

## Architecture / Pipeline Flow

```
Git push → Jenkins checkout → Docker build → Push to Docker Hub → Terraform apply → EC2 instance provisioned
```

1. **Checkout** – Jenkins pulls the latest code from source control.
2. **Build Docker** – builds the Flask app image (`devverma99/flask-app:v1`).
3. **Push to Docker Hub** – logs in with stored credentials and pushes the image.
4. **Terraform Deploy** – provisions an AWS EC2 instance to host the app.

## Tech Stack

| Layer | Tool |
|---|---|
| Application | Python / Flask (Flaskr tutorial app) |
| Database | SQLite |
| Containerization | Docker |
| CI/CD | Jenkins |
| Infrastructure as Code | Terraform |
| Cloud | AWS (EC2, `ap-south-1`) |

## Project Structure

```
DevOps-flask-automation/
├── flaskr/
│   ├── __init__.py         # App factory, registers blueprints
│   ├── auth.py               # Register / login / logout (session-based auth)
│   ├── blog.py                # CRUD for blog posts
│   ├── db.py                   # SQLite connection + init-db CLI command
│   ├── schema.sql              # user & post table definitions
│   ├── static/
│   │   └── style.css
│   └── templates/
│       ├── base.html
│       ├── auth/                # register.html, login.html
│       └── blog/                # index.html, create.html, update.html
├── Dockerfile                  # Builds and runs the Flask app
├── Jenkinsfile                    # CI/CD pipeline definition
├── main.tf                          # Terraform: provisions an AWS EC2 instance
└── requirements.txt
```

## Application Overview

The app is the standard Flask **Flaskr** tutorial project:

- **Auth** (`/auth/register`, `/auth/login`, `/auth/logout`) – user registration and session-based login, passwords hashed with Werkzeug.
- **Blog** (`/`, `/create`, `/<id>/update`, `/<id>/delete`) – logged-in users can create, edit, and delete their own posts; all posts are listed on the index page.
- Data is stored in a local SQLite database (`flaskr.sqlite`), initialized via `flask init-db`.

## Getting Started

### Prerequisites
- Docker
- Jenkins (for the automated pipeline)
- Terraform + AWS credentials configured (for the deploy stage)
- A Docker Hub account (image is pushed to `devverma99/flask-app`)

### 1. Run locally with Docker

```bash
docker build -t flask-app .
docker run -p 5000:5000 flask-app
```

The app will be available at `http://localhost:5000`.

> Note: the `Dockerfile` runs `flask init-db` at build time, which creates a fresh SQLite database inside the image — any data won't persist across container restarts unless you mount a volume for the `instance/` folder.

### 2. Run locally without Docker

```bash
pip install -r requirements.txt
export FLASK_APP=flaskr
export FLASK_ENV=development
flask init-db
flask run
```

### 3. CI/CD Pipeline (Jenkins)

The `Jenkinsfile` defines four stages:

| Stage | What it does |
|---|---|
| `checkout` | Pulls source from the configured SCM |
| `Build Docker` | `docker build -t devverma99/flask-app:v1 .` |
| `Push to Docker Hub` | Logs in using the `docker-hub-creds` Jenkins credential and pushes the image |
| `Terraform Deploy` | Runs `terraform init` and `terraform apply -auto-approve` |

To use it: create a Jenkins pipeline job pointing at this repo, and add a Jenkins credential named **`docker-hub-creds`** (username/password type) with your Docker Hub login.

### 4. Infrastructure (Terraform)

`main.tf` provisions a single AWS EC2 instance:

```hcl
provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "ec2_instance" {
  ami           = "ami-0a14f53a6fe4dfcd1"
  instance_type = "t3.micro"
  tags = {
    Name = "devOpsServer"
  }
}
```

Run manually if not going through Jenkins:

```bash
terraform init
terraform apply -auto-approve
```

Make sure AWS credentials are available in your environment (e.g. via `aws configure` or environment variables) before applying — the config doesn't hardcode credentials.

## Notes

- The AMI ID in `main.tf` is region/date-specific — verify it's still valid for `ap-south-1` before applying, since AMIs can be deprecated over time.
- `requirements.txt` pins fairly old package versions (Flask 1.1.1); consider upgrading for security patches if this moves beyond a learning project.
- No `.gitignore` was found for the `instance/` folder or `*.sqlite` files — be careful not to commit a populated local database.

## License

No license specified yet 
