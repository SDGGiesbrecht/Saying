plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "com.example.test"
    compileSdk = 34
    defaultConfig {
        minSdk = 21
    }
}

dependencies {
    implementation('org.jetbrains.kotlin:kotlin-stdlib:1.3.31')
    testImplementation(
        'org.assertj:assertj-core:3.12.2',
        'org.junit.jupiter:junit-jupiter-api:5.4.2'
    )
    testRuntime('org.junit.jupiter:junit-jupiter-engine:5.4.2')
}

test {
    useJUnitPlatform()
}
