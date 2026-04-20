import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("flavor-type")

    productFlavors {
        create("development") {
            dimension = "flavor-type"
            applicationId = "com.example.myapp.dev"
            resValue(type = "string", name = "app_name", value = "MyApp Dev")
        }
        create("staging") {
            dimension = "flavor-type"
            applicationId = "com.example.myapp.staging"
            resValue(type = "string", name = "app_name", value = "MyApp Staging")
        }
        create("production") {
            dimension = "flavor-type"
            applicationId = "com.example.myapp"
            resValue(type = "string", name = "app_name", value = "MyApp")
        }
    }
}