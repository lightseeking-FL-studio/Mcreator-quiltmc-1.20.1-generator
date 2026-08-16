<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2023, Pylo, opensource contributors
 # Copyright (C) 2026, htqkeku, Lightseeking(FL) Studio — Fuel burnSuccessCondition (HEAD hide / RETURN restore)
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
<#include "../procedures.java.ftl">
<#assign itemextensions = w.getGElementsOfType("itemextension")>
<#assign hasFuelCondition = itemextensions?filter(e -> e.enableFuel && ((e.fuelSuccessCondition?? && hasProcedure(e.fuelSuccessCondition)) || (e.fuelBurnCondition?? && hasProcedure(e.fuelBurnCondition))))?size != 0>

/*
 *    MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.mixin;

import ${package}.event.ItemEvents;
import net.minecraft.world.entity.player.Player;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.level.Level;
import net.minecraft.world.level.block.entity.AbstractFurnaceBlockEntity;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Unique;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;
<#if hasFuelCondition>
import net.minecraft.core.BlockPos;
import net.minecraft.world.level.block.state.BlockState;
import net.minecraft.world.level.block.AbstractFurnaceBlock;
</#if>

import java.util.Map;
import java.util.WeakHashMap;
import java.util.concurrent.ConcurrentHashMap;

@Mixin(AbstractFurnaceBlockEntity.class)
public class AbstractFurnaceBlockEntityMixin {

	@Unique
	private static final Map<BlockPos, ItemStack> th$lastOutputs = new WeakHashMap<>();

	@Inject(method = "serverTick", at = @At("TAIL"))
	private static void onServerTick(Level level, BlockPos pos, BlockState state, AbstractFurnaceBlockEntity blockEntity, CallbackInfo ci) {
		if (level.isClientSide()) return;

		ItemStack currentOutput = blockEntity.getItem(2);
		ItemStack lastOutput = th$lastOutputs.getOrDefault(pos, ItemStack.EMPTY);
		if (!currentOutput.isEmpty() && currentOutput.getCount() > (lastOutput == null ? 0 : lastOutput.getCount())) {
			Player nearestPlayer = level.getNearestPlayer(pos.getX(), pos.getY(), pos.getZ(), 8.0, false);
			if (nearestPlayer != null) {
				ItemEvents.ITEM_SMELTED.invoker().onItemSmelted(nearestPlayer, currentOutput.copy());
			}
		}
		th$lastOutputs.put(pos, currentOutput.copy());
	}

<#if hasFuelCondition>
	// Strong references — fuel backup NEVER lost to GC.
	@Unique
	private static final Map<BlockPos, ItemStack> th$hiddenFuel = new ConcurrentHashMap<>();

	@Inject(method = "serverTick", at = @At(value = "HEAD"))
	private static void th$fuelCheck_head(Level level, BlockPos pos, BlockState state, AbstractFurnaceBlockEntity blockEntity, CallbackInfo ci) {
		if (level.isClientSide()) return;

		// Only intervene when furnace is NOT currently burning.
		// If LIT=true, a fuel is already being consumed — let it finish.
		boolean isBurning = false;
		try {
			isBurning = state.getValue(AbstractFurnaceBlock.LIT);
		} catch (Throwable ignored) {
			// Fallback: if LIT property not found, always check
			isBurning = false;
		}
		if (isBurning) return;

		ItemStack fuel = blockEntity.getItem(1);
		if (fuel == null || fuel.isEmpty()) return;

		int overrideBurn = th$checkCondition(fuel, level, pos);
		if (overrideBurn == 0) {
			// Condition forbids burning. Temporarily hide fuel for THIS tick only.
			// serverTick will see empty slot → won't ignite.
			// RETURN injection below restores it before tick ends → client sees fuel.
			th$hiddenFuel.put(pos, fuel.copy());
			blockEntity.setItem(1, ItemStack.EMPTY);
		}
	}

	@Inject(method = "serverTick", at = @At(value = "RETURN"))
	private static void th$fuelCheck_return(Level level, BlockPos pos, BlockState state, AbstractFurnaceBlockEntity blockEntity, CallbackInfo ci) {
		if (level.isClientSide()) return;

		ItemStack saved = th$hiddenFuel.remove(pos);
		if (saved == null || saved.isEmpty()) return;

		ItemStack current = blockEntity.getItem(1);
		if (current == null || current.isEmpty()) {
			blockEntity.setItem(1, saved.copy());
		} else if (ItemStack.isSameItemSameTags(current, saved)) {
			current.grow(saved.getCount());
		} else {
			// Different item in slot now — drop saved fuel as item entity
			level.addFreshEntity(new net.minecraft.world.entity.item.ItemEntity(
					level,
					pos.getX() + 0.5,
					pos.getY() + 0.7,
					pos.getZ() + 0.5,
					saved.copy()));
		}
	}

	@Unique
	private static int th$checkCondition(ItemStack fuelStack, Level level, BlockPos pos) {
		try {
			Class<?> cls = Class.forName("${package}.init.${JavaModName}ItemExtensions");
			Object res = cls.getMethod("checkFuelBurnCondition",
					ItemStack.class, Level.class, BlockPos.class)
					.invoke(null, fuelStack, level, pos);
			return ((java.lang.Integer) res).intValue();
		} catch (Throwable t) {
			return -1;
		}
	}
</#if>
}
<#-- @formatter:on -->
