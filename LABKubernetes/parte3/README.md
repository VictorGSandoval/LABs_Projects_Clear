# Parte 3: Health Checks (Probes)

## 🎯 Objetivo
Agregar health checks (livenessProbe y readinessProbe) al deployment para monitorear la salud de la aplicación.

## 📋 Pasos a Seguir

### 1. Aplicar el deployment con probes
```bash
kubectl apply -f deployment-with-probes.yaml
```

### 2. Verificar que los probes se aplicaron correctamente
```bash
kubectl describe deployment deploy-a | grep -A 15 "Liveness\|Readiness"
```

### 3. Monitorear el estado de los pods
```bash
kubectl get pods -l app=deploy-a -w
```

## ✅ Validaciones

### Verificar probes en el deployment
```bash
kubectl describe deployment deploy-a | grep -A 10 "Liveness\|Readiness"
```

**Resultado esperado:**
```
Liveness:     http-get http://:8089/prueba delay=30s timeout=5s period=10s #success=1 #failure=3
Readiness:    http-get http://:8089/prueba delay=30s timeout=3s period=5s #success=1 #failure=3
```

### Verificar estado de los pods
```bash
kubectl get pods -l app=deploy-a
```

**Resultado esperado:**
```
NAME                        READY   STATUS    RESTARTS   AGE
deploy-a-xxxxxxxxx-xxxxx    1/1     Running   0          2m
```

### Verificar logs de health checks
```bash
# Obtener nombre del pod
POD_NAME=$(kubectl get pods -l app=deploy-a -o jsonpath='{.items[0].metadata.name}')

# Ver logs del pod
kubectl logs $POD_NAME | grep -i probe
```

## 🔍 Comandos de Debugging

### Si los probes fallan
```bash
# Ver descripción detallada del pod
kubectl describe pod -l app=deploy-a

# Ver eventos relacionados con probes
kubectl get events --sort-by='.lastTimestamp' | grep -i probe

# Verificar que el endpoint responde
kubectl exec -it $(kubectl get pods -l app=deploy-a -o jsonpath='{.items[0].metadata.name}') -- curl -f http://localhost:8089/prueba
```

### Si el pod no está ready
```bash
# Verificar readiness probe
kubectl describe pod -l app=deploy-a | grep -A 10 "Readiness"

# Verificar que la aplicación está respondiendo
kubectl exec -it $(kubectl get pods -l app=deploy-a -o jsonpath='{.items[0].metadata.name}') -- curl http://localhost:8089/prueba
```

## 📝 Configuración de Probes

### Liveness Probe
- **Propósito**: Determina si el pod está vivo
- **Endpoint**: `/prueba` en puerto 8089
- **Initial Delay**: 30 segundos (tiempo para que la app inicie)
- **Period**: 10 segundos (frecuencia de verificación)
- **Timeout**: 5 segundos (tiempo máximo de espera)
- **Failure Threshold**: 3 (intentos antes de reiniciar)

### Readiness Probe
- **Propósito**: Determina si el pod está listo para recibir tráfico
- **Endpoint**: `/prueba` en puerto 8089
- **Initial Delay**: 30 segundos
- **Period**: 5 segundos (más frecuente que liveness)
- **Timeout**: 3 segundos
- **Failure Threshold**: 3 (intentos antes de marcar como no ready)
- **Success Threshold**: 1 (un éxito para marcar como ready)

## 🔧 Diferencias entre Liveness y Readiness

| Aspecto | Liveness Probe | Readiness Probe |
|---------|----------------|-----------------|
| **Propósito** | Verificar si el pod está vivo | Verificar si el pod está listo |
| **Acción si falla** | Reinicia el pod | Remueve el pod del service |
| **Frecuencia** | Cada 10 segundos | Cada 5 segundos |
| **Impacto** | Puede causar downtime | No causa downtime |

## 🎯 Beneficios de los Probes

1. **Detección automática de fallos**: Kubernetes detecta automáticamente cuando la aplicación no responde
2. **Recuperación automática**: Reinicia pods que fallan en liveness probe
3. **Balanceo de carga inteligente**: Solo envía tráfico a pods que pasan readiness probe
4. **Monitoreo proactivo**: Detecta problemas antes de que afecten a los usuarios

## ⚠️ Consideraciones

- **Initial Delay**: 30 segundos permite que la aplicación Spring Boot inicie completamente
- **Endpoint**: `/prueba` es un endpoint simple que responde rápidamente
- **Timeouts**: Configurados para ser rápidos pero no muy agresivos
- **Failure Threshold**: 3 intentos evitan reinicios innecesarios por fallos temporales 