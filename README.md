# QuiltMC 1.20.1 Generator (Lightseeking build)
## First community-built Quilt 1.20.1 code generator for MCreator

> **⚠️ WARNING: This generator is currently in active development. We make NO stability guarantees whatsoever.**
> Before shipping a production / large mod, please run a full end-to-end regression test for every element type you use, in a clean workspace. Always keep backups of your workspace `.mcr` file plus the generated `src/` and `build/` trees.

Pylo / MCreator has **never shipped an official Quilt 1.20.1 generator**
out of the box. This project is the
**first community implementation to bring a complete Quilt 1.20.1 code
generator online** for MCreator 2026.1 — covering every piece: all
FreeMarker templates, all `*.definition.yaml` element schemas, the
entire Gradle workspace base (Quilt repositories, wrapper, resource
pipeline), and every Quilt lifecycle listener / Mixin shim needed to
match the trigger semantics that MCreator users expect from the official
Java generators.

This is **not** "a quick patch over some pre-existing buggy official
quilt generator" — because that official quilt generator simply never
existed. The way we built this generator is:
**template-by-template, we take two official MCreator Java generators as
our semantic reference, then manually port every definition, every
FreeMarker macro, and every element-init invocation over onto the Quilt /
Quilted Fabric API / Mixin toolchain.**

The two reference generators used as the source of truth (note: we only
copy their *behavior / schema / macro shape* — no binary copy of any
Forge or NeoForge runtime is ever included in this plugin):

- **Forge 1.20.1 Generator** `generator-1.20.1` v1.5 by _Spectrall
  → the reference for **1.20.1-specific definition field semantics,
  `mapto` aliases, `localizationkeys` shapes, worldgen JSON structure,
  the plural `structures_dir` resource layout**, and so on.
- **Minecraft 1.21.1 Java Edition generator** `generator-1.21.1`
  (NeoForge 1.21.1, built into MCreator 2026.1 by Pylo)
  → the reference for **upstream FreeMarker macro shapes, procedure
  branching shapes, the `mod.java` empty-class guard pattern, and
  element-init invocation order**, matching the most actively
  maintained Pylo upstream codebase layout.

Net result: every MCreator 2026.1 GUI element type that Forge users have
(Dimensions, Armor, Potion Effects, Item Extensions for fuel /
dispensers, Structures / Features, Living Entity AI Goals, the "give
entity an itemstack" procedure snippet, etc.) now works on Quilt 1.20.1
workspaces for the **first time ever** — generated, compiling, and
firing their triggers with the same visible semantics.

| Release tag | `DEV-4th-2026.8.15` |
|---|---|
| Generator version (from `plugin.json`) | `1.1.0-dev4` |
| Author | **htqkeku @ Lightseeking(FL) Studio** |
| License | GNU General Public License v3, **plus** the traditional
  MCreator *"Additional permission for code generator templates
  (\*.ftl files)"* clause. This explicitly means the mod code you
  write / generate in **your own workspace** is **not** a GPL
  derivative and can be licensed however you wish. See [LICENSE](LICENSE)
  for the full legal text. |
| Upstream boilerplate / comment copyrights | Pylo / MCreator open-source contributors; Pylo 2012–2020 (three-tier copyright notice preserved verbatim). |

---

## 📦 What this plugin actually is

This plugin registers and implements the **`quiltmc-1.20.1` generator
id** inside MCreator 2026.1. Because MCreator never had a built-in
generator with that id before, installing this plugin effectively
**adds a brand-new Quilt 1.20.1 workspace choice to MCreator**, rather
than "replacing" any existing option.

Implementing a complete generator from scratch means mapping every
MCreator element system onto Quilt's stack:

- **Definition YAML files** (armor / feature / structure / dimension /
  potioneffect …) match the Forge 1.20.1 generator's field names,
  `localizationkeys` key shapes, and `mapto` aliases. This way every
  GUI field you fill in the MCreator UI (armor descriptions, structure
  rotation toggles, potion trigger bindings, …) actually maps to a
  real Java / JSON / resource output.
- **Resource directory layout and naming conventions**
  (plural `structures_dir`, `lang/`, nested `textures/` folders, the
  complete `worldgen/` JSON hierarchy) match the Forge 1.20.1
  generator output semantics — because MCreator's resource mirroring,
  GUI previews, and workspace persistence logic are written against
  those same semantics. For example: the Minecraft Structure Template
  Manager hardcodes lookups into `structures/` (plural) and simply
  ignores any singular `structure/` directory.
- **FreeMarker macro branching, procedure snippet shapes, and the
  `mod.java` empty-class guard pattern** match Pylo's built-in
  NeoForge 1.21.1 generator — because that generator is the latest,
  most actively maintained upstream macro layout in MCreator's main
  branch.
- **Download URLs point exclusively at official upstream sources**
  (`maven.quiltmc.org`, `maven.fabricmc.net`,
  `maven.minecraftforge.net` for the datapack loader, `mavenCentral()`,
  `gradlePluginPortal()`, `services.gradle.org`). **No regional mirror
  is hardcoded anywhere.** This guarantees users outside mainland
  China get an out-of-the-box build with zero configuration changes.
  If you *do* need a faster mirror on a censored / slow network, use
  standard Gradle mechanisms (`GRADLE_OPTS`, a mirror-substitution
  script in `~/.gradle/init.gradle`, or per-workspace
  `gradle.properties` overrides — pick whichever you prefer).
- **Where Quilt / QFAPI has no one-to-one equivalent of a Forge /
  NeoForge mechanic that MCreator's UI exposes**, we plug the gap
  with thin Quilt lifecycle listeners and Mixins that deliver
  *equivalent semantics* at the exact same moment and with the exact
  same parameter bindings a Forge/NeoForge user would get. Notable
  examples:
  - Fuel "burn success condition evaluated every tick" (Fabric's
    static `FuelRegistry.INSTANCE` is just a `<Item, int>` map —
    cannot reject dynamically) → implemented as an
    `AbstractFurnaceBlockEntity.serverTick` Mixin (HEAD hides the
    fuel when the condition refuses; RETURN restores it within the
    same tick).
  - Player travels through a custom dimension portal (calling Quilt's
    `entity.changeDimension` directly throws a
    `DistantManager.removePlayer` NPE) → replaced with
    `ServerPlayer.teleportTo` + manual dimension event callback.
  - Potion "when effect expires" does not fire when the entity dies
    while still carrying the effect → hook
    `ServerLivingEntityEvents.AFTER_DEATH`, scan the dying entity for
    active effects, fire the expired callback for every match.

Install like any other MCreator generator plugin (see
[Installing](#-installing)), fully restart MCreator, and every new
Quilt 1.20.1 workspace you create will use this implementation.

---

## 🔧 Implementation cycles

Each "cycle" locks down one layer of the generator before moving to the
next. Cycle 1 → basic mod elements; Cycle 2 → global triggers;
Cycle 3 → per-element triggers for basic mod elements + detail polish;
Cycle 4 → licensing and release preparation.

| Cycle | Focus of the pass (high-level) | Notable deliverables landed in the pass |
|-------|---------------------------------|-----------------------------------------|
| **Cycle 1** | **Basic mod elements are mostly complete and functional.** | Custom dimensions (portal `DistantManager.removePlayer` NPE fix + enter/leave trigger wiring); Living Entity AI Goal `[Attack entity of type ()]` constructor shape + has-content guard; element-to-Java-class generation for base item / block / armor element types. |
| **Cycle 2** | **Global triggers are mostly complete and functional.** | Global trigger "When entity is struck by lightning" UUID-Set dedup via `LightningBolt` Mixin (fires exactly once per strike per entity); `mod.java` empty-class guard refactor so a zero-element workspace with only global triggers still compiles cleanly; global dimension-travel and player-hurt event wiring validated. |
| **Cycle 3** | **Triggers for basic mod elements + remaining details are mostly complete.** | Mob effect triggers: "When effect starts / is applied" dual-path trigger (`addAttributeModifiers` + `applyInstantenousEffect`), tick procedure correctly suppressed for `isInstant` effects, and "When effect expires" also invoked on entity death via `ServerLivingEntityEvents.AFTER_DEATH`; Item extension triggers: dispenser "attempt to dispense" hook + correct item-consume semantics (branch layout aligned to NeoForge 1.21.1), plus the dynamic per-tick fuel burn-success condition via `AbstractFurnaceBlockEntity` Mixin HEAD-hide / RETURN-restore; procedure snippet "Give entity an itemstack" ported from Forge-only `ItemHandlerHelper` to the vanilla `Player.getInventory().add()` + overflow-drop `ItemEntity` at feet pattern. |
| **Cycle 4** | **LICENSE / release metadata preparation.** | Three-tier GPLv3 COPYRIGHT NOTICE written and `LICENSE` file populated with full GPLv3 text + the MCreator `*.ftl` template-output exception; `plugin.json` author / version / description updated for the public release; Structure / Feature / worldgen end-to-end hardened (`StructureFeature` + `StructureFeatureConfiguration` templates written out with correct imports, `STRUCTURE_FEATURE` registered into `BuiltInRegistries.FEATURE`, built-in FreeMarker `featuretype` variable preserved, `structures_dir` plural set to match Structure Template Manager lookup paths, Gradle `processResources` `.nbt` mirror `data/*/structures → assets/*/structures`); Armor definition gains `description_@item_index` `localizationkeys` for all four armor pieces + `bodyName` `mapto` corrected; `workspacebase/build.gradle` UTF-8 no-BOM output guaranteed; Chinese + English `README.md` authored; BMCLAPI2 regional mirrors removed so international users get an all-official repository layout. |

For the per-file / per-template / per-line breakdown of every
definition, FreeMarker, and Mixin change, see [CHANGELOG.md](CHANGELOG.md).

---

## 🧪 Verified working elements & procedure triggers

The following categories and trigger points have been validated
end-to-end against the dual reference semantics:

- ✅ **Dimension → On player enters / leaves dimension** (portal-initiated path; uses `ServerPlayer.teleportTo` + manual dimension event callback so `DistantManager.removePlayer` NPE is avoided)
- ✅ **Entity → When entity is struck by lightning** (UUID-Set dedup in `LightningBolt` Mixin → fires exactly once per strike per entity)
- ✅ **Living Entity AI Task → `[Attack entity of type ()]`** (3-arg `NearestAttackableTargetGoal` constructor + has-content guard → no more `NullPointerException` when the target-type slot is empty / unconfigured)
- ✅ **Mob Effect → When effect starts / is applied** (dual-path: attribute attachment path + instant-enchant-style apply path; fires on the same tick as the reference generators)
- ✅ **Mob Effect → While active, every tick** (correctly **suppressed** for instant effects; tick procedure code is only generated when `hasProcedure(onActiveTick) && !isInstant`)
- ✅ **Mob Effect → When effect expires** (normal expiration / manual removal **plus** `ServerLivingEntityEvents.AFTER_DEATH` guard so a dying entity still gets the on-expired callback for effects it was carrying when it died — death unequips effects too)
- ✅ **Item Extension → Dispenser → When dispenser attempts to dispense** (hook fires before the item is consumed; branch layout matches NeoForge 1.21.1 upstream: if the procedure returns an ItemStack that's the output, otherwise the default shrink + normal eject path runs)
- ✅ **Procedure snippet → Give [entity] an [itemstack]** (dropped Forge-only `ItemHandlerHelper`; uses vanilla `Player.getInventory().add()` + spawns an overflow `ItemEntity` at the entity's feet)
- ✅ **Item Extension → Fuel → Burn success condition** (dynamic per-tick evaluation: `AbstractFurnaceBlockEntity.serverTick` Mixin HEAD check → if condition refuses, temporarily hide the fuel; RETURN restore — bypasses the static int-map limitation of `FuelRegistry`)
- ✅ **Feature (Structure) elements**, the entire chain: the generated Feature class compiles cleanly, the FEATURE is registered, the `configured_feature` JSON is generated correctly, plural `structures/` directory routing works, `.nbt` mirror task guarantees the Structure Block loads exactly the same `.nbt` template that worldgen Jigsaw pools point at
- ✅ **Armor element → Description line(s)**: `item.*.description_N` keys are emitted for each of the four armor slots and correctly bound to `fixedSpecialInformation` in the armor definition, producing identical output to the Forge 1.20.1 generator

---

## 💾 Installing

### 1. Close MCreator completely

`generator.yaml` and every `*.definition.yaml` file are read by MCreator
**exactly once, on startup.** You **must** fully restart MCreator after
installing / replacing this plugin for any template or definition
change to take effect.

### 2. Drop this generator folder into MCreator

Because this plugin implements the `quiltmc-1.20.1` generator id that
MCreator never shipped before, installing it is equivalent to
**adding a brand-new Quilt 1.20.1 workspace option** to MCreator. You
may drop it in either of these two paths (on most MCreator builds the
`plugins/` directory wins priority over the root generator dir, so the
first path is recommended):

- `<MCreator 2026.1 install folder>/plugins/quiltmc-1.20.1-generator/`  (**recommended**)
- `<MCreator 2026.1 install folder>/quiltmc-1.20.1-generator/`

After copying, make sure the folder's contents are **directly one level
deep** (do not double-nest it as `quiltmc-1.20.1-generator-2/quiltmc-1.20.1-generator/…`):

```
quiltmc-1.20.1-generator/
├── plugin.json
├── LICENSE
├── CHANGELOG.md
├── README.md  ← this file
├── quilt-1.20.1/
│   ├── generator.yaml
│   ├── workspacebase/build.gradle
│   ├── workspacebase/settings.gradle
│   ├── armor.definition.yaml
│   ├── feature.definition.yaml
│   ├── structure.definition.yaml
│   ├── procedures/
│   ├── aitasks/
│   └── templates/...
└── datapack-1.20.1/
    ├── workspacebase/settings.gradle
    └── ...
```

### 3. For pre-existing workspaces — force regeneration of Gradle + sources

If you already had a Quilt workspace (for example: the `test_diwu`
workspace you've been iterating on through each cycle), you need to
blow away cached output and regenerate, otherwise MCreator keeps the
old templates in place:

1. Close MCreator.
2. Delete the `src/` and `build/` folders from your workspace root.
   (This forces MCreator to regenerate every Java / JSON / resource
   file against the new templates on the next run.)
3. Re-open MCreator and open your workspace. You will normally get a
   popup that says *"Gradle project is out of date"* → click
   **Regenerate build.gradle** (mandatory: the `workspacebase/build.gradle`
   template we ship — official-only repositories, UTF-8 no-BOM, the
   `.nbt` mirror task — is injected into your workspace at exactly this
   step).
4. Menu → **Build → Rebuild Gradle project** and wait for Gradle to
   finish with a clean `BUILD SUCCESSFUL`.

### 4. For brand-new workspaces

Just create a new **Quilt 1.20.1** workspace from the MCreator welcome
screen as usual — every template, definition, element-init, and the
Gradle build script all come from this implementation automatically,
no extra steps needed.

---

## ⚙️ Repository / download URLs used by generated workspaces

Every repository points directly at official upstream sources, so
users outside censored regions get an out-of-the-box working setup.
If you need a faster mirror on a slow / censored network, configure
it through standard Gradle mechanisms (mentioned above). Please do
**not** open PRs against this repository that hardcode regional
mirrors — doing so breaks the out-of-the-box experience for
international users.

| Repository | URL used |
|------------|----------|
| Quilt Maven (Loader, Mappings, main QFAPI artifacts) | `https://maven.quiltmc.org/repository/release` |
| Fabric Maven (QFAPI internal dependencies on Fabric modules) | `https://maven.fabricmc.net/` |
| Minecraft Forge Maven (only used by the `datapack packloader` subproject) | `https://maven.minecraftforge.net/` |
| Maven Central | `mavenCentral()` |
| Gradle Plugin Portal | `gradlePluginPortal()` |
| Gradle Wrapper (`distributionUrl`) | `https://services.gradle.org/distributions/gradle-8.10-bin.zip` (Quilt workspace) / `gradle-9.4.1-bin.zip` (datapack `packloader` subproject) |

---

## 🧩 Compatibility

| What | Minimum / required | Notes |
|------|---------|-------|
| MCreator | 2026.1 | Validated only against MCreator 2026.1.14619, which carries `subversion` metadata 1.x for the `quilt` generator id. |
| Minecraft | **Strictly 1.20.1 only** | Worldgen layout, `ServerPlayer.teleportTo`, `AbstractFurnaceBlockEntity.serverTick`, Quilt events `LivingEntityEvents` / `ServerLivingEntityEvents` — all are 1.20.1 API shapes. This generator is **not** back-ported to 1.19.x and **not** forward-ported to 1.20.2+ (where `/locate feature`, `fixed_placement`, and dozens of other APIs were changed). |
| Java | JDK 17 or JDK 21 | Generated mods target Java 17 bytecode; MCreator 2026.1 ships JDK 21 bundled which compiles & runs everything correctly. |
| Quilt Loader | 0.26.0 | Declared in the generator dependency metadata; paired with Quilted Fabric API `7.7.0+0.92.2-1.20.1`. |

This generator does **not** modify any MCreator GUI XML schemas or
element-model fields — meaning any `.mcr` workspace you already built
for a Forge generator will open cleanly in MCreator under a Quilt
generator setup (you just need to follow the "pre-existing workspaces"
steps above to clear caches and regenerate code).

---

## 🐛 Reporting issues / bugs

Before opening an issue, please confirm you performed every step in
this checklist **in order**:
✅ MCreator was fully closed and restarted after installing the plugin
✅ The workspace `src/` and `build/` folders were deleted
✅ On reopening, you clicked **Regenerate build.gradle** on the Gradle out-of-date popup
✅ You ran `Build → Rebuild Gradle project` and it still fails / the runtime still crashes

Then file an issue on whichever release channel you downloaded this
from, and **attach all three** of:

1. The exact `generator version` string from MCreator → About /
   Plugins (should match `1.1.0-dev4` or newer).
2. The failing file contents under `src/main/java/…`, or the **full
   un-truncated** Gradle `compileJava` / `runClient` stacktrace.
3. The element definition export (`.mcr` file or per-element XML
   export) for whichever element type triggers the bug — **especially**
   for Dimension, Structure/Feature, Armor, Potion Effect, and Item
   Extension (dispenser / fuel) elements: we simply cannot reproduce
   definition-shape bugs without the exact schema you used in the GUI.

---

## 🗂️ File map (for curious readers / contributors)

| Path | What it controls / which reference semantics it maps from |
|------|-----------------------------------------------------------|
| `plugin.json` | Generator id, name, version, description, author list |
| `quilt-1.20.1/generator.yaml` | Resource directory map (plural **`structures_dir`** matching Forge 1.20.1 / Structure Template Manager lookup paths — since no "previous official quilt generator" existed, this was simply written correctly the first time); the base_templates inclusion list; texture / sound / lang directory alignment |
| `quilt-1.20.1/workspacebase/build.gradle` | Full Quilt dependencies (official repos only); Gradle plugin-management alignment; **`processResources` mirror task** `data/<ns>/structures/*.nbt → assets/<ns>/structures/*.nbt` (so Structure Block lookups resolve to the exact same `.nbt` the worldgen Jigsaw pools reference); UTF-8 output without BOM |
| `quilt-1.20.1/workspacebase/settings.gradle` | `pluginManagement` repositories: Fabric Maven + Quilt Maven + mavenCentral + gradlePluginPortal |
| `quilt-1.20.1/armor.definition.yaml` | Armor `localizationkeys` (`description_@item_index`) entries for all four armor pieces; chestplate `bodyName` `mapto` corrected to match the MCreator GUI field names the Forge 1.20.1 generator uses (an older draft had the stale alias `chestplateName`) |
| `quilt-1.20.1/feature.definition.yaml` | Configured / placed feature routing; skip guard so 1.21+ placement types (e.g. `fixed_placement`) never leak into generated 1.20.1 JSON; `configured_feature_reference` condition gate so we never try to generate a Java class for feature types that don't have one |
| `quilt-1.20.1/structure.definition.yaml` | Jigsaw structure → `structure.json` / `structure_set.json` / `template_pool.json` mapping (Forge 1.20.1 definition semantics) |
| `quilt-1.20.1/templates/feature/structure_feature.java.ftl` | Full import list for `Codec, BlockPos, Holder, RandomSource, WorldGenLevel, Mirror, Rotation, Feature, FeaturePlaceContext, BlockIgnoreProcessor, StructurePlaceSettings, StructureTemplate, StructureTemplateManager` (missing imports would produce `extends {` / `super(.CODEC)` compile errors) |
| `quilt-1.20.1/templates/feature/structure_feature_configuration.java.ftl` | Full import list for `Codec, RecordCodecBuilder, HolderSet, RegistryCodecs, Vec3i, Registries, ResourceLocation, Block, FeatureConfiguration` |
| `quilt-1.20.1/templates/elementinits/features.java.ftl` | Restored `STRUCTURE_FEATURE = Registry.register(BuiltInRegistries.FEATURE, …)` block (without this line, `configured_feature` JSON files fail runtime lookup because the FEATURE id doesn't exist) |
| `quilt-1.20.1/templates/elementinits/dispensebehaviors.java.ftl` | Dispenser "attempt to dispense" procedure hooks + branch layout matching the NeoForge 1.21.1 upstream template |
| `quilt-1.20.1/templates/elementinits/item_extensions.java.ftl` | Fuel runtime entrypoint `checkFuelBurnCondition(ItemStack, Level, BlockPos)` — reflectively invoked from the furnace Mixin |
| `quilt-1.20.1/templates/elementinits/potioneffects.java.ftl` | Effect registration; `ServerLivingEntityEvents.AFTER_DEATH` onExpired-at-death hook; conditionally-gated `onExpiredOnDeath` so an empty effect set never generates an empty utility class |
| `quilt-1.20.1/templates/modbase/mod.java.ftl` | Guard pattern (layout aligned to NeoForge 1.21.1): only emit `registerProcedures()` if procedures actually exist; only emit `DispenseBehaviors.init()` if any item extension has dispenser behaviors or any special entities exist; never reference a non-existent `XxxModFeatures.register()` when the configured_feature_reference strip-out rule has been applied to `features.java.ftl` |
| `quilt-1.20.1/templates/mixin/abstract_furnace_block_entity_mixin.java.ftl` | Fuel-condition hide/restore Mixin (`serverTick` HEAD → check condition → refuse → hide fuel in slot; RETURN → restore) |
| `quilt-1.20.1/templates/mixin/lightning_bolt_mixin.java.ftl` | UUID-Set dedup in `LightningBolt.hit` / thunder roll so "when entity is struck by lightning" fires exactly once per strike per entity |
| `quilt-1.20.1/templates/dimension/blockportal.java.ftl` | Portal path uses `ServerPlayer.teleportTo` + reset position; manual dimension-event callback so on-enter / on-leave procedure triggers fire at exactly the right moment (avoids the `DistantManager.removePlayer` NPE that `entity.changeDimension` causes) |
| `quilt-1.20.1/templates/dimension/dimension.java.ftl` | Static-initializer self-registering dimension listeners (no dependency on a non-generated `XxxModDimensions` bridge class) |
| `quilt-1.20.1/templates/potioneffect.java.ftl` | Dual-path on-applied trigger; tick procedure gated behind `!isInstant` |
| `quilt-1.20.1/procedures/entity_add_item.java.ftl` | Procedure snippet "Give entity an itemstack" — ported from Forge-only `ItemHandlerHelper` to vanilla inventory APIs |
| `quilt-1.20.1/aitasks/attack_entity.java.ftl` | 3-arg `NearestAttackableTargetGoal` constructor + has-content guard around configured target type `field$entity` so unconfigured / empty-selection goals don't NPE |
| `datapack-1.20.1/workspacebase/settings.gradle` | `pluginManagement` repos (gradlePluginPortal + MinecraftForge Maven) for the datapack loader subproject; no regional mirrors |

---

## ⚖️ Copyright and licensing

```text
quiltmc-1.20.1-generator — Quilt 1.20.1 mod code generator for MCreator
        (Lightseeking build — First community Quilt implementation;
              semantics cross-referenced from Forge 1.20.1 +
                        NeoForge 1.21.1 official generators)

Copyright (C) 2026 htqkeku, Lightseeking(FL) Studio
Copyright (C) 2020-2023 Pylo, opensource contributors
Copyright (C) 2012-2020 Pylo
```

This program is free software: you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the
Free Software Foundation, either version 3 of the License, or (at your
option) any later version.

This program is distributed in the hope that it will be useful, but
**WITHOUT ANY WARRANTY**; without even the implied warranty of
**MERCHANTABILITY** or **FITNESS FOR A PARTICULAR PURPOSE**. See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License along
with this program (see the `LICENSE` file). If not, see
<https://www.gnu.org/licenses/>.

### Additional permission for code generator templates (\*.ftl files)

As a special exception, the copyright holders of this generator give you
permission to *use*, *reproduce*, *distribute*, *modify*, and *exploit*
the output of any of the `*.ftl` FreeMarker templates in this generator
– i.e. the Java / JSON / XML / YAML code produced by them inside your
own `src/` directory – under **any license of your choosing**, without
the output becoming GPL-licensed by way of the GPL's normal
"infectious" derivative-work clause.

This is the same "template output exception" used by the upstream Pylo
MCreator project and by projects such as the GNU Autotools. It
explicitly does **not** change the licensing of the generator itself
(the contents of this repository / plugin zip file), which remain
GPLv3.
