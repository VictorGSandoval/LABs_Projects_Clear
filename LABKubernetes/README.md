# 📘 LABORATORIO KUBERNETES – ESCALADO Y COMUNICACIÓN ENTRE SERVICIOS

## 🎯 Objetivo del Laboratorio

Construir un entorno práctico con Kubernetes para desplegar una aplicación Spring Boot y aprender conceptos avanzados como:
- Despliegue de aplicaciones con configuraciones externas
- Exposición de servicios con NodePort
- Health checks (probes)
- Escalado automático con HPA
- Estrategias de despliegue (Blue/Green)
- Comunicación entre servicios simulando microservicios
- Automatización con CronJob
- Organización declarativa con Kustomize

## 🏗️ Estructura del Proyecto

```
LABK8S/
├── README.md
├── parte1/          # Namespace y configuración base
│   ├── namespace-base.yaml      # Para completar
│   └── README.md
├── parte2/          # Deployment y Service base
│   ├── deployment-base.yaml     # Para completar
│   └── README.md
├── parte3/          # Health Checks (Probes)
│   ├── deployment-base.yaml     # Para completar
│   └── README.md
├── parte4/          # ConfigMap
│   ├── configmap-base.yaml      # Para completar
│   └── README.md
├── parte5/          # HPA (Horizontal Pod Autoscaler)
│   ├── hpa-base.yaml            # Para completar
│   ├── load-generator.yaml
│   └── README.md
├── parte7/          # Servicio B - Microservicio cliente
│   ├── deployment-base.yaml     # Para completar
│   └── README.md
├── parte8/          # CronJob
│   ├── cronjob-base.yaml        # Para completar
│   └── README.md
├── parte9/          # Blue/Green Deployment (FINAL)
│   ├── deployment-base.yaml     # Para completar
│   ├── switch-to-green.sh
│   └── README.md
├── parte10/         # Kustomize
│   ├── base/
│   │   └── kustomization.yaml   # Para evolucionar
│   └── README.md
└── validaciones/    # Scripts de validación
    └── validate-lab.sh
```

## 🚀 Guía de Ejecución

### Prerrequisitos
- Kubernetes cluster funcionando
- kubectl configurado
- Acceso a internet para descargar la imagen `gova731/dockerlab:3.0`

### Orden de Ejecución
1. **Parte 1**: Crear namespace y configurar contexto
2. **Parte 2**: Desplegar aplicación base con Service NodePort
3. **Parte 3**: Agregar health checks
4. **Parte 4**: Implementar ConfigMap
5. **Parte 5**: Configurar HPA
6. **Parte 7**: Crear servicio cliente (microservicio)
7. **Parte 8**: Configurar CronJob
8. **Parte 9**: Implementar estrategia Blue/Green (FINAL)
9. **Parte 10**: Organizar con Kustomize

## 📋 Metodología de Trabajo

### Para cada parte:
1. **Leer el archivo base** (ej: `parte1/namespace-base.yaml`)
2. **Completar los TODOs** según las instrucciones
3. **Aplicar y probar** tu solución
4. **Comparar** con el archivo resuelto si es necesario
5. **Validar** con los comandos del README de cada parte

### Archivos Base vs Resueltos:
- **Base**: Contiene comentarios cortos y TODOs para que completes
- **Resuelto/Completo**: Solución completa con contexto detallado

### Ejemplo de trabajo:
```bash
# 1. Trabajar con el archivo base
vim parte1/namespace-base.yaml

# 2. Completar los TODOs
# 3. Aplicar
kubectl apply -f parte1/namespace-base.yaml

# 4. Si tienes dudas, revisar la solución
cat parte1/namespace-completo.yaml
```

## 📋 Validaciones por Parte

### Parte 1 - Namespace
```bash
# Validar namespace creado
kubectl get namespace lab-kubernetes

# Validar contexto configurado
kubectl config view --minify --output 'jsonpath={..namespace}'
```

### Parte 2 - Deployment y Service
```bash
# Validar deployment
kubectl get deployment deploy-a

# Validar pods
kubectl get pods -l app=deploy-a

# Validar service
kubectl get service service-a

# Probar acceso (reemplazar <node-ip> y <nodeport>)
curl http://<node-ip>:<nodeport>/prueba
```

### Parte 3 - Health Checks
```bash
# Verificar probes en el deployment
kubectl describe deployment deploy-a | grep -A 10 "Liveness\|Readiness"

# Verificar logs de health checks
kubectl logs <pod-name> | grep -i probe
```

### Parte 4 - ConfigMap
```bash
# Verificar ConfigMap
kubectl get configmap app-config

# Verificar que se aplicó al pod
kubectl describe pod <pod-name> | grep -A 5 "Environment"
```

### Parte 5 - HPA
```bash
# Verificar HPA
kubectl get hpa

# Generar carga para probar escalado
kubectl exec -it <pod-name> -- yes > /dev/null &

# Monitorear escalado
kubectl get pods -w
```

### Parte 7 - Servicio Cliente
```bash
# Verificar servicio B
kubectl get deployment deploy-b
kubectl get service service-b

# Ver logs del servicio cliente
kubectl logs -l app=deploy-b
```

### Parte 8 - CronJob
```bash
# Verificar CronJob
kubectl get cronjob

# Ver jobs creados
kubectl get jobs

# Ver logs del último job
kubectl logs job/<job-name>
```

### Parte 9 - Blue/Green (FINAL)
```bash
# Verificar ambas versiones
kubectl get deployment -l app=deploy-a

# Verificar service selector
kubectl get service service-a -o yaml | grep -A 5 selector

# Probar switch sin downtime
chmod +x switch-to-green.sh
./switch-to-green.sh
```

### Parte 10 - Kustomize
```bash
# Aplicar todo con Kustomize
kubectl apply -k parte10/base/

# Verificar configuración completa
kubectl apply -k parte10/completo/
```

## 🔧 Comandos Útiles

### Validación Completa
```bash
# Ejecutar validación completa
chmod +x validaciones/validate-lab.sh
./validaciones/validate-lab.sh
```

### Limpieza
```bash
# Eliminar todo el namespace
kubectl delete namespace lab-kubernetes

# Eliminar recursos específicos
kubectl delete deployment deploy-a
kubectl delete service service-a
```

### Debugging
```bash
# Ver eventos del namespace
kubectl get events --sort-by='.lastTimestamp'

# Ver logs de todos los pods
kubectl logs -l app=deploy-a

# Describir recursos
kubectl describe deployment deploy-a
kubectl describe service service-a
```

### Monitoreo
```bash
# Ver recursos en tiempo real
kubectl get pods -w
kubectl get hpa -w

# Ver métricas de CPU
kubectl top pods
```

## ⚠️ Notas Importantes

1. **Imagen**: La aplicación usa `gova731/dockerlab:3.0` que corre en puerto 8085 por defecto
2. **Puerto**: Se configura para usar puerto 8089 mediante variable de entorno
3. **Endpoint**: `/prueba` responde con HTTP 200 OK y JSON
4. **Namespace**: Todo se ejecuta en `lab-kubernetes`
5. **Escalado**: HPA configurado para escalar entre 1-3 pods con 50% CPU
6. **Orden**: Las partes 7 y 8 van antes que la 9 para mantener secuencia lógica
7. **Archivos**: Usar archivos `-base.yaml` para trabajar, `-completo.yaml` para comparar

## 🎓 Conceptos Aprendidos

- **Deployments**: Gestión declarativa de aplicaciones
- **Services**: Exposición de servicios internos y externos
- **Probes**: Monitoreo de salud de aplicaciones
- **ConfigMaps**: Configuración externa de aplicaciones
- **HPA**: Escalado automático basado en métricas
- **Microservicios**: Comunicación entre servicios
- **CronJobs**: Automatización de tareas programadas
- **Blue/Green**: Estrategias de despliegue sin downtime
- **Kustomize**: Gestión de configuraciones declarativas

## 🆘 Solución de Problemas

### Pod no inicia
```bash
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

### Service no responde
```bash
kubectl get endpoints
kubectl describe service <service-name>
```

### HPA no escala
```bash
kubectl describe hpa
kubectl top pods
```

### ConfigMap no se aplica
```bash
kubectl get configmap
kubectl describe pod <pod-name> | grep -A 10 Environment
``` 