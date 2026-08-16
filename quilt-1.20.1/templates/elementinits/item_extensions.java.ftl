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
 # As a special exception, the copyright holders of this program give you
 # permission to link this program with independent modules to produce an
 # executable, regardless of the license terms of these independent modules,
 # and to copy and distribute the resulting executable under terms of your
 # choice, provided that you also meet, for each linked independent module,
 # the terms and conditions of the license of that module. An independent
 # module is a module which is not derived from or based on this program. If
 # you modify this program, you may extend this exception to your version of
 # the program, but you are not obligated to do so. If you do not wish to do
 # so, delete this exception statement from your version.
-->

<#-- @formatter:off -->

<#include "../mcitems.ftl">
<#include "../procedures.java.ftl">
<#assign itemextensions = w.getGElementsOfType("itemextension")>
<#assign fuelsWithCondition = itemextensions?filter(e -> e.enableFuel && ((e.fuelSuccessCondition?? && hasProcedure(e.fuelSuccessCondition)) || (e.fuelBurnCondition?? && hasProcedure(e.fuelBurnCondition))))>

/*
 *    MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

import net.fabricmc.fabric.api.registry.FuelRegistry;
import net.fabricmc.fabric.api.registry.CompostingChanceRegistry;
<#if fuelsWithCondition?size != 0>
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.level.Level;
import net.minecraft.core.BlockPos;
</#if>

public class ${JavaModName}ItemExtensions {
	public static void registerItemExtensions() {
		<#list itemextensions as itemextension>
			<#if itemextension.enableFuel>
		FuelRegistry.INSTANCE.add(${mappedMCItemToItem(itemextension.item)},
			<#if hasProcedure(itemextension.fuelPower)>
				(int) <@procedureOBJToNumberCode itemextension.fuelPower/>
			<#else>
				(int) ${itemextension.fuelPower.fixedValue}f
			</#if>
		);
			</#if>
			<#if itemextension.compostLayerChance gt 0>
		CompostingChanceRegistry.INSTANCE.add(${mappedMCItemToItem(itemextension.item)}, ${itemextension.compostLayerChance}f);
			</#if>
		</#list>
	}

<#if fuelsWithCondition?size != 0>
	/**
	 * Called by AbstractFurnaceBlockEntityMixin to check fuelSuccessCondition
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
				<#-- Support both "boolean return" and "ItemStack return" for burn condition:
				       - ItemStack return (auto-detected): EMPTY/null = refuse burn; non-EMPTY = allow burn
				       - boolean / default return: false = refuse burn; true = allow burn
				     This mirrors how dispenseResultItemstack has dual code paths. -->
				<#if extension.fuelSuccessCondition?? && hasProcedure(extension.fuelSuccessCondition)>
					<#if hasReturnValueOf(extension.fuelSuccessCondition, "itemstack")>
						ItemStack th$burnCondStack = <@procedureOBJToItemstackCode extension.fuelSuccessCondition, false/>;
						if (th$burnCondStack == null || th$burnCondStack.isEmpty()) {
							return 0; // refuse to burn
						}
					<#else>
						if (!<@procedureOBJToConditionCode extension.fuelSuccessCondition/>) {
							return 0; // refuse to burn
						}
					</#if>
				<#elseif extension.fuelBurnCondition?? && hasProcedure(extension.fuelBurnCondition)>
					<#if hasReturnValueOf(extension.fuelBurnCondition, "itemstack")>
						ItemStack th$burnCondStack = <@procedureOBJToItemstackCode extension.fuelBurnCondition, false/>;
						if (th$burnCondStack == null || th$burnCondStack.isEmpty()) {
							return 0; // refuse to burn
						}
					<#else>
						if (!<@procedureOBJToConditionCode extension.fuelBurnCondition/>) {
							return 0; // refuse to burn
						}
					</#if>
				</#if>
				<#-- condition passed; allow burn -->
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
