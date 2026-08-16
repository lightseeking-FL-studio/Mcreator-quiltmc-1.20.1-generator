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

package ${package}.block;

import net.minecraft.world.level.block.state.BlockBehaviour.Properties;
import net.minecraft.core.registries.BuiltInRegistries;
import net.minecraft.resources.ResourceKey;
import net.minecraft.world.level.Level;
import net.mcreator.testdiwu.world.dimension.${name}Dimension;

public class ${name}PortalBlock extends NetherPortalBlock {

	public ${name}PortalBlock() {
		super(BlockBehaviour.Properties.of().noCollission().randomTicks().pushReaction(PushReaction.BLOCK)
				.strength(-1.0F).sound(SoundType.GLASS).lightLevel(s -> ${data.portalLuminance}).noLootTable());
	}


	@Override public void randomTick(BlockState blockstate, ServerLevel world, BlockPos pos, RandomSource random) {
		<#-- Do not call super to prevent ZOMBIFIED_PIGLINs from spawning -->
		<#if hasProcedure(data.onPortalTickUpdate)>
			<@procedureCode data.onPortalTickUpdate, {
				"x": "pos.getX()",
				"y": "pos.getY()",
				"z": "pos.getZ()",
				"world": "world",
				"blockstate": "blockstate"
			}/>
		</#if>
	}

	public static void portalSpawn(Level world, BlockPos pos) {
		Optional<${name}PortalShape> optional = ${name}PortalShape.findEmptyPortalShape(world, pos, Direction.Axis.X);
		if (optional.isPresent()) {
			optional.get().createPortalBlocks();
		}
	}

	@Override public BlockState updateShape(BlockState state, Direction direction, BlockState neighborState, LevelAccessor world, BlockPos pos, BlockPos neighborPos) {
		Direction.Axis direction$axis = direction.getAxis();
		Direction.Axis direction$axis1 = state.getValue(AXIS);
		boolean flag = direction$axis1 != direction$axis && direction$axis.isHorizontal();
		return flag && !new ${name}PortalShape(world, pos, direction$axis1).isValid() ? Blocks.AIR.defaultBlockState() : super.updateShape(state, direction, neighborState, world, pos, neighborPos);
	}

	@Environment(EnvType.CLIENT) @Override public void animateTick(BlockState state, Level world, BlockPos pos, RandomSource random) {
		for (int i = 0; i < 4; i++) {
			double px = pos.getX() + random.nextFloat();
			double py = pos.getY() + random.nextFloat();
			double pz = pos.getZ() + random.nextFloat();
			double vx = (random.nextFloat() - 0.5) / 2.;
			double vy = (random.nextFloat() - 0.5) / 2.;
			double vz = (random.nextFloat() - 0.5) / 2.;
			int j = random.nextInt(4) - 1;
			if (world.getBlockState(pos.west()).getBlock() != this
					&& world.getBlockState(pos.east()).getBlock() != this) {
				px = pos.getX() + 0.5 + 0.25 * j;
				vx = random.nextFloat() * 2 * j;
			} else {
				pz = pos.getZ() + 0.5 + 0.25 * j;
				vz = random.nextFloat() * 2 * j;
			}
			world.addParticle(${data.portalParticles}, px, py, pz, vx, vy, vz);
		}

		<#if data.portalSound.toString()?has_content>
		if (random.nextInt(110) == 0)
			world.playSound(null, pos.getX() + 0.5, pos.getY() + 0.5, pos.getZ() + 0.5,
					BuiltInRegistries.SOUND_EVENT.get(new ResourceLocation("${data.portalSound}")), SoundSource.BLOCKS, 0.5f,
					random.nextFloat() * 0.4f + 0.8f);
        </#if>
	}

	@Override public void entityInside(BlockState state, Level world, BlockPos pos, Entity entity) {
		if (<#if hasProcedure(data.portalUseCondition)><@procedureCode data.portalUseCondition, {
        		"x": "pos.getX()",
        		"y": "pos.getY()",
        		"z": "pos.getZ()",
        		"entity": "entity",
        		"world": "world"
        		}, false/> && </#if>entity.canChangeDimensions() && !entity.level().isClientSide()) {
			if (entity.isOnPortalCooldown()) {
				entity.setPortalCooldown();
			} else if (entity.level().dimension() != ResourceKey.create(Registries.DIMENSION, new ResourceLocation("${modid}:${registryname}"))) {
				entity.setPortalCooldown();
				teleportToDimension(entity, pos, ResourceKey.create(Registries.DIMENSION, new ResourceLocation("${modid}:${registryname}")));
			} else {
				entity.setPortalCooldown();
				teleportToDimension(entity, pos, Level.OVERWORLD);
			}
		}
	}

	private void teleportToDimension(Entity entity, BlockPos pos, ResourceKey<Level> destinationType) {
		ServerLevel destination = entity.getServer().getLevel(destinationType);
		if (destination != null) {
			ResourceKey<Level> from = entity.level().dimension();
			if (entity instanceof ServerPlayer player) {
				double scale = net.minecraft.world.level.dimension.DimensionType.getTeleportationScale(entity.level().dimensionType(), destination.dimensionType());
				double targetX = entity.getX() * scale;
				double targetY = entity.getY();
				double targetZ = entity.getZ() * scale;
				player.teleportTo(destination, targetX, targetY, targetZ, player.getYRot(), player.getXRot());
				player.connection.resetPosition();
				${name}Dimension.onPlayerChangedDimensionEvent(player, from, destinationType);
			} else {
				entity.changeDimension(destination);
			}
		}
	}

}

<#-- @formatter:on -->