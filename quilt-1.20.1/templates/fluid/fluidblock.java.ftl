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
 # which will cause the template and the resulting code generator output files
 # to be licensed under the GNU General Public License without this special
 # exception.
-->

<#-- @formatter:off -->
<#include "../procedures.java.ftl">
<#include "../triggers.java.ftl">

package ${package}.block;

import net.minecraft.world.level.block.LiquidBlock;
import net.minecraft.world.level.block.state.BlockBehaviour;
import net.minecraft.world.level.material.MapColor;
import net.minecraft.world.level.block.SoundType;
import net.minecraft.world.level.material.PushReaction;

public class ${name}Block extends LiquidBlock {
	public ${name}Block() {
		super(${JavaModName}Fluids.${REGISTRYNAME},
			BlockBehaviour.Properties.of()
			<#if generator.map(data.colorOnMap, "mapcolors") != "DEFAULT">
			.mapColor(MapColor.${generator.map(data.colorOnMap, "mapcolors")})
			<#else>
			.mapColor(MapColor.${(data.type=="WATER")?then("WATER","FIRE")})
			</#if>
			.strength(${data.resistance}f)
			<#if data.luminance != 0>.lightLevel(s -> ${data.luminance})</#if>
			.noCollission().noLootTable().liquid().pushReaction(PushReaction.DESTROY).sound(SoundType.EMPTY).replaceable()
		);
	}

	<@onBlockAdded data.onBlockAdded, hasProcedure(data.onTickUpdate) && data.tickRate gt 0, data.tickRate/>

	<@onRedstoneOrNeighborChanged "", "", data.onNeighbourChanges/>

	<@onBlockTick data.onTickUpdate, data.tickRate gt 0, data.tickRate/>

	<@onEntityCollides data.onEntityCollides/>

	<@onAnimateTick data.onRandomUpdateEvent/>

	<@onDestroyedByExplosion data.onDestroyedByExplosion/>

	<#if hasProcedure(data.onBlockAdded) || hasProcedure(data.beforeReplacingBlock)>
	@Override public void onRemove(BlockState state, Level world, BlockPos pos, BlockState newState, boolean moving) {
		if (state.getBlock() != newState.getBlock()) {
			<#if hasProcedure(data.beforeReplacingBlock)>
			<@procedureCode data.beforeReplacingBlock, {
				"x": "pos.getX()",
				"y": "pos.getY()",
				"z": "pos.getZ()",
				"world": "world",
				"blockstate": "state"
			}/>
			<#elseif hasProcedure(data.onBlockAdded)>
			<@procedureCode data.onBlockAdded, {
				"x": "pos.getX()",
				"y": "pos.getY()",
				"z": "pos.getZ()",
				"world": "world",
				"blockstate": "state"
			}/>
			</#if>
		}
		super.onRemove(state, world, pos, newState, moving);
	}
	</#if>
}

<#-- @formatter:on -->