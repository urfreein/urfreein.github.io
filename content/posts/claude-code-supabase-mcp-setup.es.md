---
title: "Guía Completa de Claude Code + Servidor MCP de Supabase: Desde la Instalación hasta la Utilización para Principiantes"
date: 2025-12-22T07:30:20+09:00
lastmod: 2025-12-22T07:45:22+09:00
draft: false
description: "Aprende cómo conectar Claude Code con Supabase como servidor MCP para gestionar bases de datos usando lenguaje natural desde una perspectiva para principiantes. Explicación paso a paso desde la instalación hasta el uso práctico y consideraciones de seguridad."
tags: ["Claude Code", "Supabase", "MCP", "Model Context Protocol", "데이터베이스", "AI 개발도구", "자연어 쿼리", "개발 생산성"]
categories: ["DevOps"]
image: "https://urinfo24.com/cdn-cgi/image/width=1200,format=auto,quality=85/https://images.urinfo24.com/featured/claude-code-supabase-mcp-setup-featured.jpg"
lightgallery: true
---

<!--
Image Prompt: /Users/freein/Work/blog/images/image-prompt/claude-code-supabase-mcp-setup-prompt.txt
Featured Image: https://images.urinfo24.com/featured/claude-code-supabase-mcp-setup-featured.jpg
-->

Al usar Claude Code, hay momentos en los que quieres acceder a datos externos.
Las operaciones de base de datos, en particular, pueden ser engorrosas ya que necesitas abrir el panel de control y escribir SQL cada vez.
En tales casos, usar servidores MCP te permite manejar bases de datos usando lenguaje natural en Claude Code.

Este artículo cubre cómo conectar Claude Code con Supabase como servidor MCP desde una perspectiva para principiantes.
Procederemos paso a paso desde la instalación hasta el uso práctico.

## 1. Qué es MCP

### 1.1 El Concepto de MCP

MCP (Model Context Protocol) es un protocolo estándar para que los modelos de IA interactúen con herramientas y datos externos.
En términos simples, piénsalo como un puente que conecta la IA con sistemas externos.

Anteriormente, si la IA quería acceder a datos externos, tenías que crear APIs personalizadas cada vez.
Esto resultaba en altos costos de desarrollo y mantenimiento difícil.
MCP es un enfoque estandarizado creado por Anthropic para resolver estos problemas.

### 1.2 Por qué es Necesario

Claude Code sobresale escribiendo código pero no tenía forma de acceder a datos externos.
Para consultas de base de datos, acceso al sistema de archivos, llamadas a API, etc., tenías que hacer todo manualmente.

Usar servidores MCP te permite realizar estas tareas con lenguaje natural.
Por ejemplo, si solicitas "Muéstrame los 10 usuarios registrados más recientemente de la tabla users," Claude automáticamente escribe y ejecuta el SQL.
Esto mejora significativamente la productividad del desarrollo.

## 2. Guía de Instalación del Servidor MCP de Supabase

### 2.1 Prerequisitos

Primero, verifiquemos qué se necesita.

**Requisitos esenciales**:
- Node.js (v16 o superior)
- Claude Code instalado
- Cuenta de Supabase

Verifiquemos la versión de Node.js.

```bash
node --version
```

v16 o superior está bien.

### 2.2 Configuración del Proyecto de Supabase

Inicia sesión en el panel de control de Supabase (https://supabase.com).
Crea un nuevo proyecto o usa uno existente.

Verifica la siguiente información en la configuración del proyecto:
- URL del Proyecto (ej., `https://xxxxx.supabase.co`)
- API Keys → clave pública `anon`

Esta información será usada más tarde en la configuración del servidor MCP.

**Importante**: La clave `service_role` tiene permisos completos, así que úsala con cuidado.
Úsala solo en entornos de desarrollo y nunca la subas a repositorios públicos.

### 2.3 Generando la URL del Servidor MCP de Supabase

Supabase proporciona un servidor MCP oficial.
Puedes generar una URL MCP personalizada en la pestaña 'Connect' → 'MCP' del panel de control.

El formato de URL es el siguiente:

```
https://mcp.supabase.com/mcp?project_ref=YOUR_PROJECT_ID&read_only=true
```

**Explicación de parámetros de consulta**:
- `project_ref`: Restringir a proyecto específico (recomendado)
- `read_only`: Habilitar modo de solo lectura (recomendado)

El modo de solo lectura previene modificaciones accidentales de datos.
Es seguro habilitar esta opción durante el desarrollo inicial.

### 2.4 Configuración de Claude Code

Ahora configuremos el servidor MCP en Claude Code.

#### Configuración en macOS

La ruta del archivo de configuración es la siguiente:

```
~/Library/Application Support/Claude/claude_desktop_config.json
```

Crea el archivo si no existe.

```bash
mkdir -p ~/Library/Application\ Support/Claude
touch ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

#### Configuración en Windows

En Windows, usa la siguiente ruta:

```
%APPDATA%\Claude\claude_desktop_config.json
```

Ingresa `%APPDATA%\Claude` en la barra de direcciones del Explorador.

## 3. Verificación de Conexión

### 3.1 Escribiendo el Archivo de Configuración

Abre el archivo `claude_desktop_config.json` y añade el siguiente contenido.

```json
{
  "mcpServers": {
    "supabase": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-supabase",
        "https://xxxxx.supabase.co",
        "your-anon-key-here"
      ]
    }
  }
}
```

**Explicación de parámetros**:
- `command`: Usar `npx` (ejecución directa de paquete npm)
- `args`: Paquete del servidor MCP e información de autenticación

**O usar servidor MCP hospedado**:

```json
{
  "mcpServers": {
    "supabase": {
      "url": "https://mcp.supabase.com/mcp?project_ref=YOUR_PROJECT_ID&read_only=true"
    }
  }
}
```

El enfoque de hospedaje es más simple.
Maneja automáticamente la autenticación OAuth 2.1.

### 3.2 Prueba de Conexión

Reinicia Claude Code.
Haz clic en el ícono de Herramientas en el menú para ver la lista de servidores MCP conectados.

Si ves el servidor "supabase", es exitoso.

Hagamos una prueba simple.

```
A Claude: "¿Cuál es la clave anon de Supabase?"
```

Claude consulta la información del proyecto y te la dice.
Si esto funciona, el servidor MCP está correctamente conectado.

## 4. Ejemplos de Uso Práctico

Ahora realicemos operaciones de base de datos realmente.

### 4.1 Consultas de Tabla

La operación más básica es consultar tablas.

```
A Claude: "Muéstrame todos los datos de la tabla users"
```

Claude automáticamente escribe y ejecuta una consulta SELECT.
Organiza los resultados en una tabla bien formateada.

**También son posibles solicitudes más específicas**:

```
"Muéstrame solo usuarios con emails de Gmail de la tabla users"
```

```
"Dime cuántos usuarios se registraron en los últimos 7 días"
```

Cuando solicitas en lenguaje natural, Claude automáticamente genera SQL apropiado.

### 4.2 Inserción de Datos

La inserción de datos también es posible cuando el modo read_only está deshabilitado.

Primero, cambia `read_only=false` en el archivo de configuración.

```json
{
  "mcpServers": {
    "supabase": {
      "url": "https://mcp.supabase.com/mcp?project_ref=YOUR_PROJECT_ID&read_only=false"
    }
  }
}
```

Después de reiniciar Claude Code, haz una solicitud como esta.

```
"Añade un nuevo usuario a la tabla users. 
El nombre debe ser 'John', el email debe ser 'john@example.com'"
```

Claude genera una consulta INSERT y solicita ejecución.
Cuando el usuario aprueba, los datos se añaden.

### 4.3 Creación de Tablas

También puedes crear nuevas tablas.

```
"Crea una tabla comments. 
Las columnas deben ser id, user_id, content, created_at"
```

Claude genera una consulta CREATE TABLE.
Después de revisar el esquema y aprobar, la tabla se crea.

### 4.4 Consultas Complejas

Las consultas JOIN o agregadas también pueden solicitarse en lenguaje natural.

```
"Muestra el número de comentarios escritos por cada usuario"
```

```
"¿Cuántos usuarios que se registraron este mes han escrito al menos 1 comentario?"
```

Claude automáticamente escribe SQL complejo también.
Esto hace posibles las operaciones de base de datos incluso sin conocimiento perfecto de SQL.

## 5. Seguridad y Consejos

### 5.1 Consideraciones de Seguridad

La seguridad debe considerarse al usar servidores MCP.

**Prohibir conexiones a datos de producción**:
- Usar MCP solo en entornos de desarrollo/prueba
- Nunca conectar a bases de datos de servicios reales
- La IA podría borrar accidentalmente datos importantes

**Utilizar modo de solo lectura**:
- Establecer read_only=true por defecto
- Deshabilitar temporalmente solo cuando se necesiten operaciones de escritura
- Re-habilitar después de completar el trabajo

**Alcance del proyecto**:
- Restringir acceso solo a proyectos específicos usando el parámetro project_ref
- No dar permisos de acceso a múltiples proyectos

**Gestión de claves API**:
- No poner claves API directamente en archivos de configuración
- Gestionar con variables de entorno es más seguro
- Nunca subir a repositorios públicos

### 5.2 Consejos de Uso Efectivo

**Hacer solicitudes específicas**:
- "Mostrar datos" ❌
- "Mostrar emails y fechas de registro de los 10 usuarios más recientes de la tabla users" ✅

**Proceder paso a paso**:
- No hacer operaciones complejas de una vez
- Primero consultar para verificar, luego modificar

**Revisar consultas**:
- Siempre verificar el SQL generado por Claude
- Solicitar modificaciones si hay partes sospechosas

**Especificar herramientas**:
- "Usar la herramienta MCP de Supabase para consultar la tabla users"
- Especificar así puede ahorrar tokens

## 6. Resumen

Hemos aprendido cómo conectar Claude Code con el servidor MCP de Supabase.

**Resumen de contenido clave**:
- MCP es un protocolo estándar que conecta la IA con sistemas externos
- Supabase proporciona un servidor MCP oficial
- Añadir información del servidor MCP al archivo de configuración
- Las operaciones de base de datos pueden realizarse usando lenguaje natural
- Usar modo read_only para seguridad

**Próximos pasos**:
- Probar añadir otros servidores MCP (GitHub, Notion, etc.)
- Crear flujos de trabajo complejos combinando múltiples servidores MCP
- Desarrollar servidores MCP personalizados adecuados para tus proyectos

La buena utilización de servidores MCP mejora significativamente la productividad de Claude Code.
Puedes integrarte con varias herramientas externas más allá de solo operaciones de base de datos.
Esto hace que los flujos de trabajo de desarrollo sean mucho más convenientes.