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

<#assign specialentities = w.getGElementsOfType("specialentity")>
import net.minecraft.client.model.geom.ModelLayerLocation;
import net.minecraft.resources.ResourceLocation;

public class ${JavaModName}Models {
	<#list specialentities as entity>
	public static final ModelLayerLocation ${entity.getModElement().getRegistryNameUpper()}_LAYER_LOCATION =
			new ModelLayerLocation(new ResourceLocation("${modid}", "<#if entity.entityType == "Boat">boat<#else>chest_boat</#if>/${entity.getModElement().getRegistryName()}"), "main");
	</#list>

	public static void registerLayerDefinitions() {
		<#list specialentities as entity>
		net.fabricmc.fabric.api.client.rendering.v1.EntityModelLayerRegistry.registerModelLayer(${entity.getModElement().getRegistryNameUpper()}_LAYER_LOCATION, net.minecraft.client.model.BoatModel::createBodyModel);
		</#list>
	}

}

<#-- @formatter:on -->
