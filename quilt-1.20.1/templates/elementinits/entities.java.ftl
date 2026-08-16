<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2025, Pylo, opensource contributors
-->

<#-- @formatter:off -->

/*
 *    MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

<#assign hasLivingEntities = w.hasElementsOfType("livingentity")>
<#assign hasProjectiles = w.hasElementsOfType("projectile")>
<#assign hasSpecialEntities = w.hasElementsOfType("specialentity")>
import net.minecraft.world.entity.MobCategory;
import net.minecraft.world.entity.EntityType;
import net.minecraft.world.entity.Entity;
import net.minecraft.resources.ResourceLocation;
import net.minecraft.core.registries.BuiltInRegistries;
import net.minecraft.core.Registry;

public class ${JavaModName}Entities {

	<#list w.getGElementsOfType("projectile") as entity>
		public static final EntityType<${entity.getModElement().getName()}Entity> ${entity.getModElement().getRegistryNameUpper()} =
			register("${entity.getModElement().getRegistryName()}", EntityType.Builder.<${entity.getModElement().getName()}Entity>of(${entity.getModElement().getName()}Entity::new, MobCategory.MISC).clientTrackingRange(64).updateInterval(1).sized(${entity.modelWidth}f, ${entity.modelHeight}f));
	</#list>
	<#list w.getGElementsOfType("livingentity") as entity>
		public static final EntityType<${entity.getModElement().getName()}Entity> ${entity.getModElement().getRegistryNameUpper()} =
			register("${entity.getModElement().getRegistryName()}", EntityType.Builder.<${entity.getModElement().getName()}Entity>of(${entity.getModElement().getName()}Entity::new, ${generator.map(entity.mobSpawningType, "mobspawntypes")})
							.clientTrackingRange(${entity.trackingRange}).updateInterval(3)
							<#if entity.immuneToFire>.fireImmune()</#if>
							.sized(${entity.modelWidth}f, ${entity.modelHeight}f)
						);
		<#if entity.hasCustomProjectile()>
		public static final EntityType<${entity.getModElement().getName()}EntityProjectile> ${entity.getModElement().getRegistryNameUpper()}_PROJECTILE =
			register("projectile_${entity.getModElement().getRegistryName()}", EntityType.Builder.<${entity.getModElement().getName()}EntityProjectile>of(${entity.getModElement().getName()}EntityProjectile::new, MobCategory.MISC).clientTrackingRange(64)
						.updateInterval(1).sized(0.5f, 0.5f));
		</#if>
	</#list>

	<#if hasSpecialEntities>
		<#list w.getGElementsOfType("specialentity") as entity>
			<#if entity.entityType == "Boat">
		public static final EntityType<${JavaModName}Boat> ${JavaModName?upper_case}_BOAT =
			register("boat", EntityType.Builder.<${JavaModName}Boat>of(${JavaModName}Boat::new, MobCategory.MISC).sized(1.375F, 0.5625F).clientTrackingRange(10));
			</#if>
			<#if entity.entityType == "ChestBoat">
		public static final EntityType<${JavaModName}ChestBoat> ${JavaModName?upper_case}_CHEST_BOAT =
			register("chest_boat", EntityType.Builder.<${JavaModName}ChestBoat>of(${JavaModName}ChestBoat::new, MobCategory.MISC).sized(1.375F, 0.5625F).clientTrackingRange(10));
			</#if>
		</#list>
	</#if>

	// Start of user code block custom entities
	// End of user code block custom entities

	private static <T extends Entity> EntityType<T> register(String registryname, EntityType.Builder<T> entityTypeBuilder) {
		return Registry.register(BuiltInRegistries.ENTITY_TYPE, new ResourceLocation("${modid}", registryname), (EntityType<T>) entityTypeBuilder.build(registryname));
	}

	<#if hasLivingEntities>
	public static void registerAttributes() {
		<#list w.getGElementsOfType("livingentity") as entity>
			net.fabricmc.fabric.api.object.builder.v1.entity.FabricDefaultAttributeRegistry.register(${entity.getModElement().getRegistryNameUpper()}, ${entity.getModElement().getName()}Entity.createAttributes());
		</#list>
	}
	</#if>

}

<#-- @formatter:on -->
