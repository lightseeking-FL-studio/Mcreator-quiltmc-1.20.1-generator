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

package ${package}.fluid;

import net.minecraft.core.BlockPos;
import net.minecraft.core.Direction;
import net.minecraft.world.item.Item;
import net.minecraft.world.item.Items;
import net.minecraft.world.level.BlockGetter;
import net.minecraft.world.level.Level;
import net.minecraft.world.level.LevelAccessor;
import net.minecraft.world.level.LevelReader;
import net.minecraft.world.level.block.LiquidBlock;
import net.minecraft.world.level.block.state.BlockState;
import net.minecraft.world.level.block.state.StateDefinition;
import net.minecraft.world.level.GameRules;
import net.minecraft.world.level.material.FlowingFluid;
import net.minecraft.world.level.material.Fluid;
import net.minecraft.world.level.material.FluidState;

public abstract class ${name}Fluid extends FlowingFluid {

	public ${name}Fluid() {
	}

	@Override public abstract Fluid getSource();

	@Override public abstract Fluid getFlowing();

	@Override public boolean isSame(Fluid fluid) {
		return fluid == getSource() || fluid == getFlowing();
	}

	@Override protected void createFluidStateDefinition(StateDefinition.Builder<Fluid, FluidState> builder) {
		super.createFluidStateDefinition(builder);
		builder.add(LEVEL);
	}

	@Override protected void beforeDestroyingBlock(LevelAccessor world, BlockPos pos, BlockState blockstate) {
		<#if hasProcedure(data.beforeReplacingBlock)>
		<@procedureCode data.beforeReplacingBlock, {
			"x": "pos.getX()",
			"y": "pos.getY()",
			"z": "pos.getZ()",
			"world": "world",
			"blockstate": "blockstate"
		}/>
		<#elseif hasProcedure(data.onBlockAdded)>
		<@procedureCode data.onBlockAdded, {
			"x": "pos.getX()",
			"y": "pos.getY()",
			"z": "pos.getZ()",
			"world": "world",
			"blockstate": "blockstate"
		}/>
		</#if>
	}

	@Override protected boolean canConvertToSource(Level world) {
		<#if data.type == "WATER">
		return world.getGameRules().getBoolean(GameRules.RULE_WATER_SOURCE_CONVERSION);
		<#else>
		return false;
		</#if>
	}

	@Override public int getTickDelay(LevelReader world) {
		<#if data.type == "LAVA" && data.flowRate == 5>
		return world instanceof Level && ((Level) world).dimension() == Level.NETHER ? 10 : 30;
		<#else>
		return ${data.flowRate};
		</#if>
	}

	@Override public float getExplosionResistance() {
		return ${data.resistance}f;
	}

	@Override protected BlockState createLegacyBlock(FluidState state) {
		return ${JavaModName}Blocks.${REGISTRYNAME}.defaultBlockState().setValue(LiquidBlock.LEVEL, getLegacyLevel(state));
	}

	@Override protected boolean canBeReplacedWith(FluidState state, BlockGetter world, BlockPos pos, Fluid fluid, Direction direction) {
		<#if data.type == "WATER">
		return direction == Direction.DOWN && fluid.isSame(net.minecraft.tags.FluidTags.WATER);
		<#else>
		return false;
		</#if>
	}

	<#if data.type == "LAVA">
	@Override public int getDropOff(LevelReader world) {
		return world instanceof Level && ((Level) world).dimension() == Level.NETHER ? 1 : 2;
	}
	</#if>

	<#if data.spawnParticles>
	@Override public net.minecraft.core.particles.ParticleOptions getDripParticle() {
		return ${data.dripParticle};
	}
	</#if>

	public static class Source extends ${name}Fluid {
		@Override public Fluid getSource() {
			return ${JavaModName}Fluids.${REGISTRYNAME};
		}

		@Override public Fluid getFlowing() {
			return ${JavaModName}Fluids.FLOWING_${REGISTRYNAME};
		}

		@Override public int getAmount(FluidState state) {
			return 8;
		}

		@Override public boolean isSource(FluidState state) {
			return true;
		}

		<#if data.type != "LAVA">
		@Override public int getDropOff(LevelReader world) {
			return 0;
		}
		</#if>

		@Override protected int getSlopeFindDistance(LevelReader world) {
			return ${data.slopeFindDistance};
		}

		@Override public Item getBucket() {
			<#if data.generateBucket>return ${JavaModName}Items.${REGISTRYNAME}_BUCKET;<#else>return Items.BUCKET;</#if>
		}
	}

	public static class Flowing extends ${name}Fluid {
		@Override public Fluid getSource() {
			return ${JavaModName}Fluids.${REGISTRYNAME};
		}

		@Override public Fluid getFlowing() {
			return ${JavaModName}Fluids.FLOWING_${REGISTRYNAME};
		}

		@Override public int getAmount(FluidState state) {
			return state.getValue(LEVEL);
		}

		@Override public boolean isSource(FluidState state) {
			return false;
		}

		@Override public int getDropOff(LevelReader world) {
			return ${data.levelDecrease};
		}

		@Override protected int getSlopeFindDistance(LevelReader world) {
			return ${data.slopeFindDistance};
		}

		@Override public Item getBucket() {
			<#if data.generateBucket>return ${JavaModName}Items.${REGISTRYNAME}_BUCKET;<#else>return Items.BUCKET;</#if>
		}
	}
}

<#-- @formatter:on -->
