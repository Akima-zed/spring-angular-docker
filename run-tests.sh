#!/bin/bash
# Script de tests unifié pour Spring Boot
# Génère un rapport JUnit XML dans test-results/

set -e  # Arrête le script si une commande échoue

echo "=========================================="
echo "🧪 Lancement des tests Spring Boot"
echo "=========================================="

# Nettoyer les anciens rapports
echo "🧹 Nettoyage des anciens rapports..."
rm -rf test-results/
mkdir -p test-results/

# Vérifier que Java est installé
if ! command -v java &> /dev/null; then
    echo "❌ Erreur : Java n'est pas installé"
    exit 1
fi

echo "✅ Java version: $(java -version 2>&1 | head -n 1)"

# Rendre gradlew exécutable
chmod +x gradlew

# Lancer les tests avec Gradle
echo ""
echo "🧪 Exécution des tests Spring Boot..."
./gradlew clean test --no-daemon 2>&1 | tee test-results/test-output.log

# Copier les rapports JUnit générés par Gradle
echo ""
echo "📋 Copie des rapports JUnit..."
if [ -d "build/test-results/test" ]; then
    cp -r build/test-results/test/*.xml test-results/ 2>/dev/null || true
    echo "✅ Rapports copiés dans test-results/"
else
    echo "⚠️  Aucun rapport trouvé dans build/test-results/test/"
fi

# Afficher un résumé
echo ""
echo "📊 Résumé des tests :"
if ls test-results/*.xml 1> /dev/null 2>&1; then
    for file in test-results/*.xml; do
        echo "  - $(basename "$file")"
    done
else
    echo "  Aucun fichier XML trouvé"
fi

echo ""
echo "=========================================="
echo "✅ Tests terminés avec succès"
echo "=========================================="

exit 0
