import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    //id("org.jetbrains.kotlin.jvm")
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
    testOptions {
        unitTests.all {
            //useJUnitPlatform()
        }
    }
}

dependencies {
    testImplementation(platform("org.junit:junit-bom:5.11.0"))
    testImplementation("org.junit.jupiter:junit-jupiter")
    testRuntimeOnly("org.junit.platform:junit-platform-launcher")
}

//tasks.named<Test>("test") {
//    useJUnitPlatform()
//}
