<#-- @formatter:off -->

/*
 *    MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

import net.minecraft.core.Registry;
import net.minecraft.core.registries.BuiltInRegistries;
import net.minecraft.core.registries.Registries;
import net.minecraft.resources.ResourceLocation;
import net.minecraft.world.level.levelgen.feature.Feature;

import ${package}.world.features.StructureFeature;
import ${package}.world.features.configurations.StructureFeatureConfiguration;

public class ${JavaModName}Features {

	<#list w.getGElementsOfType("feature") as feature>
	public static final Feature<?> ${feature.getModElement().getRegistryNameUpper()} =
		Registry.register(BuiltInRegistries.FEATURE, new ResourceLocation("${modid}", "${feature.getModElement().getRegistryName()}"),
			new ${feature.getModElement().getName()}Feature());
	</#list>

	public static final Feature<?> STRUCTURE_FEATURE =
		Registry.register(BuiltInRegistries.FEATURE, new ResourceLocation("${modid}", "structure_feature"),
			new StructureFeature(StructureFeatureConfiguration.CODEC));

}

<#-- @formatter:on -->
