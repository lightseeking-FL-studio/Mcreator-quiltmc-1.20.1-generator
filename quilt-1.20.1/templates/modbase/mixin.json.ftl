<#include "../procedures.java.ftl">
<#assign mixins = ['LivingEntityMixin', 'TamableAnimalMixin', 'CreeperMixin', 'BreakDoorGoalMixin', 'WitherBossMixin', 'SilverfishMixin', 'RavagerMixin', 'FarmBlockMixin', 'LevelMixin', 'GhastMixin', 'EntityHandleStatusMixin', 'EnderManMixin', 'PlayerMixin', 'ItemStackMixin', 'BlockItemMixin', 'BoneMealItemMixin', 'CommandsMixin', 'ExperienceOrbMixin', 'CropBlockMixin', 'ConfiguredFeatureMixin', 'MobMixin', 'LightningBoltMixin', 'EntityMixin', 'ServerLevelMixin', 'TotemMixin', 'LevelExplosionMixin', 'ItemEntityPickupMixin', 'ItemEntityDropMixin', 'AbstractFurnaceBlockEntityMixin', 'CraftingMenuMixin', 'PlayerAdvancementsMixin', 'FishingHookMixin', 'VillageSiegeMixin', 'ServerPlayerMixin']>
<#if w.getGElementsOfType('fluid')?filter(e -> hasProcedure(e.onTickUpdate))?size != 0>
	<#assign mixins = mixins + ['FlowingFluidMixin']>
</#if>
<#if w.getGElementsOfType('biome')?filter(e -> e.spawnBiome || e.spawnInCaves || e.spawnBiomeNether)?size != 0>
	<#assign mixins = mixins + ['NoiseGeneratorSettingsMixin']>
</#if>
<#if w.getGElementsOfType("block")?filter(e -> e.isSign())?size != 0>
	<#assign mixins = mixins + ['BlockEntityTypeAccessor']>
</#if>
<#if w.getGElementsOfType("specialentity")?filter(e -> e.entityType == "Boat")?size != 0>
	<#assign mixins = mixins + ['${JavaModName}BoatRendererMixin']>
</#if>
{
  "required": true,
  "package": "${package}.mixin",
  "compatibilityLevel": "JAVA_17",
  "refmap": "modid-refmap.json",
  "mixins": [
	<#list mixins as mixin>"${mixin}"<#sep>,</#list>
  ],
  "client": [
  ],
  "injectors": {
    "defaultRequire": 1
  },
  "minVersion": "0.8.4"
}
