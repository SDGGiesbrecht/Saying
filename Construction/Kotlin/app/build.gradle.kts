plugins {
    id("com.android.application")
}

android {
    namespace = "com.example.test"
    compileSdk = 34
    defaultConfig {
        minSdk = 21
    }
}

test {
    useJUnitPlatform()
}
