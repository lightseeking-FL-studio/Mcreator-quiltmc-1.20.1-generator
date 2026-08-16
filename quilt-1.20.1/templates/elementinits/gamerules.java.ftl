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

import net.minecraft.world.level.GameRules;
import net.fabricmc.fabric.api.gamerule.v1.GameRuleFactory;
import net.fabricmc.fabric.api.gamerule.v1.GameRuleRegistry;

public class ${JavaModName}GameRules {

	<#list gamerules as gamerule>
		<#if gamerule.type == "Number">
		public static final GameRules.Key<GameRules.IntegerValue> ${gamerule.getModElement().getRegistryNameUpper()} =
				GameRuleRegistry.register("${StringUtils.lowercaseFirstLetter(gamerule.getModElement().getName())}",
				GameRules.Category.${gamerule.category}, GameRuleFactory.createIntRule(${gamerule.defaultValueNumber}));
		<#else>
		public static final GameRules.Key<GameRules.BooleanValue> ${gamerule.getModElement().getRegistryNameUpper()} =
				GameRuleRegistry.register("${StringUtils.lowercaseFirstLetter(gamerule.getModElement().getName())}",
				GameRules.Category.${gamerule.category}, GameRuleFactory.createBooleanRule(${gamerule.defaultValueLogic}));
		</#if>
	</#list>

}

<#-- @formatter:on -->
