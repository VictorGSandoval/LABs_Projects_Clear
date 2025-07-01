# Parte 4: ConfigMap

## 🎯 Objetivo
Crear un ConfigMap para externalizar la configuración de la aplicación y eliminar valores hardcodeados del deployment.

## 📋 Pasos a Seguir

### 1. Aplicar el ConfigMap y deployment actualizado
```bash
kubectl apply -f configmap.yaml
```

### 2. Verificar que el ConfigMap se creó correctamente
```bash
kubectl get configmap app-config
kubectl describe configmap app-config
```

### 3. Verificar que las variables se aplicaron al pod
```bash
kubectl describe pod -l app=deploy-a | grep -A 10 "Environment"
```

### 4. Probar que la aplicación sigue funcionando
```bash
# Obtener IP del nodo
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="ExternalIP")].address}')
if [ -z "$NODE_IP" ]; then
  NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
fi

# Probar endpoint
curl http://$NODE_IP:30009/prueba
```

## ✅ Validaciones

### Verificar ConfigMap
```bash
kubectl get configmap app-config
```

**Resultado esperado:**
```
NAME         DATA   AGE
app-config   3      1m
```

### Verificar contenido del ConfigMap
```bash
kubectl describe configmap app-config
```

**Resultado esperado:**
```
Name:         app-config
Namespace:    lab-kubernetes
Labels:       app=deploy-a
Annotations:  <none>

Data
====
APP_NAME:
----
kubernetes-lab-app
ENVIRONMENT:
----
development
PORT:
----
8089
```

### Verificar variables en el pod
```bash
kubectl describe pod -l app=deploy-a | grep -A 10 "Environment"
```

**Resultado esperado:**
```
Environment:
  PORT:        <set to the key 'PORT' of config map 'app-config'>
  APP_NAME:    <set to the key 'APP_NAME' of config map 'app-config'>
  ENVIRONMENT: <set to the key 'ENVIRONMENT' of config map 'app-config'>
```

### Verificar variables dentro del contenedor
```bash
# Obtener nombre del pod
POD_NAME=$(kubectl get pods -l app=deploy-a -o jsonpath='{.items[0].metadata.name}')

# Verificar variables de entorno
kubectl exec $POD_NAME -- env | grep -E "(PORT|APP_NAME|ENVIRONMENT)"
```

**Resultado esperado:**
```
PORT=8089
APP_NAME=kubernetes-lab-app
ENVIRONMENT=development
```

## 🔍 Comandos de Debugging

### Si el ConfigMap no se aplica
```bash
# Verificar que el ConfigMap existe
kubectl get configmap app-config

# Verificar que el deployment referencia el ConfigMap correcto
kubectl get deployment deploy-a -o yaml | grep -A 5 "envFrom"

# Verificar eventos del pod
kubectl describe pod -l app=deploy-a | grep -A 10 "Events"
```

### Si las variables no están disponibles
```bash
# Verificar que el pod se reinició después del cambio
kubectl get pods -l app=deploy-a --show-labels

# Verificar logs del pod
kubectl logs -l app=deploy-a
```

## 📝 Beneficios del ConfigMap

### 1. **Separación de Configuración**
- La configuración está separada del código de la aplicación
- Fácil modificación sin cambiar el deployment

### 2. **Reutilización**
- El mismo ConfigMap puede ser usado por múltiples deployments
- Configuración centralizada

### 3. **Versionado**
- Los ConfigMaps pueden ser versionados junto con el código
- Historial de cambios de configuración

### 4. **Flexibilidad**
- Fácil cambio de configuración entre entornos
- Configuración específica por namespace

## 🔧 Configuraciones Incluidas

### ConfigMap `app-config`
- **PORT**: "8089" - Puerto de la aplicación
- **APP_NAME**: "kubernetes-lab-app" - Nombre de la aplicación
- **ENVIRONMENT**: "development" - Entorno de ejecución

### Deployment Actualizado
- **envFrom**: Usa `configMapRef` para cargar todas las variables del ConfigMap
- **Eliminado**: Variable `PORT` hardcodeada del deployment
- **Mantenido**: Todos los probes y recursos configurados anteriormente

## 🎯 Próximos Pasos

Con el ConfigMap implementado, ahora podemos:
1. **HPA**: Configurar escalado automático (Parte 5)
2. **Blue/Green**: Implementar estrategia de despliegue (Parte 6)
3. **Microservicios**: Crear servicios que se comuniquen (Parte 7)

## ⚠️ Consideraciones

- **Cambios de ConfigMap**: Los cambios en ConfigMap no reinician automáticamente los pods
- **Variables Sensibles**: Para datos sensibles, usar Secrets en lugar de ConfigMaps
- **Tamaño**: Los ConfigMaps tienen un límite de 1MB
- **Actualizaciones**: Para aplicar cambios, puede ser necesario reiniciar el deployment 