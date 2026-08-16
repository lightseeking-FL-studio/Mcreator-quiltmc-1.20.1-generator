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

import net.minecraft.world.entity.EntityType;
import net.minecraft.client.renderer.entity.EntityRendererProvider;

import net.fabricmc.api.Environment;
import net.fabricmc.api.EnvType;

import ${package}.client.renderer.entity.${JavaModName}BoatRenderer;

<#assign specialentities = w.getGElementsOfType("specialentity")>
<#assign hasBoat = specialentities?filter(e -> e.entityType == "Boat")?size != 0>

public class ${JavaModName}EntityRenderers {

	public static void registerEntityRenderers() {
		<#list w.getGElementsOfType("livingentity") as entity>
			EntityRendererRegistry.register(${JavaModName}Entities.${entity.getModElement().getRegistryNameUpper()}, ${entity.getModElement().getName()}Renderer::new);
		</#list>
		<#list w.getGElementsOfType("projectile") as entity>
			EntityRendererRegistry.register(${JavaModName}Entities.${entity.getModElement().getRegistryNameUpper()}, net.minecraft.client.renderer.entity.ThrownItemRenderer::new);
		</#list>

		<#if hasBoat>
		EntityRendererRegistry.register(${JavaModName}Entities.${JavaModName?upper_case}_BOAT, context -> new ${JavaModName}BoatRenderer(context));
		</#if>
	}
}
<#-- @formatter:on -->
