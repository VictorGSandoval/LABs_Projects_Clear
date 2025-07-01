# Parte 5: HPA (Horizontal Pod Autoscaler)

## 🎯 Objetivo
Configurar el escalado automático horizontal (HPA) para el deployment `deploy-a` usando el uso de CPU.

## Archivos
- `hpa-base.yaml`: Archivo base para completar (formato simple, con TODOs)
- `hpa-completo.yaml`: Solución completa para comparar

## Pasos a Seguir

1. **Editar el archivo base:**
   - Abre `hpa-base.yaml` y completa los TODOs según las instrucciones.
   - Define el rango de réplicas y el porcentaje de CPU.

2. **Aplicar el HPA:**
   ```bash
   kubectl apply -f hpa-base.yaml
   ```

3. **Verificar el HPA:**
   ```bash
   kubectl get hpa
   kubectl describe hpa deploy-a-hpa
   ```

4. **Generar carga para probar el escalado:**
   ```bash
   kubectl exec -it <pod-name> -- yes > /dev/null &
   kubectl get pods -w
   ```

## Validaciones

- El HPA debe aparecer con el rango de réplicas y el target de CPU configurado.
- El deployment debe escalar cuando la CPU supere el target.

## Ejemplo de HPA básico (solución):
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: deploy-a-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: deploy-a
  minReplicas: 1
  maxReplicas: 3
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50
```

## Notas
- El archivo base es lo más simple posible, solo con los campos esenciales y TODOs.
- El archivo completo tiene todos los parámetros y explicación.
- Puedes comparar tu solución con el archivo completo si tienes dudas.

## 🎯 Beneficios del HPA

### 1. **Escalado Automático**
- Se adapta automáticamente a la carga
- No requiere intervención manual

### 2. **Optimización de Recursos**
- Usa solo los recursos necesarios
- Reduce costos en períodos de baja carga

### 3. **Alta Disponibilidad**
- Mantiene el rendimiento durante picos de carga
- Evita timeouts y errores por sobrecarga

### 4. **Monitoreo Proactivo**
- Detecta patrones de uso
- Permite planificación de capacidad

## 🔧 Comandos Útiles

### Limpiar carga
```bash
# Eliminar job de carga
kubectl delete job load-generator

# Detener procesos de carga
kubectl exec -it $(kubectl get pods -l app=deploy-a -o jsonpath='{.items[0].metadata.name}') -- pkill -f "yes\|curl"
```

### Ver historial de escalado
```bash
# Ver eventos del HPA
kubectl get events --sort-by='.lastTimestamp' | grep -i hpa

# Ver logs del metrics-server
kubectl logs -n kube-system deployment/metrics-server
```

## ⚠️ Consideraciones

- **Metrics Server**: Debe estar instalado para que el HPA funcione
- **Recursos**: Los pods deben tener requests y limits definidos
- **Latencia**: Hay un retraso entre el cambio de carga y el escalado
- **Costos**: El escalado automático puede aumentar costos durante picos 