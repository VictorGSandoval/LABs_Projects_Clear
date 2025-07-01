#!/bin/bash

echo "🔍 VALIDACIÓN COMPLETA DEL LABORATORIO KUBERNETES"
echo "================================================"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Contadores
SUCCESSES=0
FAILURES=0

# Función para imprimir resultados
print_result() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✅ $2${NC}"
        ((SUCCESSES++))
    else
        echo -e "${RED}❌ $2${NC}"
        ((FAILURES++))
    fi
}

# Función para imprimir información
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Función para imprimir advertencia
print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

echo ""
print_info "Verificando namespace..."
kubectl get namespace lab-kubernetes > /dev/null 2>&1
print_result $? "Namespace lab-kubernetes existe"

echo ""
print_info "Verificando deployments..."
DEPLOY_A=$(kubectl get deployment deploy-a -n lab-kubernetes --no-headers 2>/dev/null | awk '{print $2}')
if [ "$DEPLOY_A" = "1/1" ]; then
    print_result 0 "Deployment deploy-a está funcionando (1/1)"
else
    print_result 1 "Deployment deploy-a no está funcionando correctamente ($DEPLOY_A)"
fi

DEPLOY_B=$(kubectl get deployment deploy-b -n lab-kubernetes --no-headers 2>/dev/null | awk '{print $2}')
if [ "$DEPLOY_B" = "1/1" ]; then
    print_result 0 "Deployment deploy-b está funcionando (1/1)"
else
    print_result 1 "Deployment deploy-b no está funcionando correctamente ($DEPLOY_B)"
fi

echo ""
print_info "Verificando services..."
SERVICE_A=$(kubectl get service service-a -n lab-kubernetes --no-headers 2>/dev/null | awk '{print $5}')
if [ "$SERVICE_A" = "8089:30009/TCP" ]; then
    print_result 0 "Service service-a está configurado correctamente"
else
    print_result 1 "Service service-a no está configurado correctamente ($SERVICE_A)"
fi

SERVICE_B=$(kubectl get service service-b -n lab-kubernetes --no-headers 2>/dev/null | awk '{print $5}')
if [ "$SERVICE_B" = "8080/TCP" ]; then
    print_result 0 "Service service-b está configurado correctamente"
else
    print_result 1 "Service service-b no está configurado correctamente ($SERVICE_B)"
fi

echo ""
print_info "Verificando ConfigMap..."
CONFIGMAP=$(kubectl get configmap app-config -n lab-kubernetes --no-headers 2>/dev/null | awk '{print $2}')
if [ "$CONFIGMAP" = "3" ]; then
    print_result 0 "ConfigMap app-config existe con 3 variables"
else
    print_result 1 "ConfigMap app-config no existe o no tiene 3 variables ($CONFIGMAP)"
fi

echo ""
print_info "Verificando HPA..."
HPA=$(kubectl get hpa deploy-a-hpa -n lab-kubernetes --no-headers 2>/dev/null | awk '{print $6}')
if [ "$HPA" = "1" ]; then
    print_result 0 "HPA deploy-a-hpa está funcionando (1 réplica)"
else
    print_result 1 "HPA deploy-a-hpa no está funcionando correctamente ($HPA réplicas)"
fi

echo ""
print_info "Verificando CronJob..."
CRONJOB=$(kubectl get cronjob health-check-cronjob -n lab-kubernetes --no-headers 2>/dev/null | awk '{print $2}')
if [ "$CRONJOB" = "*/1 * * * *" ]; then
    print_result 0 "CronJob health-check-cronjob está configurado (cada minuto)"
else
    print_result 1 "CronJob health-check-cronjob no está configurado correctamente ($CRONJOB)"
fi

echo ""
print_info "Verificando pods..."
PODS=$(kubectl get pods -n lab-kubernetes --no-headers 2>/dev/null | grep Running | wc -l)
if [ $PODS -ge 2 ]; then
    print_result 0 "Pods están ejecutándose ($PODS pods Running)"
else
    print_result 1 "No hay suficientes pods ejecutándose ($PODS pods Running)"
fi

echo ""
print_info "Verificando conectividad entre servicios..."
# Obtener un pod de deploy-b para probar conectividad
POD_B=$(kubectl get pods -n lab-kubernetes -l app=deploy-b --no-headers 2>/dev/null | head -1 | awk '{print $1}')
if [ -n "$POD_B" ]; then
    kubectl exec -n lab-kubernetes $POD_B -- wget -q -O- http://service-a:8089/prueba > /dev/null 2>&1
    print_result $? "Conectividad entre Service B y Service A"
else
    print_result 1 "No se pudo encontrar pod de deploy-b para probar conectividad"
fi

echo ""
print_info "Verificando acceso externo..."
# Obtener IP del nodo
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="ExternalIP")].address}' 2>/dev/null)
if [ -z "$NODE_IP" ]; then
    NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}' 2>/dev/null)
fi

if [ -n "$NODE_IP" ]; then
    curl -s -o /dev/null -w "%{http_code}" http://$NODE_IP:30009/prueba | grep -q "200"
    print_result $? "Acceso externo al Service A (NodePort 30009)"
else
    print_warning "No se pudo obtener IP del nodo para probar acceso externo"
fi

echo ""
print_info "Verificando logs del Service B..."
POD_B=$(kubectl get pods -n lab-kubernetes -l app=deploy-b --no-headers 2>/dev/null | head -1 | awk '{print $1}')
if [ -n "$POD_B" ]; then
    kubectl logs -n lab-kubernetes $POD_B --tail=5 | grep -q "conexión exitosa"
    print_result $? "Service B muestra logs de conexión exitosa"
else
    print_result 1 "No se pudo verificar logs del Service B"
fi

echo ""
print_info "Verificando jobs del CronJob..."
JOBS=$(kubectl get jobs -n lab-kubernetes --no-headers 2>/dev/null | wc -l)
if [ $JOBS -gt 0 ]; then
    print_result 0 "CronJob ha creado jobs ($JOBS jobs encontrados)"
else
    print_warning "CronJob aún no ha creado jobs (puede ser normal si acaba de aplicarse)"
fi

echo ""
echo "================================================"
print_info "RESUMEN DE VALIDACIÓN"
echo "================================================"

echo -e "${GREEN}Éxitos: $SUCCESSES${NC}"
echo -e "${RED}Fallos: $FAILURES${NC}"

if [ $FAILURES -eq 0 ]; then
    echo ""
    echo -e "${GREEN}🎉 ¡FELICITACIONES! El laboratorio está funcionando correctamente.${NC}"
else
    echo ""
    echo -e "${YELLOW}⚠️  Hay algunos problemas que necesitan atención.${NC}"
    echo "Revisa los fallos arriba y consulta los README de cada parte."
fi

echo ""
print_info "Comandos útiles para debugging:"
echo "  kubectl get all -n lab-kubernetes"
echo "  kubectl logs -n lab-kubernetes -l app=deploy-a"
echo "  kubectl logs -n lab-kubernetes -l app=deploy-b"
echo "  kubectl get events -n lab-kubernetes --sort-by='.lastTimestamp'" 