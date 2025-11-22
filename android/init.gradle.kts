// Gradle init script to fix isar_flutter_libs namespace issue
allprojects {
    afterEvaluate {
        if (project.name == "isar_flutter_libs") {
            extensions.findByType(com.android.build.gradle.LibraryExtension::class.java)?.apply {
                namespace = "dev.isar.isar_flutter_libs"
            }
        }
    }
}
