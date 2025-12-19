---
title: "Guía Completa de Vultr Firewall: Configuración de Seguridad del Servidor en la Nube"
date: 2025-12-16T16:00:00+09:00
lastmod: 2025-12-16T16:00:00+09:00
draft: false
description: "Guía completa para asegurar servidores en la nube utilizando el firewall basado en web de Vultr. Desde crear Firewall Groups hasta la implementación práctica."
tags: ["vultr", "firewall", "방화벽", "서버보안", "vps", "클라우드보안", "인프라"]
categories: ["클라우드"]
image: "https://urinfo24.com/cdn-cgi/image/width=1200,format=auto,quality=85/https://images.urinfo24.com/featured/vultr-firewall-setup-guide-featured.jpg"
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

## 1. ¿Qué es Vultr Firewall?

Vultr Firewall es un servicio de firewall basado en web.
Filtra paquetes antes de que el tráfico llegue a tus instancias en la nube.

### 1.1 ¿Por qué lo necesitas?

La seguridad del servidor requiere defensa en profundidad.
Los firewalls de host (UFW, firewalld) por sí solos no son suficientes.

Vultr Firewall opera a nivel de red.
Por lo tanto, el tráfico malicioso se bloquea antes de llegar a tu servidor.

### 1.2 Diferencia con los Firewalls de Host

**Firewall de Host (UFW, firewalld):**
- Opera dentro del sistema operativo del servidor
- Filtra el tráfico después de que llega al servidor
- Usa recursos de CPU/memoria

**Vultr Firewall:**
- Opera a nivel de red de Vultr
- Bloquea el tráfico antes de que llegue al servidor
- Sin impacto en los recursos del servidor

Por lo tanto, usar ambos juntos es el enfoque más seguro.

### 1.3 Concepto de Firewall Group

Vultr Firewall se gestiona en grupos.
Agregas múltiples reglas a un Firewall Group.
Luego puedes aplicar este grupo a múltiples instancias.

Por ejemplo:
- Grupo de servidor web: Permitir HTTP/HTTPS
- Grupo de servidor DB: Permitir puerto DB solo desde IPs específicas
- Grupo de servidor de desarrollo: Permitir solo SSH


## 2. Crear un Firewall Group

### 2.1 Crear desde el Portal

Inicia sesión en Vultr Customer Portal.

1. Navega a **Products → Network → Firewall**
2. Haz clic en el botón **Add Firewall**
3. Ingresa el nombre del grupo en el campo **Description**
4. Haz clic en el botón **Add Firewall Group**

El grupo está creado.
Pero todavía es un grupo vacío sin reglas.

### 2.2 Crear mediante API

Usar la API permite la automatización.

```bash
curl "https://api.vultr.com/v2/firewalls" \
  -X POST \
  -H "Authorization: Bearer ${VULTR_API_KEY}" \
  -H "Content-Type: application/json" \
  --data '{
    "description": "web-server-firewall"
  }'
```

Recibirás un Firewall Group ID en la respuesta.
Recuerda este ID.

### 2.3 Gestionar con Terraform

Si gestionas la infraestructura como código, usa Terraform.

```hcl
resource "vultr_firewall_group" "web" {
  description = "Web Server Firewall"
}
```

La gestión mediante código permite el control de versiones.
También es conveniente para la colaboración en equipo.

## 3. Configurar Reglas de Firewall

### 3.1 Agregar Reglas Básicas

Haz clic en el Firewall Group para entrar en la pantalla de gestión de reglas.

**Agregar Regla IPv4:**
- Protocol: TCP
- Port: 80
- Source: Anywhere (0.0.0.0/0)

Esto permite el acceso HTTP desde cualquier lugar.

### 3.2 Restringir Acceso SSH

SSH solo debe ser accesible desde IPs específicas.

**Regla IPv4:**
- Protocol: TCP
- Port: 22
- Source: 123.45.67.89 (tu IP)

Ahora el acceso SSH solo es posible desde tu IP.
Otras IPs están bloqueadas.

### 3.3 Abrir Múltiples Puertos a la Vez

Los servidores web necesitan tanto HTTP como HTTPS abiertos.

**Regla 1 - HTTP:**
```
Protocol: TCP
Port: 80
Source: 0.0.0.0/0
```

**Regla 2 - HTTPS:**
```
Protocol: TCP
Port: 443
Source: 0.0.0.0/0
```

### 3.4 Agregar Reglas mediante API

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

Útil en scripts de automatización.

### 3.5 Definir Reglas en Terraform

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

## 4. Conectar a Instancias

### 4.1 Conectar desde el Portal

Una vez que hayas creado reglas, aplícalas a las instancias.

1. Navega a **Products → Compute**
2. Haz clic en la instancia objetivo
3. Ve a **Settings → Firewall**
4. Selecciona el grupo del menú desplegable Firewall
5. Haz clic en el botón **Update Firewall Group**

Aplicado inmediatamente.

### 4.2 Aplicar a Múltiples Instancias

¿Qué pasa si tienes múltiples servidores con el mismo rol?
Aplica el mismo Firewall Group a cada instancia.

Por ejemplo:
- 3 servidores web
- Todos necesitan las mismas reglas de firewall

Por lo tanto, aplica un Firewall Group a los 3.
Los cambios en las reglas se reflejan inmediatamente en los 3.

### 4.3 Conectar mediante API

```bash
curl "https://api.vultr.com/v2/instances/{instance-id}" \
  -X PATCH \
  -H "Authorization: Bearer ${VULTR_API_KEY}" \
  -H "Content-Type: application/json" \
  --data '{
    "firewall_group_id": "{firewall-id}"
  }'
```

Usa en scripts de despliegue automatizado.

### 4.4 Gestionar con Terraform

```hcl
resource "vultr_instance" "web" {
  region             = "sea"
  plan               = "vc2-1c-1gb"
  os_id              = 1743  # Ubuntu 22.04
  label              = "web-server-01"
  firewall_group_id  = vultr_firewall_group.web.id
}
```

Aplica el firewall simultáneamente con la creación de la instancia.

## 5. Ejemplos de Uso Práctico

### 5.1 Proteger Servidores Web

Los servidores web solo necesitan HTTP, HTTPS y SSH abiertos.

```hcl
resource "vultr_firewall_group" "web" {
  description = "Web Server Firewall"
}

resource "vultr_firewall_rule" "web_ssh" {
  firewall_group_id = vultr_firewall_group.web.id
  protocol          = "tcp"
  port              = "22"
  ip_type           = "v4"
  subnet            = "123.45.67.89"  # Solo tu IP
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

Todos los demás puertos se bloquean automáticamente.

### 5.2 Servidores de Base de Datos

Los servidores DB solo deben ser accesibles desde los servidores web.

```hcl
resource "vultr_firewall_rule" "db_from_web" {
  firewall_group_id = vultr_firewall_group.db.id
  protocol          = "tcp"
  port              = "5432"  # PostgreSQL
  ip_type           = "v4"
  subnet            = "192.168.1.10"  # IP privada del servidor web
  subnet_size       = 32
}
```

No se puede acceder a la DB mediante IP pública.
Solo es posible a través de la Red Privada.

### 5.3 Integración con Load Balancer

¿Si usas un Load Balancer?
Los servidores web solo deben recibir tráfico del Load Balancer.

**Configuración de reglas:**
- Protocol: TCP
- Port: 80
- Source: Load Balancer (introduce el ID del LB)

Esto bloquea el acceso directo que evita el Load Balancer.

## 6. Mejores Prácticas de Seguridad

### 6.1 Política Predeterminada: Denegar Todo

La política predeterminada de Vultr Firewall es "bloquear todo".
Por lo tanto, solo pasa el tráfico explícitamente permitido.

Este es el enfoque correcto.
Solo abre lo necesario.

### 6.2 Principio de Mínimo Privilegio

No abras SSH a todas las IPs.
Se convierte en objetivo de ataques de fuerza bruta.

Por lo tanto, permite solo IPs específicas:
- IP de oficina
- IP de VPN
- IP de casa

### 6.3 Defensa en Profundidad

¿Es suficiente solo Vultr Firewall?
No. Usa firewalls de host también.

**Capas de defensa:**
1. Vultr Firewall (nivel de red)
2. Firewall de host (nivel de SO)
3. Firewall de aplicación (nivel de app)

Por lo tanto, configura UFW o firewalld también.

### 6.4 Probar Antes de Producción

¿Qué pasa si configuras mal el firewall?
Interrupción del servicio.

Por lo tanto, siempre:
1. Probar en entorno de desarrollo
2. Verificar en entorno de staging
3. Aplicar a producción

### 6.5 Revisión Regular de Reglas

No es una configuración única.
Revisa las reglas regularmente:

- Eliminar reglas innecesarias
- Eliminar IPs que ya no se usan
- Reflejar nuevos requisitos de seguridad

## 7. Solución de Problemas

### 7.1 Cuando Falla la Conexión

¿No puedes acceder a SSH o web?

**Lista de verificación:**
1. ¿Está el Firewall Group conectado a la instancia?
2. ¿Hay una regla que permita el puerto?
3. ¿Es correcta la IP de origen?
4. Verifica también el firewall del host

### 7.2 Tiempo de Aplicación de Reglas

Los cambios en el Firewall Group se aplican inmediatamente.
Pero la propagación de red puede tardar unos segundos.

Prueba la conexión después de 10-20 segundos.

### 7.3 Verificar Logs

Vultr Firewall en sí no proporciona logs.
Por lo tanto, verifica los logs del firewall del host.

**Logs de UFW:**
```bash
sudo tail -f /var/log/ufw.log
```

**Logs de Firewalld:**
```bash
sudo journalctl -u firewalld -f
```

### 7.4 Prioridad de Reglas

Vultr Firewall no tiene orden de reglas.
Todas las reglas funcionan con condición OR.

Es decir, si cualquier regla coincide, se permite.

## 8. CLI y Automatización

### 8.1 Instalar Vultr CLI

```bash
# macOS
brew install vultr/vultr-cli/vultr-cli

# Linux
curl -L https://github.com/vultr/vultr-cli/releases/latest/download/vultr-cli-linux-amd64.tar.gz | tar xz
sudo mv vultr-cli /usr/local/bin/
```

Configura la API Key:
```bash
export VULTR_API_KEY="your-api-key"
```

### 8.2 Gestionar Firewall Groups

**Listar grupos:**
```bash
vultr-cli firewall group list
```

**Crear grupo:**
```bash
vultr-cli firewall group create --description "Web Server"
```

**Agregar regla:**
```bash
vultr-cli firewall rule create \
  --firewall-group-id <id> \
  --protocol tcp \
  --port 80 \
  --ip-type v4 \
  --subnet 0.0.0.0 \
  --subnet-size 0
```

### 8.3 Automatización de Despliegue

Aplica automáticamente el firewall al desplegar nuevas instancias:

```bash
#!/bin/bash

# Crear instancia
INSTANCE_ID=$(vultr-cli instance create \
  --region sea \
  --plan vc2-1c-1gb \
  --os 1743 \
  --label web-server \
  --output json | jq -r '.id')

# Aplicar firewall
vultr-cli instance update-firewall-group \
  --instance-id $INSTANCE_ID \
  --firewall-group-id $FIREWALL_ID

echo "Instance $INSTANCE_ID deployed with firewall"
```

## 9. Costos y Limitaciones

### 9.1 Costos

Vultr Firewall es **completamente gratuito**.
Sin cargos adicionales en absoluto.

Por lo tanto, se recomienda para todas las instancias.

### 9.2 Limitaciones

**Firewall Groups:**
- Máximo 50 por cuenta

**Reglas:**
- Máximo 50 reglas por grupo

Suficiente para la mayoría de los casos.
Contacta con soporte si necesitas más.

### 9.3 Diferencia con Load Balancer Firewall

Vultr Load Balancer tiene un firewall separado.
Los dos son diferentes:

**Vultr Firewall:**
- Protege instancias
- Filtrado a nivel de red

**Load Balancer Firewall:**
- Protege el Load Balancer
- Filtra el tráfico que entra al LB

Por lo tanto, configura ambos cuando uses Load Balancer.

## 10. Resumen

### 10.1 Ventajas de Vultr Firewall

- Gratuito
- Protección a nivel de red
- Fácil aplicación a múltiples instancias
- Soporte para API/CLI/Terraform
- Sin uso de recursos del servidor

### 10.2 ¿Cuándo usar?

**Debe usar:**
- Servidores de producción
- Servicios públicos
- Procesamiento de datos sensibles

**Opcional:**
- Entornos de desarrollo/prueba
- Servidores que usan solo Red Privada

Pero aplica a todas las instancias si es posible.

### 10.3 Mejoras de Seguridad Adicionales

Además de Vultr Firewall:
- Instalar Fail2ban (bloquear fuerza bruta)
- Usar autenticación con clave SSH
- Actualizaciones de seguridad regulares
- Habilitar Protección DDoS

Se necesitan múltiples capas de seguridad.

### 10.4 Referencias

- [Documentación Oficial de Vultr Firewall](https://docs.vultr.com/products/network/firewall)
- [Documentación de API de Vultr](https://www.vultr.com/api/)
- [Vultr CLI GitHub](https://github.com/vultr/vultr-cli)
- [Terraform Vultr Provider](https://registry.terraform.io/providers/vultr/vultr/latest/docs)

Usar Vultr Firewall protege los servidores en la nube de manera segura.
Es gratuito y fácil de usar.
Por lo tanto, configúralo ahora mismo.
