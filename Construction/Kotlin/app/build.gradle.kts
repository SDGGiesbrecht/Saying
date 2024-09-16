plugins {
    id("com.android.application")
    id("kotlin-android")
}

kotlin {
    jvmToolchain(11)
}

android {
    namespace = "com.example.test"
    compileSdk = 34
    defaultConfig {
        minSdk = 21
    }
}

dependencies {
    testImplementation("org.junit.jupiter:junit-jupiter:5.7.1")
    testRuntimeOnly("org.junit.platform:junit-platform-launcher")
}
