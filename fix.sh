#!/usr/bin/env bash

set -e

echo "[1/5] settings.gradle"

cat > settings.gradle <<'EOF'
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)

    repositories {
        google()
        mavenCentral()
    }
}

rootProject.name = "BatteryMonitor"
include(":app")
EOF

echo "[2/5] build.gradle (raiz)"

cat > build.gradle <<'EOF'
plugins {
    id 'com.android.application' version '8.2.2' apply false
    id 'org.jetbrains.kotlin.android' version '1.9.22' apply false
}
EOF

echo "[3/5] app/build.gradle"

mkdir -p app

cat > app/build.gradle <<'EOF'
plugins {
    id 'com.android.application'
    id 'org.jetbrains.kotlin.android'
}

android {
    namespace 'com.example.batterymonitor'

    compileSdk 34

    defaultConfig {
        applicationId "com.example.batterymonitor"
        minSdk 21
        targetSdk 34

        versionCode 1
        versionName "1.0"
    }

    buildTypes {
        release {
            minifyEnabled false
        }
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = '17'
    }
}

dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib:1.9.22"
}
EOF

echo "[4/5] gradle-wrapper.properties"

mkdir -p gradle/wrapper

cat > gradle/wrapper/gradle-wrapper.properties <<'EOF'
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-8.2-bin.zip
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
EOF

echo "[5/5] .github/workflows/build.yml"

mkdir -p .github/workflows

cat > .github/workflows/build.yml <<'EOF'
name: Build APK

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Set up JDK 17
        uses: actions/setup-java@v4
        with:
          distribution: temurin
          java-version: '17'

      - name: Setup Android SDK
        uses: android-actions/setup-android@v3

      - name: Make gradlew executable
        run: chmod +x gradlew

      - name: Build Debug APK
        run: ./gradlew assembleDebug

      - name: Upload APK
        uses: actions/upload-artifact@v4
        with:
          name: BatteryMonitor-debug
          path: app/build/outputs/apk/debug/app-debug.apk
EOF

echo
echo "Configurações atualizadas."
echo "Agora execute:"
echo
echo "  ./gradlew assembleDebug"
echo