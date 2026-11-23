FROM python:3.12-slim AS base

ENV PYTHONDONTWRITEBYTECODE=1   # Evite la creation de fichier .pyc dans le conteneur
ENV PYTHONUNBUFFERED=1  # Affiche les logs python

WORKDIR /app

# Insatllation des dépendances du projet dans le conteneur
COPY requirements.txt .

RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt