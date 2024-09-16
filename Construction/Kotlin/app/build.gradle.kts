plugins {
    id("com.android.application")
    id("kotlin-android")
}

android {
    namespace = "com.example.test"
    compileSdk = 34
    defaultConfig {
        minSdk = 21
    }
}

dependencies {
    implementation 'androidx.core:core-ktx:1.3.2'
    implementation "org.jetbrains.kotlin:kotlin-stdlib:$kotlin_version"
}
