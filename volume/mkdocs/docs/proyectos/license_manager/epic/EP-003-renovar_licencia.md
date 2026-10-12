---
title: "EP-003 - Renovar Licencia"
authors:
  - Carmelo Molero Castillo
date: 2025-03-21
version: 1.0.0
tags: [épica]
---

# 🏗 EP-003 - Renovar Licencia

## 📖 Descripción  
🔍 **Propósito y valor:**  
El propósito de esta épica es permitir al administrador renovar las licencias que están próximas a expirar. La renovación de la licencia incluirá la extensión de la fecha de expiración y la actualización de otros parámetros relevantes, como el límite de socios activos o las funcionalidades habilitadas. Todo el proceso de renovación será transparente para el usuario, y la nueva licencia será encriptada de manera similar a la original.

**Valor:** Esta épica permite a las empresas seguir utilizando el software después de que la licencia original haya expirado, asegurando que el ciclo de vida de las licencias se gestione de manera continua y sin interrupciones.

## 🎯 Objetivo  
El objetivo de esta épica es permitir la renovación de licencias antes de que expiren. Esto incluye la actualización de la fecha de expiración y la posibilidad de modificar otros parámetros de la licencia. El sistema deberá generar una nueva licencia con la nueva información y asegurar que la renovación se realice de forma segura mediante encriptación.

## 🏗 Proyecto relacionado  
📌 **Parte del proyecto:** [License Manager](../index.md)

## 🏗 Historias de usuario relacionadas  
- HU-005 - Renovar Licencia _(pendiente)_  
- HU-006 - Actualizar Fecha de Expiración de Licencia _(pendiente)_  

## ✅ Criterios de finalización  
- El sistema debe permitir la renovación de licencias de manera fácil para el administrador, permitiendo la modificación de parámetros clave como la fecha de expiración, el límite de socios activos y el precio.  
- Una vez renovada, la licencia debe ser encriptada de nuevo utilizando el sistema de claves públicas y privadas.  
- El sistema debe validar que la renovación no genere conflictos con las licencias existentes, especialmente en cuanto a las fechas de expiración.  
- El proceso de renovación debe ser transparente y no debe requerir la intervención manual del usuario en cuanto a la encriptación.  
- La funcionalidad debe haber sido probada para asegurar que las licencias renovadas funcionen correctamente y estén actualizadas con los nuevos parámetros.
