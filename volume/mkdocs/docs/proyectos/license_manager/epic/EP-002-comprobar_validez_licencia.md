---
title: "EP-002 - Comprobar Validez de una Licencia"
authors:
  - Carmelo Molero Castillo
date: 2025-03-21
version: 1.0.0
tags: [épica]
---

# 🏗 EP-002 - Comprobar Validez de una Licencia

## 📖 Descripción  
🔍 **Propósito y valor:**  
Esta épica tiene como objetivo permitir al administrador verificar si una licencia es válida, es decir, si está dentro de su fecha de activación y no ha expirado. Aunque la licencia esté encriptada, el sistema debe ser capaz de comprobar su validez de forma transparente.

**Valor:** Garantiza que solo las licencias válidas se utilicen, protegiendo el software y asegurando que las empresas no utilicen licencias caducadas o falsificadas.

## 🎯 Objetivo  
El objetivo de esta épica es implementar un sistema que permita verificar la validez de una licencia encriptada de manera sencilla, comprobando fechas de activación y expiración, así como cualquier otra restricción asociada a la licencia.

## 🏗 Proyecto relacionado  
📌 **Parte del proyecto:** [License Manager](../index.md)

## 🏗 Historias de usuario relacionadas  
- HU-003 - Comprobar Licencia Válida _(pendiente)_  
- HU-004 - Verificar Fecha de Expiración de Licencia _(pendiente)_  

## ✅ Criterios de finalización  
- El sistema debe ser capaz de verificar la validez de una licencia encriptada sin necesidad de desencriptarla manualmente.  
- El proceso de validación debe comprobar la fecha de activación y la fecha de expiración, y verificar que la licencia aún esté dentro del período válido.  
- Si la licencia es válida, el sistema debe permitir su uso, de lo contrario, debe devolver un mensaje de expiración o invalidez.  
- El sistema debe ofrecer una validación rápida y eficiente sin exponer datos sensibles, ya que todo el proceso de verificación debe ser transparente para el usuario.  
- La funcionalidad ha sido probada exitosamente con casos de licencias válidas y caducadas.
