---
title: "EP-001 - Generar Licencia"
authors:
  - Carmelo Molero Castillo
date: 2025-03-21
version: 1.0.0
tags: [épica]
---

# 🏗 EP-001 - Generar Licencia

## 📖 Descripción  
🔍 **Propósito y valor:**  
Esta épica tiene como objetivo permitir al administrador generar nuevas licencias para las empresas. El proceso de generación incluirá la creación de un archivo JSON con los datos de la licencia, como la fecha de activación, expiración, límite de socios y funcionalidades, que luego será encriptado de manera transparente para el usuario.

**Valor:** Asegura que el proceso de creación de licencias sea seguro y automatizado, protegiendo la información sensible mientras facilita la gestión de licencias.

## 🎯 Objetivo  
El objetivo de esta épica es permitir la creación de nuevas licencias para empresas, asegurándose de que la información se almacene de manera segura en formato encriptado. Esto debe incluir la capacidad para asignar funcionalidades específicas a cada licencia y definir parámetros clave como la fecha de activación y expiración.

## 🏗 Proyecto relacionado  
📌 **Parte del proyecto:** [License Manager](../index.md)

## 🏗 Historias de usuario relacionadas  
- HU-001 - Crear Licencia _(pendiente)_  
- HU-002 - Asignar Funcionalidades a Licencia _(pendiente)_  

## ✅ Criterios de finalización  
- El sistema debe generar una licencia con todos los parámetros necesarios: empresa asociada, fecha de activación, expiración, máximo de socios, precio y funcionalidades.  
- La licencia debe ser almacenada en formato JSON y encriptada con el sistema de claves públicas y privadas.  
- El administrador puede generar la licencia a través de una interfaz sencilla sin tener que preocuparse por los detalles de encriptación.  
- El proceso de generación de licencias ha sido probado y validado en un entorno de desarrollo.
