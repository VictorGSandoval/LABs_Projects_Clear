# PARTE 6: BLUE/GREEN DEPLOYMENT

## Objetivo
Implementar una estrategia de despliegue Blue/Green que permita actualizaciones sin tiempo de inactividad.

## Conceptos Clave

### Blue/Green Deployment
- **Blue**: Versión actual en producción (activa)
- **Green**: Nueva versión preparada (inactiva)
- **Switch**: Cambio de tráfico de Blue a Green
- **Rollback**: Cambio de tráfico de Green a Blue

### Ventajas
1. **Zero Downtime**: Sin tiempo de inactividad
2. **Rollback Rápido**: Cambio instantáneo
3. **Testing**: Validación completa antes del switch
4. **Simplicidad**: Lógica de routing simple

## Archivos

### `deployment-base.yaml`
Archivo base con TODOs para completar en clase:
- Configuración de deployments Blue y Green
- Service con selector configurable
- Estructura mínima para aprendizaje

### `deployment-completo.yaml`
Solución completa con:
- Blue deployment (v1) activo con 1 réplica
- Green deployment (v2) inactivo con 0 réplicas
- Service apuntando a Blue por defecto
- Configuración completa de recursos y probes

### `switch-to-green.sh`
Script para cambiar de Blue a Green:
- Escala Green a 1 réplica
- Cambia selector del service
- Escala Blue a 0 réplicas
- Validación de salud

## Comandos de Uso

```bash
# Aplicar configuración base
kubectl apply -f deployment-base.yaml

# Aplicar configuración completa
kubectl apply -f deployment-completo.yaml

# Ejecutar switch a Green
chmod +x switch-to-green.sh
./switch-to-green.sh

# Verificar estado
kubectl get deployments
kubectl get services
kubectl get pods
```

## Flujo de Trabajo

1. **Preparación**: Green deployment con 0 réplicas
2. **Testing**: Validar Green deployment
3. **Switch**: Cambiar tráfico a Green
4. **Validación**: Confirmar funcionamiento
5. **Limpieza**: Eliminar Blue deployment (opcional)

## Consideraciones

- **Recursos**: Necesita el doble de recursos durante el switch
- **Base de Datos**: Requiere migración de datos
- **Configuración**: Variables de entorno y ConfigMaps
- **Monitoreo**: Health checks y métricas 