<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2023, Pylo, opensource contributors
 # Copyright (C) 2026, htqkeku, Lightseeking(FL) Studio — Dimension enter/leave trigger fix
 #
 # This program is free software: you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <https://www.gnu.org/licenses/>.
 #
 # Additional permission for code generator templates (*.ftl files)
 #
 # As a special exception, you may create a larger work that contains part or
 # all of the MCreator code generator templates (*.ftl files) and distribute
 # that work under terms of your choice, so long as that work isn't itself a
 # template for code generation. Alternatively, if you modify or redistribute
 # the template itself, you may (at your option) remove this special exception,
 # which will cause the template and the resulting code generator output files
 # to be licensed under the GNU General Public License without this special
 # exception.
-->

<#-- @formatter:off -->
<#include "../mcitems.ftl">
<#include "../procedures.java.ftl">

/*
 *    MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.world.dimension;

import net.minecraft.world.phys.Vec3;
import net.minecraft.world.level.Level;
import net.minecraft.world.entity.Entity;
import net.minecraft.server.level.ServerPlayer;
import net.minecraft.resources.ResourceLocation;
import net.minecraft.resources.ResourceKey;
import net.minecraft.core.registries.Registries;
import net.minecraft.client.renderer.DimensionSpecialEffects;

import net.mcreator.testdiwu.procedures.TestweiduWanJiaJinRuWeiDuShiProcedure;
import net.mcreator.testdiwu.event.LivingEntityEvents;

import net.fabricmc.fabric.api.client.rendering.v1.DimensionRenderingRegistry;
import net.fabricmc.api.Environment;
import net.fabricmc.api.EnvType;

<@javacompress>
public class ${name}Dimension {

	<#if data.useCustomEffects>
	public static class ${name}SpecialEffectsHandler {

		@Environment(EnvType.CLIENT) public static void registerDimensionSpecialEffects() {
			DimensionSpecialEffects customEffect = new DimensionSpecialEffects(
				<#if data.hasClouds>${data.cloudHeight}f<#else>Float.NaN</#if>,
				true,
				DimensionSpecialEffects.SkyType.${data.skyType},
				false,
				false
			) {
				@Override public Vec3 getBrightnessDependentFogColor(Vec3 color, float sunHeight) {
					<#if data.airColor?has_content>
						return new Vec3(${data.airColor.getRed()/255},${data.airColor.getGreen()/255},${data.airColor.getBlue()/255})
					<#else>
						return color
					</#if>
					<#if data.sunHeightAffectsFog>
						.multiply(sunHeight * 0.94 + 0.06, sunHeight * 0.94 + 0.06, sunHeight * 0.91 + 0.09)
					</#if>;
				}

				@Override public boolean isFoggyAt(int x, int y) {
					return ${data.hasFog};
				}
			};
			DimensionRenderingRegistry.registerDimensionEffects(new ResourceLocation("${modid}:${registryname}"), customEffect);
		}

	}
	</#if>

	<#if hasProcedure(data.onPlayerLeavesDimension) || hasProcedure(data.onPlayerEntersDimension)>
	public static void onPlayerChangedDimensionEvent(ServerPlayer player, ResourceKey<Level> from, ResourceKey<Level> to) {
		Entity entity = player;
		Level world = entity.level();
		double x = entity.getX();
		double y = entity.getY();
		double z = entity.getZ();

		<#if hasProcedure(data.onPlayerLeavesDimension)>
		if (from == ResourceKey.create(Registries.DIMENSION, new ResourceLocation("${modid}:${registryname}"))) {
			<@procedureOBJToCode data.onPlayerLeavesDimension/>
		}
        </#if>

		<#if hasProcedure(data.onPlayerEntersDimension)>
		if (to == ResourceKey.create(Registries.DIMENSION, new ResourceLocation("${modid}:${registryname}"))) {
			<@procedureOBJToCode data.onPlayerEntersDimension/>
		}
        </#if>
	}
    </#if>

}
</@javacompress>