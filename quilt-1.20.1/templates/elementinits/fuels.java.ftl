<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2023, Pylo, opensource contributors
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
 # which will cause the template and the resulting code generator output files to
 # be licensed under the GNU General Public License without this special
 # exception.
-->

<#-- @formatter:off -->

<#include "../mcitems.ftl">
<#include "../procedures.java.ftl">
<#assign itemextensions = w.getGElementsOfType("itemextension")>
<#assign fuelsWithCondition = itemextensions?filter(e -> e.enableFuel && ((e.fuelSuccessCondition?? && hasProcedure(e.fuelSuccessCondition)) || (e.fuelBurnCondition?? && hasProcedure(e.fuelBurnCondition))))>

/*
 *	MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

import net.minecraft.world.item.ItemStack;
import net.minecraft.world.level.Level;
import net.minecraft.core.BlockPos;

public class ${JavaModName}Fuels {

	public static void registerFuels() {
		<@javacompress>
		<#list itemextensions?filter(e -> e.enableFuel) as extension>
			if (${mappedMCItemToItem(extension.item)}.getDefaultInstance().getBurnTime(null) < 0)
				net.fabricmc.fabric.api.registry.FuelRegistry.INSTANCE.add(${mappedMCItemToItem(extension.item)},
				<#if hasProcedure(extension.fuelPower)>
					(int) <@procedureOBJToNumberCode extension.fuelPower/>
				<#else>
					${extension.fuelPower.getFixedValue()}
				</#if>
				);
		</#list>
		</@javacompress>
	}

<#if fuelsWithCondition?size != 0>
	/**
	 * Called by AbstractFurnaceBlockEntityMixin to check burnSuccessCondition
	 * before the furnace actually burns a fuel item.
	 *
	 * @return negative value = not handled by this mod (use default behavior);
	 *         0 = condition returned false, do NOT burn this item;
	 *         positive = condition returned true, use this custom burn time
	 */
	public static int checkFuelBurnCondition(ItemStack fuelStack, Level level, BlockPos pos) {
		if (fuelStack == null || fuelStack.isEmpty()) return -1;
		if (level == null || level.isClientSide()) return -1;
		int x = pos.getX();
		int y = pos.getY();
		int z = pos.getZ();
		<@javacompress>
		<#list fuelsWithCondition as extension>
			if (fuelStack.getItem() == ${mappedMCItemToItem(extension.item)}) {
				Integer registered = net.fabricmc.fabric.api.registry.FuelRegistry.INSTANCE.get(${mappedMCItemToItem(extension.item)});
			int defaultBurn = (registered != null) ? registered.intValue() : -1;
			if (defaultBurn < 0) {
				<#if hasProcedure(extension.fuelPower)>
				defaultBurn = (int) <@procedureOBJToNumberCode extension.fuelPower/>;
				<#else>
				defaultBurn = (int) ${extension.fuelPower.fixedValue};
				</#if>
			}
				<#assign condObj>
				<#if extension.fuelSuccessCondition?? && hasProcedure(extension.fuelSuccessCondition)>
					<@procedureOBJToConditionCode extension.fuelSuccessCondition/>
				<#elseif extension.fuelBurnCondition?? && hasProcedure(extension.fuelBurnCondition)>
					<@procedureOBJToConditionCode extension.fuelBurnCondition/>
				<#else>
					true
				</#if>
				</#assign>
				boolean condition = ${condObj};
				System.out.println("[Fuel] Check item=" + fuelStack.getItem() + " defaultBurn=" + defaultBurn + " condition=" + condition + " at (" + x + "," + y + "," + z + ")");
				if (!condition) {
					return 0; // refuse to burn
				}
				<#-- if fuelPower is a procedure, re-evaluate dynamically -->
				<#if hasProcedure(extension.fuelPower)>
				return (int) <@procedureOBJToNumberCode extension.fuelPower/>;
				<#else>
				return Math.max(defaultBurn, 0);
				</#if>
			}<#sep>else
		</#list>
		</@javacompress>
		return -1;
	}
</#if>

}

<#-- @formatter:on -->
