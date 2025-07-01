# Parte 2: Deployment y Service Base

## 🎯 Objetivo
Crear el deployment `deploy-a` con la aplicación Spring Boot y el service `service-a` tipo NodePort para exponer la aplicación.

## 📋 Pasos a Seguir

### 1. Aplicar el deployment y service
```bash
kubectl apply -f deployment.yaml
```

### 2. Verificar que los recursos se crearon correctamente
```bash
kubectl get deployment deploy-a
kubectl get service service-a
kubectl get pods -l app=deploy-a
```

### 3. Esperar a que el pod esté listo
```bash
kubectl wait --for=condition=ready pod -l app=deploy-a --timeout=120s
```

### 4. Probar el acceso a la aplicación
```bash
# Obtener la IP del nodo
kubectl get nodes -o wide

# Probar el endpoint (reemplazar <node-ip> con la IP real)
curl http://<node-ip>:30009/prueba
```

## ✅ Validaciones

### Verificar deployment
```bash
kubectl get deployment deploy-a
```

**Resultado esperado:**
```
NAME       READY   UP-TO-DATE   AVAILABLE   AGE
deploy-a   1/1     1            1           1m
```

### Verificar service
```bash
kubectl get service service-a
```

**Resultado esperado:**
```
NAME        TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
service-a   NodePort   10.96.xxx.xxx   <none>        8089:30009/TCP   1m
```

### Verificar pods
```bash
kubectl get pods -l app=deploy-a
```

**Resultado esperado:**
```
NAME                        READY   STATUS    RESTARTS   AGE
deploy-a-xxxxxxxxx-xxxxx    1/1     Running   0          1m
```

### Probar endpoint
```bash
# Obtener IP del nodo
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="ExternalIP")].address}')
if [ -z "$NODE_IP" ]; then
  NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
fi

# Probar endpoint
curl -v http://$NODE_IP:30009/prueba
```

**Resultado esperado:**
```json
{
  "status": "OK",
  "message": "Prueba exitosa",
  "timestamp": "2024-01-01T12:00:00Z"
}
```

## 🔍 Comandos de Debugging

### Si el pod no inicia
```bash
# Ver descripción del pod
kubectl describe pod -l app=deploy-a

# Ver logs del pod
kubectl logs -l app=deploy-a

# Ver eventos del namespace
kubectl get events --sort-by='.lastTimestamp'
```

### Si el service no responde
```bash
# Verificar endpoints
kubectl get endpoints service-a

# Verificar que el selector coincide
kubectl get pods --show-labels -l app=deploy-a
kubectl get service service-a -o yaml | grep -A 5 selector
```

### Si la imagen no se descarga
```bash
# Verificar que la imagen existe
docker pull gova731/dockerlab:3.0

# Ver logs de pull de imagen
kubectl describe pod -l app=deploy-a | grep -A 10 "Events"
```

## 📝 Notas Importantes

- **Imagen**: `gova731/dockerlab:3.0` - Aplicación Spring Boot
- **Puerto**: Configurado para usar puerto 8089 (variable de entorno PORT)
- **NodePort**: 30009 - Puerto externo para acceder desde fuera del cluster
- **Recursos**: Configurados con requests y limits para preparar HPA
- **Labels**: Incluye version v1 para preparar Blue/Green deployment

## 🔧 Configuraciones Incluidas

### Deployment
- 1 réplica inicial
- Imagen: gova731/dockerlab:3.0
- Puerto del contenedor: 8089
- Variable de entorno: PORT=8089
- Recursos: CPU 100m-200m, Memory 128Mi-256Mi

### Service
- Tipo: NodePort
- Puerto interno: 8089
- Puerto externo: 30009
- Selector: app=deploy-a 