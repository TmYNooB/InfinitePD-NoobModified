# NoobMod Versioning

This fork uses its own versioning, independent from upstream tags.

## Source of truth

Default values are in gradle.properties:
- infipd.versionName
- infipd.versionCode

They are consumed in build.gradle for all targets.

## Format recommendation

- versionName: NoobMod-MAJOR.MINOR.PATCH
- versionCode: monotonically increasing integer

Current defaults:
- versionName: NoobMod-0.1.0
- versionCode: 1000100

## Bump procedure

1. Edit gradle.properties:
   - infipd.versionName
   - infipd.versionCode
2. Commit both code changes and version bump together.
3. Build artifacts:
   - ./gradlew desktop:release
   - ./gradlew android:assembleRelease

## Per-machine override (optional)

You can override without changing files:
- INFIPD_VERSION_NAME
- INFIPD_VERSION_CODE

PowerShell example:

```powershell
$env:INFIPD_VERSION_NAME = "NoobMod-0.1.1"
$env:INFIPD_VERSION_CODE = "1000101"
./gradlew desktop:release
```

Environment variables take precedence over gradle.properties values.
