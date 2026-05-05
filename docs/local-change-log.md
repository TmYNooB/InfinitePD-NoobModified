# Local Change Log (Upstream-Safe)

Purpose: Track every local gameplay/code change so upstream updates can be merged without losing custom behavior.

## Rules
- Add one entry for every non-trivial code change before finishing work.
- Reference commit hash when available.
- List exact files changed.
- Describe gameplay impact and merge risk.

## Entries

### 2026-05-05 - commit 0404c886e
- Title: Balance changes (loot, leveling, scroll thresholds)
- Files:
  - core/src/main/java/com/shatteredpixel/shatteredpixeldungeon/actors/hero/Hero.java
  - core/src/main/java/com/shatteredpixel/shatteredpixeldungeon/items/PsycheChest.java
  - core/src/main/java/com/shatteredpixel/shatteredpixeldungeon/actors/mobs/*.java (multiple mob lootChance fields)
- Changes:
  - Global loot multiplier changed from 2f to 4f.
  - Level-up formula changed from 20 + 20*lvl to 1 + 1*lvl (including challenge branch).
  - Scroll thresholds fixed to constants: upgrade=10, transmutation=15.
  - Base mob loot chances multiplied by factor 3.
- Gameplay impact:
  - Much faster progression and significantly increased drop frequency.
- Upstream merge risk:
  - Medium/high in Hero.java, PsycheChest.java, and mob constructors with lootChance assignments.

### 2026-05-06 - local changes (not yet committed)
- Title: Remove hero level scaling from boss strength
- Files:
  - core/src/main/java/com/shatteredpixel/shatteredpixeldungeon/Dungeon.java
  - core/src/main/java/com/shatteredpixel/shatteredpixeldungeon/actors/mobs/Mob.java
  - core/src/main/java/com/shatteredpixel/shatteredpixeldungeon/actors/mobs/BlackMimic.java
- Changes:
  - Removed hero.lvl factor from getCycleMultiplier.
  - bossMulti() now returns 0 (no hero.lvl bonus for boss HP multiplier).
  - BlackMimic scaling switched from hero.lvl to Dungeon.escalatingDepth().
- Gameplay impact:
  - Boss stats no longer inflate with player level; scaling is now cycle/depth driven.
- Upstream merge risk:
  - High in Dungeon.java and Mob.java due to shared/global scaling methods.

### 2026-05-06 - local changes (not yet committed)
- Title: Portable Android APK signing setup for multi-PC development
- Files:
  - android/build.gradle
  - .gitignore
  - android/keystore.properties.example
  - docs/android-signing-setup.md
- Changes:
  - Added release signing config that reads credentials from env vars or local android/keystore.properties.
  - Added keystore/secrets ignore rules to git.
  - Added example signing properties file and setup documentation.
- Gameplay impact:
  - None (build/release pipeline only).
- Upstream merge risk:
  - Medium in android/build.gradle (build script structure may diverge upstream).

## Entry Template
### YYYY-MM-DD - commit <hash or "local changes">
- Title: <short name>
- Files:
  - <path>
- Changes:
  - <what changed>
- Gameplay impact:
  - <player-facing effect>
- Upstream merge risk:
  - <low/medium/high + why>
