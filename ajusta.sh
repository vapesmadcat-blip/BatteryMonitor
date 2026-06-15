#!/data/data/com.termux/files/usr/bin/bash

set -e

echo "======================================="
echo " CORREÇÃO AUTOMÁTICA BATTERY MONITOR"
echo "======================================="

if [ ! -d "app" ]; then
    echo "ERRO: execute dentro da raiz do projeto."
        exit 1
        fi
        
        echo ""
        echo "Criando backups..."
        
        find app -name "*.kt" -exec cp {} {}.bak \;
        find app -name "*.xml" -exec cp {} {}.bak \;
        find . -name "*.gradle" -exec cp {} {}.bak \;
        
        echo "Backups criados."
        
        echo ""
        echo "Procurando build.gradle..."
        
        GRADLE_FILE=$(find . -name "build.gradle" | grep "/app/" | head -n 1)
        
        if [ -n "$GRADLE_FILE" ]; then
        
            sed -i \
                    "s/namespace *= *['\"][^'\"]*['\"]/namespace = 'com.example.batterymonitor'/g" \
                            "$GRADLE_FILE"
                            
                                sed -i \
                                        "s/applicationId *= *['\"][^'\"]*['\"]/applicationId = \"com.example.batterymonitor\"/g" \
                                                "$GRADLE_FILE"
                                                
                                                    echo "Namespace corrigido."
                                                    fi
                                                    
                                                    echo ""
                                                    echo "Corrigindo drawable inexistente..."
                                                    
                                                    find app -name "*.kt" -exec sed -i \
                                                    's/ic_lock_idle_battery_charging/ic_dialog_info/g' {} \;
                                                    
                                                    echo "Drawable corrigido."
                                                    
                                                    echo ""
                                                    echo "Localizando strings.xml..."
                                                    
                                                    STRINGS=$(find app -name strings.xml | head -n 1)
                                                    
                                                    if [ -n "$STRINGS" ]; then
                                                    
                                                        grep -q "notification_channel_name" "$STRINGS" || sed -i \
                                                        '/<\/resources>/i\
                                                        <string name="notification_channel_name">Battery Monitor</string>\
                                                        <string name="notification_title">Battery Monitor</string>\
                                                        <string name="notification_text">Monitorando bateria</string>' \
                                                        "$STRINGS"
                                                        
                                                            echo "Strings adicionadas."
                                                            fi
                                                            
                                                            echo ""
                                                            echo "Localizando AndroidManifest.xml..."
                                                            
                                                            MANIFEST=$(find app -name AndroidManifest.xml | head -n 1)
                                                            
                                                            if [ -n "$MANIFEST" ]; then
                                                            
                                                                grep -q "BatteryMonitorService" "$MANIFEST" || sed -i \
                                                                '/<\/application>/i\
                                                                <service\
                                                                    android:name=".BatteryMonitorService"\
                                                                        android:exported="false"\
                                                                            android:foregroundServiceType="dataSync" />' \
                                                                            "$MANIFEST"
                                                                            
                                                                                grep -q "MainActivity" "$MANIFEST" || sed -i \
                                                                                '/<\/application>/i\
                                                                                <activity\
                                                                                    android:name=".MainActivity"\
                                                                                        android:exported="true">\
                                                                                        <intent-filter>\
                                                                                        <action android:name="android.intent.action.MAIN"/>\
                                                                                        <category android:name="android.intent.category.LAUNCHER"/>\
                                                                                        </intent-filter>\
                                                                                        </activity>' \
                                                                                        "$MANIFEST"
                                                                                        
                                                                                            echo "Manifest atualizado."
                                                                                            fi
                                                                                            
                                                                                            echo ""
                                                                                            echo "Verificando pacotes Kotlin..."
                                                                                            
                                                                                            grep -R "package com.vapesmadcat.monitorbatt" app/src/main/java >/dev/null 2>&1 && {
                                                                                            
                                                                                                find app/src/main/java -name "*.kt" -exec sed -i \
                                                                                                's/package com.vapesmadcat.monitorbatt/package com.example.batterymonitor/g' {} \;
                                                                                                
                                                                                                    echo "Pacotes Kotlin ajustados."
                                                                                                    }
                                                                                                    
                                                                                                    echo ""
                                                                                                    echo "======================================="
                                                                                                    echo " CORREÇÃO FINALIZADA"
                                                                                                    echo "======================================="
                                                                                                    echo ""
                                                                                                    echo "Agora execute:"
                                                                                                    echo ""
                                                                                                    echo "./gradlew assembleDebug"
                                                                                                    echo ""
                                                                                                    