<#-- @formatter:off -->
<#include "../procedures.java.ftl">

<#assign fluidsWithTick = []>
<#list w.getGElementsOfType("fluid") as fluid>
	<#if hasProcedure(fluid.onTickUpdate)>
		<#assign fluidsWithTick += [fluid]>
	</#if>
</#list>

package ${package}.mixin;

import net.minecraft.world.level.Level;
import net.minecraft.core.BlockPos;
import net.minecraft.world.level.material.FluidState;
import net.minecraft.world.level.material.FlowingFluid;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

@Mixin(FlowingFluid.class)
public class FlowingFluidMixin {

	<#if fluidsWithTick?size != 0>
	@Inject(method = "tick(Lnet/minecraft/world/level/Level;Lnet/minecraft/core/BlockPos;Lnet/minecraft/world/level/material/FluidState;)V", at = @At("TAIL"))
	private void onFluidTick(Level world, BlockPos pos, FluidState state, CallbackInfo ci) {
		<#list fluidsWithTick as fluid>
		if (world.getBlockState(pos).getBlock() == ${JavaModName}Blocks.${fluid.getModElement().getRegistryNameUpper()}) {
			<@procedureCode fluid.onTickUpdate, {
				"x": "pos.getX()",
				"y": "pos.getY()",
				"z": "pos.getZ()",
				"world": "world",
				"blockstate": "world.getBlockState(pos)"
			}/>
		}
		</#list>
	}
	</#if>
}
<#-- @formatter:on -->