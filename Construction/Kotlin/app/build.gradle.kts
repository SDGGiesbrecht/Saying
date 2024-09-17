import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    kotlin("jvm") version "2.0.20"
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
    testImplementation(platform("org.junit:junit-bom:5.11.0"))
    testImplementation("org.junit.jupiter:junit-jupiter")
    testRuntimeOnly("org.junit.platform:junit-platform-launcher")
}

tasks.named<Test>("test") {
    useJUnitPlatform()
}
