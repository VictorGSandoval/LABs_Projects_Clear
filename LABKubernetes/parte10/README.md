# PARTE 10: KUSTOMIZE

## Objetivo
Utilizar Kustomize para gestionar configuraciones de Kubernetes de manera declarativa y reutilizable.

## Conceptos Clave

### Kustomize
- **Gestión de Configuración**: Declarativa y versionada
- **Reutilización**: Base común con overlays
- **Personalización**: Entornos específicos
- **Simplicidad**: Sin templates complejos

### Ventajas
1. **Declarativo**: Configuración como código
2. **Reutilizable**: Base común para múltiples entornos
3. **Versionado**: Control de cambios
4. **Simplicidad**: Sintaxis YAML estándar

## Estructura

### `base/`
Configuración base con TODOs:
- `kustomization.yaml`: Archivo principal con recursos comentados
- Evoluciona conforme avanzas en el laboratorio

### `completo/`
Solución completa:
- `kustomization.yaml`: Configuración completa con todos los recursos
- Incluye todas las partes del laboratorio

## Evolución por Partes

```yaml
# Parte 1: Solo namespace
resources:
  - ../parte1/namespace-completo.yaml

# Parte 2: + deployment y service
resources:
  - ../parte1/namespace-completo.yaml
  - ../parte2/deployment-completo.yaml

# Parte 3: + health checks
resources:
  - ../parte1/namespace-completo.yaml
  - ../parte2/deployment-completo.yaml
  - ../parte3/deployment-completo.yaml

# Y así sucesivamente hasta la parte 9...
```

## Comandos de Uso

```bash
# Aplicar configuración base
kubectl apply -k base/

# Aplicar configuración completa
kubectl apply -k completo/

# Previsualizar cambios
kubectl diff -k base/

# Construir sin aplicar
kubectl kustomize base/
```

## Características

### Configuraciones Comunes
- **Labels**: project, environment, version
- **Namespace**: lab-kubernetes
- **Imágenes**: Versiones específicas

### Recursos Incluidos
1. Namespace del laboratorio
2. Deployment y Service
3. Health checks y probes
4. ConfigMap y variables
5. HPA para escalado
6. Microservicio cliente
7. CronJob para monitoreo
8. Blue/Green deployment

## Beneficios

- **Consistencia**: Configuración uniforme
- **Mantenimiento**: Cambios centralizados
- **Entornos**: Desarrollo, staging, producción
- **Colaboración**: Configuración compartida 