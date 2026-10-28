plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.amrsoliman.cardguardian"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    defaultConfig {
        applicationId = "com.amrsoliman.cardguardian"
        minSdk = 24
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // personal: sideloaded build that may read SMS (never uploaded to Play).
    // play: store build that reads bank notifications instead of SMS.
    flavorDimensions += "channel"
    productFlavors {
        create("personal") {
            dimension = "channel"
            applicationIdSuffix = ".personal"
        }
        create("play") {
            dimension = "channel"
        }
    }

    signingConfigs {
        // Set CG_KEYSTORE_PATH (+ passwords) to sign with your own key, so new
        // builds install over old ones without losing data. Without it, the
        // debug key is used.
        val keystore = System.getenv("CG_KEYSTORE_PATH")
        if (!keystore.isNullOrBlank()) {
            create("release") {
                storeFile = file(keystore)
                storePassword = System.getenv("CG_KEYSTORE_PASSWORD")
                keyAlias = System.getenv("CG_KEY_ALIAS")
                keyPassword = System.getenv("CG_KEY_PASSWORD")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.findByName("release") ?: signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    implementation("androidx.core:core-ktx:1.15.0")
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
