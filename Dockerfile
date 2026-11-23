FROM python:3.12-slim AS base

ENV PYTHONDONTWRITEBYTECODE=1   # Evite la creation de fichier .pyc dans le conteneur
ENV PYTHONUNBUFFERED=1  # Affiche les logs python

WORKDIR /app

# Insatllation des dépendances du projet dans le conteneur
COPY requirements.txt .

RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

COPY app/ ./app/
COPY models/ ./models/

# 1. Création d'un groupe système 'app'
# 2. Création d'un utilisateur 'app' sans accès à un shell de connexion -> on ne peut pas se connecter à cet utilisateur via un terminal ou SSH
# 3. On donne à notre utilisateur la propriété des fichiers du dossier /app
RUN groupadd --system app \
    && useradd --system --gid app --home-dir /app --shell /usr/sbin/nologin app \
    && chown -R app:app /app

# On indique que les prochains instructions et l'application seront exécutés par l'utilisateur 'app'
USER app

# On lance les commandes qui permettent de mettre en route l'API
# ---------------------------- DEPLOIEMENT : Ajouter la commande --reload ----------------------------
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
