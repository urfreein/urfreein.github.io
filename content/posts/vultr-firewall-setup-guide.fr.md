---
title: "Guide Complet du Firewall Vultr : Configuration de la Sécurité des Serveurs Cloud"
date: 2025-12-16T16:00:00+09:00
lastmod: 2025-12-16T16:00:00+09:00
draft: false
description: "Guide complet pour sécuriser les serveurs cloud en utilisant le pare-feu basé sur le web de Vultr. De la création de Firewall Groups à l'implémentation pratique."
tags: ["vultr", "firewall", "방화벽", "서버보안", "vps", "클라우드보안", "인프라"]
categories: ["클라우드"]
image: "https://images.urinfo24.com/featured/vultr-firewall-setup-guide-featured.jpg"
lightgallery: true
---

<!--
IMAGE PROMPT FOR AI IMAGE GENERATOR:

A professional, technical illustration depicting cloud firewall security concept.
- Style: Clean, modern technical diagram style with minimalist design
- Subject: Network firewall shield icon protecting cloud server instances
- Elements: Firewall shield in center, multiple server icons behind it, network traffic arrows (green for allowed, red for blocked), cloud infrastructure background
- Colors: Blue and white for security theme, green for allowed traffic, red for blocked traffic, gray for servers
- Mood: Professional, secure, trustworthy, technical
- Composition: Central firewall shield with bidirectional traffic flow visualization

Technical keywords: Vultr, firewall, cloud security, network protection, server infrastructure

SAVE AS: /home/freein/blog/urfreein.github.io/static/images/vultr-firewall-setup-guide-featured.jpg

NOTE: Hugo will serve this from /images/vultr-firewall-setup-guide-featured.jpg
-->

## 1. Qu'est-ce que Vultr Firewall?

Vultr Firewall est un service de pare-feu basé sur le web.
Il filtre les paquets avant que le trafic n'atteigne vos instances cloud.

### 1.1 Pourquoi en avez-vous besoin?

La sécurité des serveurs nécessite une défense en profondeur.
Les pare-feu hôtes (UFW, firewalld) seuls ne suffisent pas.

Vultr Firewall opère au niveau du réseau.
Par conséquent, le trafic malveillant est bloqué avant d'atteindre votre serveur.

### 1.2 Différence avec les pare-feu hôtes

**Pare-feu hôte (UFW, firewalld):**
- Opère dans le système d'exploitation du serveur
- Filtre le trafic après qu'il atteint le serveur
- Utilise les ressources CPU/mémoire

**Vultr Firewall:**
- Opère au niveau du réseau de Vultr
- Bloque le trafic avant qu'il n'atteigne le serveur
- Aucun impact sur les ressources du serveur

Par conséquent, utiliser les deux ensemble est l'approche la plus sûre.

### 1.3 Concept de Firewall Group

Vultr Firewall est géré par groupes.
Vous ajoutez plusieurs règles à un Firewall Group.
Ensuite, vous pouvez appliquer ce groupe à plusieurs instances.

Par exemple:
- Groupe de serveur web: Autoriser HTTP/HTTPS
- Groupe de serveur DB: Autoriser le port DB uniquement depuis des IP spécifiques
- Groupe de serveur de développement: Autoriser SSH uniquement


## 2. Créer un Firewall Group

### 2.1 Créer via le portail

Connectez-vous au Vultr Customer Portal.

1. Naviguez vers **Products → Network → Firewall**
2. Cliquez sur le bouton **Add Firewall**
3. Entrez le nom du groupe dans le champ **Description**
4. Cliquez sur le bouton **Add Firewall Group**

Le groupe est créé.
Mais c'est toujours un groupe vide sans règles.

### 2.2 Créer via l'API

L'utilisation de l'API permet l'automatisation.

```bash
curl "https://api.vultr.com/v2/firewalls" \
  -X POST \
  -H "Authorization: Bearer ${VULTR_API_KEY}" \
  -H "Content-Type: application/json" \
  --data '{
    "description": "web-server-firewall"
  }'
```

Vous recevrez un Firewall Group ID dans la réponse.
Mémorisez cet ID.

### 2.3 Gérer avec Terraform

Si vous gérez l'infrastructure en tant que code, utilisez Terraform.

```hcl
resource "vultr_firewall_group" "web" {
  description = "Web Server Firewall"
}
```

La gestion par code permet le contrôle de version.
Également pratique pour la collaboration en équipe.

## 3. Configurer les règles de pare-feu

### 3.1 Ajouter des règles de base

Cliquez sur le Firewall Group pour entrer dans l'écran de gestion des règles.

**Ajouter une règle IPv4:**
- Protocol: TCP
- Port: 80
- Source: Anywhere (0.0.0.0/0)

Cela permet l'accès HTTP depuis n'importe où.

### 3.2 Restreindre l'accès SSH

SSH ne devrait être accessible que depuis des IP spécifiques.

**Règle IPv4:**
- Protocol: TCP
- Port: 22
- Source: 123.45.67.89 (votre IP)

Maintenant l'accès SSH n'est possible que depuis votre IP.
Les autres IP sont bloquées.

### 3.3 Ouvrir plusieurs ports à la fois

Les serveurs web nécessitent HTTP et HTTPS ouverts.

**Règle 1 - HTTP:**
```
Protocol: TCP
Port: 80
Source: 0.0.0.0/0
```

**Règle 2 - HTTPS:**
```
Protocol: TCP
Port: 443
Source: 0.0.0.0/0
```

### 3.4 Ajouter des règles via l'API

```bash
curl "https://api.vultr.com/v2/firewalls/{firewall-id}/rules" \
  -X POST \
  -H "Authorization: Bearer ${VULTR_API_KEY}" \
  -H "Content-Type: application/json" \
  --data '{
    "ip_type": "v4",
    "protocol": "tcp",
    "subnet": "0.0.0.0",
    "subnet_size": 0,
    "port": "80",
    "notes": "Allow HTTP"
  }'
```

Utile dans les scripts d'automatisation.

### 3.5 Définir les règles dans Terraform

```hcl
resource "vultr_firewall_rule" "allow_http" {
  firewall_group_id = vultr_firewall_group.web.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  port              = "80"
  notes             = "Allow HTTP traffic"
}

resource "vultr_firewall_rule" "allow_https" {
  firewall_group_id = vultr_firewall_group.web.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  port              = "443"
  notes             = "Allow HTTPS traffic"
}

resource "vultr_firewall_rule" "allow_ssh" {
  firewall_group_id = vultr_firewall_group.web.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "123.45.67.89"
  subnet_size       = 32
  port              = "22"
  notes             = "Allow SSH from my IP"
}
```

## 4. Connexion aux instances

### 4.1 Connexion via le portail

Une fois que vous avez créé les règles, appliquez-les aux instances.

1. Naviguez vers **Products → Compute**
2. Cliquez sur l'instance cible
3. Allez dans **Settings → Firewall**
4. Sélectionnez le groupe dans le menu déroulant Firewall
5. Cliquez sur le bouton **Update Firewall Group**

Appliqué immédiatement.

### 4.2 Application à plusieurs instances

Et si vous avez plusieurs serveurs avec le même rôle?
Appliquez le même Firewall Group à chaque instance.

Par exemple:
- 3 serveurs web
- Tous nécessitent les mêmes règles de pare-feu

Par conséquent, appliquez un Firewall Group aux trois.
Les modifications de règles sont immédiatement reflétées sur les trois.

### 4.3 Connexion via l'API

```bash
curl "https://api.vultr.com/v2/instances/{instance-id}" \
  -X PATCH \
  -H "Authorization: Bearer ${VULTR_API_KEY}" \
  -H "Content-Type: application/json" \
  --data '{
    "firewall_group_id": "{firewall-id}"
  }'
```

Utilisez dans les scripts de déploiement automatisé.

### 4.4 Gestion avec Terraform

```hcl
resource "vultr_instance" "web" {
  region             = "sea"
  plan               = "vc2-1c-1gb"
  os_id              = 1743  # Ubuntu 22.04
  label              = "web-server-01"
  firewall_group_id  = vultr_firewall_group.web.id
}
```

Appliquez le pare-feu simultanément avec la création de l'instance.

## 5. Exemples d'utilisation pratique

### 5.1 Protection des serveurs web

Les serveurs web n'ont besoin que de HTTP, HTTPS et SSH ouverts.

```hcl
resource "vultr_firewall_group" "web" {
  description = "Web Server Firewall"
}

resource "vultr_firewall_rule" "web_ssh" {
  firewall_group_id = vultr_firewall_group.web.id
  protocol          = "tcp"
  port              = "22"
  ip_type           = "v4"
  subnet            = "123.45.67.89"  # Votre IP uniquement
  subnet_size       = 32
}

resource "vultr_firewall_rule" "web_http" {
  firewall_group_id = vultr_firewall_group.web.id
  protocol          = "tcp"
  port              = "80"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
}

resource "vultr_firewall_rule" "web_https" {
  firewall_group_id = vultr_firewall_group.web.id
  protocol          = "tcp"
  port              = "443"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
}
```

Tous les autres ports sont automatiquement bloqués.

### 5.2 Serveurs de base de données

Les serveurs DB ne devraient être accessibles que depuis les serveurs web.

```hcl
resource "vultr_firewall_rule" "db_from_web" {
  firewall_group_id = vultr_firewall_group.db.id
  protocol          = "tcp"
  port              = "5432"  # PostgreSQL
  ip_type           = "v4"
  subnet            = "192.168.1.10"  # IP privée du serveur web
  subnet_size       = 32
}
```

La DB ne peut pas être accédée via IP publique.
Uniquement possible via le réseau privé.

### 5.3 Intégration avec Load Balancer

Si vous utilisez un Load Balancer?
Les serveurs web ne devraient recevoir du trafic que du Load Balancer.

**Configuration des règles:**
- Protocol: TCP
- Port: 80
- Source: Load Balancer (entrez l'ID du LB)

Cela bloque l'accès direct contournant le Load Balancer.

## 6. Meilleures pratiques de sécurité

### 6.1 Politique par défaut: Tout refuser

La politique par défaut de Vultr Firewall est "bloquer tout".
Par conséquent, seul le trafic explicitement autorisé passe.

C'est l'approche correcte.
N'ouvrez que ce qui est nécessaire.

### 6.2 Principe du moindre privilège

N'ouvrez pas SSH à toutes les IP.
Cela devient une cible pour les attaques par force brute.

Par conséquent, n'autorisez que des IP spécifiques:
- IP du bureau
- IP VPN
- IP domicile

### 6.3 Défense en profondeur

Vultr Firewall seul suffit-il?
Non. Utilisez également les pare-feu hôtes.

**Couches de défense:**
1. Vultr Firewall (niveau réseau)
2. Pare-feu hôte (niveau OS)
3. Pare-feu applicatif (niveau app)

Par conséquent, configurez également UFW ou firewalld.

### 6.4 Tester avant la production

Que se passe-t-il si vous mal configurez le pare-feu?
Interruption de service.

Par conséquent, toujours:
1. Tester dans l'environnement de développement
2. Vérifier dans l'environnement de staging
3. Appliquer en production

### 6.5 Révision régulière des règles

Ce n'est pas une configuration unique.
Révisez les règles régulièrement:

- Supprimer les règles inutiles
- Supprimer les IP qui ne sont plus utilisées
- Refléter les nouvelles exigences de sécurité

## 7. Dépannage

### 7.1 Quand la connexion échoue

Impossible d'accéder à SSH ou au web?

**Liste de vérification:**
1. Le Firewall Group est-il connecté à l'instance?
2. Y a-t-il une règle autorisant le port?
3. L'IP source est-elle correcte?
4. Vérifiez également le pare-feu hôte

### 7.2 Temps d'application des règles

Les modifications du Firewall Group s'appliquent immédiatement.
Mais la propagation réseau peut prendre quelques secondes.

Essayez le test de connexion après 10-20 secondes.

### 7.3 Vérification des logs

Vultr Firewall lui-même ne fournit pas de logs.
Par conséquent, vérifiez les logs du pare-feu hôte.

**Logs UFW:**
```bash
sudo tail -f /var/log/ufw.log
```

**Logs Firewalld:**
```bash
sudo journalctl -u firewalld -f
```

### 7.4 Priorité des règles

Vultr Firewall n'a pas d'ordre de règles.
Toutes les règles fonctionnent avec une condition OR.

C'est-à-dire, si une règle correspond, elle est autorisée.

## 8. CLI et automatisation

### 8.1 Installation de Vultr CLI

```bash
# macOS
brew install vultr/vultr-cli/vultr-cli

# Linux
curl -L https://github.com/vultr/vultr-cli/releases/latest/download/vultr-cli-linux-amd64.tar.gz | tar xz
sudo mv vultr-cli /usr/local/bin/
```

Configurez la clé API:
```bash
export VULTR_API_KEY="your-api-key"
```

### 8.2 Gestion des Firewall Groups

**Lister les groupes:**
```bash
vultr-cli firewall group list
```

**Créer un groupe:**
```bash
vultr-cli firewall group create --description "Web Server"
```

**Ajouter une règle:**
```bash
vultr-cli firewall rule create \
  --firewall-group-id <id> \
  --protocol tcp \
  --port 80 \
  --ip-type v4 \
  --subnet 0.0.0.0 \
  --subnet-size 0
```

### 8.3 Automatisation du déploiement

Appliquez automatiquement le pare-feu lors du déploiement de nouvelles instances:

```bash
#!/bin/bash

# Créer une instance
INSTANCE_ID=$(vultr-cli instance create \
  --region sea \
  --plan vc2-1c-1gb \
  --os 1743 \
  --label web-server \
  --output json | jq -r '.id')

# Appliquer le pare-feu
vultr-cli instance update-firewall-group \
  --instance-id $INSTANCE_ID \
  --firewall-group-id $FIREWALL_ID

echo "Instance $INSTANCE_ID deployed with firewall"
```

## 9. Coûts et limitations

### 9.1 Coûts

Vultr Firewall est **entièrement gratuit**.
Aucun frais supplémentaire.

Par conséquent, recommandé pour toutes les instances.

### 9.2 Limitations

**Firewall Groups:**
- Maximum 50 par compte

**Règles:**
- Maximum 50 règles par groupe

Suffisant pour la plupart des cas.
Contactez le support si vous avez besoin de plus.

### 9.3 Différence avec Load Balancer Firewall

Vultr Load Balancer a un pare-feu séparé.
Les deux sont différents:

**Vultr Firewall:**
- Protège les instances
- Filtrage au niveau réseau

**Load Balancer Firewall:**
- Protège le Load Balancer
- Filtre le trafic entrant dans le LB

Par conséquent, configurez les deux lors de l'utilisation du Load Balancer.

## 10. Résumé

### 10.1 Avantages de Vultr Firewall

- Gratuit
- Protection au niveau réseau
- Application facile à plusieurs instances
- Support API/CLI/Terraform
- Aucune utilisation des ressources serveur

### 10.2 Quand utiliser?

**Doit utiliser:**
- Serveurs de production
- Services publics
- Traitement de données sensibles

**Optionnel:**
- Environnements de développement/test
- Serveurs utilisant uniquement le réseau privé

Mais appliquez à toutes les instances si possible.

### 10.3 Améliorations de sécurité supplémentaires

En plus de Vultr Firewall:
- Installez Fail2ban (bloquer force brute)
- Utilisez l'authentification par clé SSH
- Mises à jour de sécurité régulières
- Activez la protection DDoS

Plusieurs couches de sécurité sont nécessaires.

### 10.4 Références

- [Documentation officielle Vultr Firewall](https://docs.vultr.com/products/network/firewall)
- [Documentation API Vultr](https://www.vultr.com/api/)
- [Vultr CLI GitHub](https://github.com/vultr/vultr-cli)
- [Terraform Vultr Provider](https://registry.terraform.io/providers/vultr/vultr/latest/docs)

L'utilisation de Vultr Firewall protège les serveurs cloud en toute sécurité.
C'est gratuit et facile à utiliser.
Par conséquent, configurez-le maintenant.
