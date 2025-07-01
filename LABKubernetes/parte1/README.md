# Parte 1: Namespace y Configuración Base

## 🎯 Objetivo
Crear el namespace `lab-kubernetes` y configurarlo como contexto por defecto para el laboratorio.

## 📋 Pasos a Seguir

### 1. Crear el namespace
```bash
kubectl apply -f namespace.yaml
```

### 2. Configurar contexto por defecto
```bash
kubectl config set-context --current --namespace=lab-kubernetes
```

## ✅ Validaciones

### Verificar namespace creado
```bash
kubectl get namespace lab-kubernetes
```

**Resultado esperado:**
```
NAME              STATUS   AGE
lab-kubernetes    Active   1m
```

### Verificar contexto configurado
```bash
kubectl config view --minify --output 'jsonpath={..namespace}'
```

**Resultado esperado:**
```
lab-kubernetes
```

### Verificar que estamos en el namespace correcto
```bash
kubectl config current-context
kubectl config view --minify --output 'jsonpath={..namespace}'
```

## 🔍 Comandos de Debugging

Si hay problemas:
```bash
# Ver todos los namespaces
kubectl get namespaces

# Ver contexto actual
kubectl config current-context

# Ver todos los contextos
kubectl config get-contexts

# Cambiar contexto manualmente si es necesario
kubectl config use-context <context-name>
```

## 📝 Notas
- El namespace `lab-kubernetes` será usado para todos los recursos del laboratorio
- Configurar el contexto por defecto evita tener que especificar `-n lab-kubernetes` en cada comando
- Los labels en el namespace ayudan a identificar el propósito del laboratorio 