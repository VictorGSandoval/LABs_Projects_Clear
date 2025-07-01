#!/bin/bash

echo "🔄 Iniciando switch de Blue (v1) a Green (v2)..."

# Paso 1: Escalar Green deployment a 1 réplica
echo "📈 Escalando Green deployment (v2) a 1 réplica..."
kubectl scale deployment deploy-a-v2 --replicas=1

# Paso 2: Esperar a que Green esté listo
echo "⏳ Esperando a que Green deployment esté listo..."
kubectl wait --for=condition=ready pod -l app=deploy-a,version=v2 --timeout=120s

# Paso 3: Verificar que Green responde
echo "🔍 Verificando que Green deployment responde..."
kubectl exec -it $(kubectl get pods -l app=deploy-a,version=v2 -o jsonpath='{.items[0].metadata.name}') -- curl -f http://localhost:8089/prueba

if [ $? -eq 0 ]; then
    echo "✅ Green deployment responde correctamente"
else
    echo "❌ Green deployment no responde. Abortando switch."
    exit 1
fi

# Paso 4: Cambiar selector del service a Green
echo "🔄 Cambiando selector del service a Green (v2)..."
kubectl patch service service-a -p '{"spec":{"selector":{"version":"v2"}}}'

# Paso 5: Verificar que el service apunta a Green
echo "🔍 Verificando que el service apunta a Green..."
kubectl get service service-a -o yaml | grep -A 5 selector

# Paso 6: Probar acceso externo
echo "🌐 Probando acceso externo..."
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="ExternalIP")].address}')
if [ -z "$NODE_IP" ]; then
  NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
fi

curl -v http://$NODE_IP:30009/prueba

# Paso 7: Escalar Blue deployment a 0 réplicas
echo "📉 Escalando Blue deployment (v1) a 0 réplicas..."
kubectl scale deployment deploy-a-v1 --replicas=0

echo "✅ Switch completado exitosamente!"
echo "🎯 Green (v2) está ahora activo y Blue (v1) está escalado a 0" 