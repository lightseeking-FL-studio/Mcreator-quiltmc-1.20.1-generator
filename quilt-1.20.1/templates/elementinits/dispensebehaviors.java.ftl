<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2025, Pylo, opensource contributors
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
 # which will cause the template and resulting code generator output files to
 # be licensed under the GNU General Public License without this special
 # exception.
-->

<#-- @formatter:off -->

<#include "../mcitems.ftl">
<#include "../procedures.java.ftl">

/*
 *	MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

<#assign itemextensions = w.getGElementsOfType("itemextension")?filter(e -> e.hasDispenseBehavior)>
<#assign specialentities = w.getGElementsOfType("specialentity")>
<#assign hasBoat = specialentities?filter(e -> e.entityType == "Boat")?size != 0>
<#assign hasChestBoat = specialentities?filter(e -> e.entityType == "ChestBoat")?size != 0>

import ${package}.entity.${JavaModName}Boat;
<#if hasChestBoat>
import ${package}.entity.${JavaModName}ChestBoat;
</#if>

<#assign variantSetterCode>
<#if hasChestBoat && hasBoat>
		if(boat instanceof ${JavaModName}ChestBoat chestBoat) {
			chestBoat.setVariant(this.type);
		} else if(boat instanceof ${JavaModName}Boat boatt) {
			boatt.setVariant(this.type);
		}
<#elseif hasChestBoat>
		if(boat instanceof ${JavaModName}ChestBoat chestBoat)
			chestBoat.setVariant(this.type);
<#else>
		if(boat instanceof ${JavaModName}Boat boatt)
			boatt.setVariant(this.type);
</#if>
</#assign>

<@javacompress>
public class ${JavaModName}DispenseBehaviors {

	public static void init() {
		<@javacompress>
		<#list itemextensions as extension>
			DispenserBlock.registerBehavior(${mappedMCItemToItem(extension.item)},
			<#if hasProcedure(extension.dispenseSuccessCondition)>
			new OptionalDispenseItemBehavior() {
				public ItemStack execute(BlockSource blockSource, ItemStack stack) {
					ItemStack itemstack = stack.copy();
					Level world = blockSource.getLevel();
					Direction direction = blockSource.getBlockState().getValue(DispenserBlock.FACING);
					int x = blockSource.getPos().getX();
					int y = blockSource.getPos().getY();
					int z = blockSource.getPos().getZ();

					<#if extension.dispenseAttemptedProcedure??>
					<#if hasProcedure(extension.dispenseAttemptedProcedure)>
					<@procedureOBJToCode extension.dispenseAttemptedProcedure/>
					</#if>
					<#elseif extension.dispenseAttemptProcedure??>
					<#if hasProcedure(extension.dispenseAttemptProcedure)>
					<@procedureOBJToCode extension.dispenseAttemptProcedure/>
					</#if>
					</#if>

					this.setSuccess(<@procedureOBJToConditionCode extension.dispenseSuccessCondition/>);

					<#if hasProcedure(extension.dispenseResultItemstack)>
						boolean success = this.isSuccess();
						<#if hasReturnValueOf(extension.dispenseResultItemstack, "itemstack")>
							return <@procedureOBJToItemstackCode extension.dispenseResultItemstack, false/>;
						<#else>
							<@procedureOBJToCode extension.dispenseResultItemstack/>
							if (success) {
								itemstack.shrink(1);
							}
							return itemstack;
						</#if>
					<#else>
						if (this.isSuccess()) {
							itemstack.shrink(1);
						}
						return itemstack;
					</#if>
				}
			}
			<#else>
			new DefaultDispenseItemBehavior() {
				public ItemStack execute(BlockSource blockSource, ItemStack itemstack) {
					Level world = blockSource.getLevel();
					int x = blockSource.getPos().getX();
					int y = blockSource.getPos().getY();
					int z = blockSource.getPos().getZ();

					<#if extension.dispenseAttemptedProcedure??>
					<#if hasProcedure(extension.dispenseAttemptedProcedure)>
					<@procedureOBJToCode extension.dispenseAttemptedProcedure/>
					</#if>
					<#elseif extension.dispenseAttemptProcedure??>
					<#if hasProcedure(extension.dispenseAttemptProcedure)>
					<@procedureOBJToCode extension.dispenseAttemptProcedure/>
					</#if>
					</#if>

					<#if hasProcedure(extension.dispenseResultItemstack)>
						<#if hasReturnValueOf(extension.dispenseResultItemstack, "itemstack")>
							return <@procedureCode extension.dispenseResultItemstack, {
								"x": "x",
								"y": "y",
								"z": "z",
								"itemstack": "itemstack.copy()",
								"world": "world",
								"direction": "blockSource.getBlockState().getValue(DispenserBlock.FACING)",
								"success": "true"
							}, false/>;
						<#else>
							<@procedureCode extension.dispenseResultItemstack, {
								"x": "x",
								"y": "y",
								"z": "z",
								"itemstack": "itemstack.copy()",
								"world": "world",
								"direction": "blockSource.getBlockState().getValue(DispenserBlock.FACING)",
								"success": "true"
							}/>
							itemstack.shrink(1);
							return itemstack;
						</#if>
					<#else>
						itemstack.shrink(1);
						return itemstack;
					</#if>
				}
			}
			</#if>
			);
			</#list>
			<#list specialentities as entity>
			DispenserBlock.registerBehavior(${JavaModName}Items.${entity.getModElement().getRegistryNameUpper()},
					new ${JavaModName}BoatDispenseItemBehavior(${JavaModName}Boat.Type.${entity.getModElement().getRegistryNameUpper()}));
			</#list>
		}
	</@javacompress>

	<#if specialentities?size != 0>
	public static class ${JavaModName}BoatDispenseItemBehavior extends DefaultDispenseItemBehavior {
		private final DefaultDispenseItemBehavior defaultDispenseItemBehavior = new DefaultDispenseItemBehavior();
		private final ${JavaModName}Boat.Type type;
		private final boolean isChestBoat;

		public ${JavaModName}BoatDispenseItemBehavior(${JavaModName}Boat.Type type) {
			this.type = type;
			this.isChestBoat = type.hasChest();
		}

		@Override
		public ItemStack execute(BlockSource blockSource, ItemStack stack) {
			Direction direction = blockSource.getBlockState().getValue(DispenserBlock.FACING);
			Level level = blockSource.getLevel();
			double d0 = blockSource.getPos().getX() + (double) direction.getStepX() * 1.125;
			double d1 = (double) blockSource.getPos().getY() + (double) direction.getStepY() * 1.125;
			double d2 = blockSource.getPos().getZ() + (double) direction.getStepZ() * 1.125;
			BlockPos blockpos = blockSource.getPos().relative(direction);
			double d3;
			if (level.getFluidState(blockpos).is(FluidTags.WATER)) {
				d3 = 1.0;
			} else {
				if (!level.getBlockState(blockpos).isAir() || !level.getFluidState(blockpos.below()).is(FluidTags.WATER)) {
					return this.defaultDispenseItemBehavior.dispense(blockSource, stack);
				}
				d3 = 0.0;
			}
			ItemStack itemstack = stack.split(1);
			<#if hasChestBoat && hasBoat>
			Boat boat = isChestBoat ? new ${JavaModName}ChestBoat(level, d0, d1 + d3, d2) : new ${JavaModName}Boat(level, d0, d1 + d3, d2);
			<#elseif hasChestBoat>
			Boat boat = new ${JavaModName}ChestBoat(level, d0, d1 + d3, d2);
			<#else>
			Boat boat = new ${JavaModName}Boat(level, d0, d1 + d3, d2);
			</#if>
			${variantSetterCode}
			boat.setYRot(direction.toYRot());
			level.addFreshEntity(boat);
			return stack;
		}

		@Override
		protected void playSound(BlockSource blockSource) {
			blockSource.getLevel().levelEvent(2000, blockSource.getPos(), 0);
		}
	}
	</#if>
}
</@javacompress>
