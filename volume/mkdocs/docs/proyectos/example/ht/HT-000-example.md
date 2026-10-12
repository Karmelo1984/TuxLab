---
title: "[NOMBRE DE LA HISTORIA TÉCNICA]"
authors:
  - Carmelo Molero Castillo
date: 2025-03-25
version: 1.0.0
tags: [historia técnica]
---

# 🔧 [NOMBRE DE LA HISTORIA TÉCNICA]

## 📖 **Descripción**  
[Explicación breve del propósito técnico de la HT y su impacto en el sistema.]  

## 🎯 **Objetivo**  
[¿Por qué es necesaria esta HT? ¿Qué problema resuelve o qué mejora introduce?]  

## 🏗 **Historias de Usuario Relacionadas**  
📌 **Soporta:**  
- HU - Recuperación de contraseña  

---

## ✅ **Criterios de aceptación**  

### **📌 Casos de prueba funcionales**  
| Entrada | Acción | Resultado Esperado |
|---------|--------|--------------------|
| Usuario introduce un email válido | Se llama al endpoint `POST /auth/recover-password` | Devuelve `200 OK` y envía un correo |
| Email no existe en la base de datos | Se llama al endpoint | Devuelve `404 Not Found` |
| Token expirado | Usuario intenta restablecer la contraseña | Devuelve `400 Bad Request` |
| Token válido | Usuario envía nueva contraseña | La contraseña se actualiza y el token se invalida |

---

### **📌 Especificación Técnica**  

#### 🔹 **1. Endpoint para recuperar contraseña**  
📌 **Método:** `POST`  
📌 **Ruta:** `/auth/recover-password`  
📌 **Cuerpo de la solicitud:**  
```json
{
  "email": "usuario@example.com"
}
```
📌 **Respuesta esperada (`200 OK`):**  
```json
{
  "message": "Email enviado con instrucciones de recuperación"
}
```

---

#### 🔹 **2. Generación y expiración del token**
📌 **Reglas del token:**  
- Generado como UUID único.  
- Expira en **30 minutos**.  
- Guardado en la base de datos en la tabla `password_resets`.  

📌 **Ejemplo de inserción en base de datos:**  
```sql
INSERT INTO password_resets (email, token, expires_at)
VALUES ('usuario@example.com', '550e8400-e29b-41d4-a716-446655440000', NOW() + INTERVAL 30 MINUTE);
```

---

#### 🔹 **3. Manejo de errores**  
📌 **Si el token ha expirado, devolver:**  
```json
{
  "error": "El enlace de recuperación ha expirado. Por favor, solicita uno nuevo."
}
```
📌 **Si el email no existe, devolver:**  
```json
{
  "error": "Usuario no encontrado."
}
```

---

## 📌 **Impacto en el sistema**  
📌 **Afecta a:**  
- 📂 **Módulo de autenticación**  
- 🗂 **Base de datos (tabla `password_resets`)**  
- ✉️ **Servicio de correo**  

## ✅ **Criterios de finalización**  
✅ Endpoint implementado y probado.  
✅ Token de recuperación funcional con expiración.  
✅ Se han realizado pruebas unitarias y de integración.  
✅ QA ha validado todos los casos de prueba.  