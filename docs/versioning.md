# NoobMod Versioning

This fork uses its own versioning, independent from upstream tags.

## Source of truth

Default values are in gradle.properties:
- infipd.versionName
- infipd.versionCode

They are consumed in build.gradle for all targets.

## Format recommendation

- versionName: InfinitePD NoobMod MAJOR.MINOR.PATCH - based on InfinitePD A.B.CSUFFIX
- versionCode: monotonically increasing integer

Rules for MAJOR.MINOR.PATCH:
- PATCH (z): bug fixes
- MINOR (y): feature changes
- MAJOR (x): major rewrites/full releases

Current defaults:
- versionName: InfinitePD NoobMod 0.1.2 - based on InfinitePD 0.1.9d
- versionCode: 1000102

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
$env:INFIPD_VERSION_NAME = "InfinitePD NoobMod 0.1.2 - based on InfinitePD 0.1.9d"
$env:INFIPD_VERSION_CODE = "1000102"
./gradlew desktop:release
```

Environment variables take precedence over gradle.properties values.
