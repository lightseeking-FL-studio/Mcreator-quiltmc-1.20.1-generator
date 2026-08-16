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
 # that work under terms of your choice, so long as that work isn''t itself a
 # template for code generation. Alternatively, if you modify or redistribute
 # the template itself, you may (at your option) remove this special exception,
 # which will cause the template and the resulting code generator output files
 # to be licensed under the GNU General Public License without this special
 # exception.
-->

<#-- @formatter:off -->
<#include "../mcitems.ftl">

package ${package}.world.teleporter;

public class ${name}Teleporter {

	public static final TicketType<BlockPos> CUSTOM_PORTAL = TicketType.create("${registryname}_portal", Vec3i::compareTo, 300);

	private final ServerLevel level;
	private final BlockPos entityEnterPos;

	public ${name}Teleporter(ServerLevel worldServer, BlockPos entityEnterPos) {
		this.level = worldServer;
		this.entityEnterPos = entityEnterPos;
	}

	public Optional<BlockUtil.FoundRectangle> findPortalAround(BlockPos blockPos, boolean bl, WorldBorder worldBorder) {
		int searchRadius = bl ? 16 : 128;
		BlockPos nearestPortal = null;
		double nearestDist = Double.MAX_VALUE;
		BlockPos.MutableBlockPos mutable = new BlockPos.MutableBlockPos();
		int playerY = blockPos.getY();
		int minY = Math.max(this.level.getMinBuildHeight(), playerY - searchRadius);
		int maxY = Math.min(this.level.getMaxBuildHeight() - 1, playerY + searchRadius);
		int centerChunkX = SectionPos.blockToSectionCoord(blockPos.getX());
		int centerChunkZ = SectionPos.blockToSectionCoord(blockPos.getZ());
		int chunkRadius = SectionPos.blockToSectionCoord(searchRadius) + 1;

		for (int cx = centerChunkX - chunkRadius; cx <= centerChunkX + chunkRadius; cx++) {
			for (int cz = centerChunkZ - chunkRadius; cz <= centerChunkZ + chunkRadius; cz++) {
				if (!this.level.hasChunk(cx, cz))
					continue;
				int startX = cx << 4;
				int startZ = cz << 4;
				for (int x = 0; x < 16; x++) {
					for (int z = 0; z < 16; z++) {
						int worldX = startX + x;
						int worldZ = startZ + z;
						int dx = worldX - blockPos.getX();
						int dz = worldZ - blockPos.getZ();
						if (dx * dx + dz * dz > searchRadius * searchRadius)
							continue;
						for (int y = minY; y <= maxY; y++) {
							mutable.set(worldX, y, worldZ);
							if (this.level.getBlockState(mutable).is(${JavaModName}Blocks.${REGISTRYNAME}_PORTAL)) {
								double dist = blockPos.distSqr(mutable);
								if (dist < nearestDist && worldBorder.isWithinBounds(mutable)) {
									nearestDist = dist;
									nearestPortal = mutable.immutable();
								}
							}
						}
					}
				}
			}
		}

		if (nearestPortal == null)
			return Optional.empty();

		final BlockPos portalPos = nearestPortal;
		this.level.getChunkSource().addRegionTicket(CUSTOM_PORTAL, new ChunkPos(portalPos), 3, portalPos);
		BlockState blockState = this.level.getBlockState(portalPos);
		return Optional.of(BlockUtil.getLargestRectangleAround(
			portalPos,
			(Direction.Axis) blockState.getValue(BlockStateProperties.HORIZONTAL_AXIS),
			21,
			Direction.Axis.Y,
			21,
			pos -> this.level.getBlockState(pos) == blockState
		));
	}

	public Optional<BlockUtil.FoundRectangle> createPortal(BlockPos blockPos, Direction.Axis axis) {
		Direction direction = Direction.get(Direction.AxisDirection.POSITIVE, axis);
		double d = -1.0;
		BlockPos blockPos2 = null;
		double e = -1.0;
		BlockPos blockPos3 = null;
		WorldBorder worldBorder = this.level.getWorldBorder();
		int i = Math.min(this.level.getMaxBuildHeight(), this.level.getMinBuildHeight() + this.level.getLogicalHeight()) - 1;
		BlockPos.MutableBlockPos mutableBlockPos = blockPos.mutable();

		for (BlockPos.MutableBlockPos mutableBlockPos2 : BlockPos.spiralAround(blockPos, 16, Direction.EAST, Direction.SOUTH)) {
			int j = Math.min(i, this.level.getHeight(Heightmap.Types.MOTION_BLOCKING, mutableBlockPos2.getX(), mutableBlockPos2.getZ()));
			int k = 1;
			if (worldBorder.isWithinBounds(mutableBlockPos2) && worldBorder.isWithinBounds(mutableBlockPos2.move(direction, 1))) {
				mutableBlockPos2.move(direction.getOpposite(), 1);

				for (int l = j; l >= this.level.getMinBuildHeight(); l--) {
					mutableBlockPos2.setY(l);
					if (this.canPortalReplaceBlock(mutableBlockPos2)) {
						int m = l;

						while (l > this.level.getMinBuildHeight() && this.canPortalReplaceBlock(mutableBlockPos2.move(Direction.DOWN))) {
							l--;
						}

						if (l + 4 <= i) {
							int n = m - l;
							if (n <= 0 || n >= 3) {
								mutableBlockPos2.setY(l);
								if (this.canHostFrame(mutableBlockPos2, mutableBlockPos, direction, 0)) {
									double f = blockPos.distSqr(mutableBlockPos2);
									if (this.canHostFrame(mutableBlockPos2, mutableBlockPos, direction, -1)
										&& this.canHostFrame(mutableBlockPos2, mutableBlockPos, direction, 1)
										&& (d == -1.0 || d > f)) {
										d = f;
										blockPos2 = mutableBlockPos2.immutable();
									}

									if (d == -1.0 && (e == -1.0 || e > f)) {
										e = f;
										blockPos3 = mutableBlockPos2.immutable();
									}
								}
							}
						}
					}
				}
			}
		}

		if (d == -1.0 && e != -1.0) {
			blockPos2 = blockPos3;
			d = e;
		}

		if (d == -1.0) {
			int o = Math.max(this.level.getMinBuildHeight() - -1, 70);
			int p = i - 9;
			if (p < o) {
				return Optional.empty();
			}

			blockPos2 = new BlockPos(blockPos.getX(), Mth.clamp(blockPos.getY(), o, p), blockPos.getZ()).immutable();
			Direction direction2 = direction.getClockWise();
			if (!worldBorder.isWithinBounds(blockPos2)) {
				return Optional.empty();
			}

			for (int k = -1; k < 2; k++) {
				for (int lx = 0; lx < 2; lx++) {
					for (int m = -1; m < 3; m++) {
						BlockState blockState = m < 0 ? ${mappedBlockToBlock(data.portalFrame)?string}.defaultBlockState() : Blocks.AIR.defaultBlockState();
						mutableBlockPos.setWithOffset(
							blockPos2, lx * direction.getStepX() + k * direction2.getStepX(), m, lx * direction.getStepZ() + k * direction2.getStepZ()
						);
						this.level.setBlockAndUpdate(mutableBlockPos, blockState);
					}
				}
			}
		}

		for (int ox = -1; ox < 3; ox++) {
			for (int px = -1; px < 4; px++) {
				if (ox == -1 || ox == 2 || px == -1 || px == 3) {
					mutableBlockPos.setWithOffset(blockPos2, ox * direction.getStepX(), px, ox * direction.getStepZ());
					this.level.setBlock(mutableBlockPos, ${mappedBlockToBlock(data.portalFrame)?string}.defaultBlockState(), 3);
				}
			}
		}

		BlockState blockState2 = (BlockState) ${JavaModName}Blocks.${REGISTRYNAME}_PORTAL.defaultBlockState().setValue(NetherPortalBlock.AXIS, axis);

		for (int pxx = 0; pxx < 2; pxx++) {
			for (int j = 0; j < 3; j++) {
				mutableBlockPos.setWithOffset(blockPos2, pxx * direction.getStepX(), j, pxx * direction.getStepZ());
				this.level.setBlock(mutableBlockPos, blockState2, 18);
			}
		}

		return Optional.of(new BlockUtil.FoundRectangle(blockPos2.immutable(), 2, 3));
	}

	private boolean canHostFrame(BlockPos blockPos, BlockPos.MutableBlockPos mutableBlockPos, Direction direction, int i) {
		Direction direction2 = direction.getClockWise();

		for (int j = -1; j < 3; j++) {
			for (int k = -1; k < 4; k++) {
				mutableBlockPos.setWithOffset(
					blockPos, direction.getStepX() * j + direction2.getStepX() * i, k, direction.getStepZ() * j + direction2.getStepZ() * i
				);
				if (k < 0 && !this.level.getBlockState(mutableBlockPos).isSolid()) {
					return false;
				}

				if (k >= 0 && !this.canPortalReplaceBlock(mutableBlockPos)) {
					return false;
				}
			}
		}

		return true;
	}

	public Entity placeEntity(Entity entity, ServerLevel currentWorld, ServerLevel server, float yaw,
			Function<Boolean, Entity> repositionEntity) {
		PortalInfo portalinfo = getPortalInfo(entity, server);

		if (entity instanceof ServerPlayer player) {
			player.setServerLevel(server);
			server.addDuringPortalTeleport(player);

			player.connection.teleport(portalinfo.pos.x, portalinfo.pos.y, portalinfo.pos.z, portalinfo.yRot, portalinfo.xRot);
			player.connection.resetPosition();

			CriteriaTriggers.CHANGED_DIMENSION.trigger(player, currentWorld.dimension(), server.dimension());

			return entity;
		} else {
			Entity entityNew = entity.getType().create(server);
			if (entityNew != null) {
				entityNew.restoreFrom(entity);
				entityNew.moveTo(portalinfo.pos.x, portalinfo.pos.y, portalinfo.pos.z, portalinfo.yRot, entityNew.getXRot());
				entityNew.setDeltaMovement(portalinfo.speed);
				server.addDuringTeleport(entityNew);
			}
			return entityNew;
		}
	}

	private PortalInfo getPortalInfo(Entity entity, ServerLevel server) {
		WorldBorder worldborder = server.getWorldBorder();
		double d0 = DimensionType.getTeleportationScale(entity.level().dimensionType(), server.dimensionType());
		BlockPos blockpos1 = worldborder.clampToBounds(entity.getX() * d0, entity.getY(), entity.getZ() * d0);
		return this.getExitPortal(entity, blockpos1, worldborder).map(repositioner -> {
			BlockState blockstate = entity.level().getBlockState(this.entityEnterPos);
			Direction.Axis direction$axis;
			Vec3 vector3d;

			if (blockstate.hasProperty(BlockStateProperties.HORIZONTAL_AXIS)) {
				direction$axis = blockstate.getValue(BlockStateProperties.HORIZONTAL_AXIS);
				BlockUtil.FoundRectangle teleportationrepositioner$result = BlockUtil.getLargestRectangleAround(this.entityEnterPos, direction$axis, 21, Direction.Axis.Y, 21,
								pos -> entity.level().getBlockState(pos) == blockstate);
				vector3d = ${name}PortalShape.getRelativePosition(teleportationrepositioner$result, direction$axis, entity.position(), entity.getDimensions(entity.getPose()));
			} else {
				direction$axis = Direction.Axis.X;
				vector3d = new Vec3(0.5, 0, 0);
			}

			return ${name}PortalShape.createPortalInfo(server, repositioner, direction$axis, vector3d, entity, entity.getDeltaMovement(), entity.getYRot(), entity.getXRot());
		}).orElseGet(() -> new PortalInfo(entity.position(), Vec3.ZERO, entity.getYRot(), entity.getXRot()));
	}

	protected Optional<BlockUtil.FoundRectangle> getExitPortal(Entity entity, BlockPos pos, WorldBorder worldBorder) {
		Optional<BlockUtil.FoundRectangle> optional = this.findPortalAround(pos, false, worldBorder);

		if (entity instanceof ServerPlayer) {
			if (optional.isPresent()) {
				return optional;
			} else {
				Direction.Axis direction$axis = entity.level().getBlockState(this.entityEnterPos).getOptionalValue(NetherPortalBlock.AXIS).orElse(Direction.Axis.X);
				return this.createPortal(pos, direction$axis);
			}
		} else {
			return optional;
		}
	}

	private boolean canPortalReplaceBlock(BlockPos.MutableBlockPos pos) {
		BlockState blockstate = this.level.getBlockState(pos);
		return blockstate.canBeReplaced() && blockstate.getFluidState().isEmpty();
	}

}
<#-- @formatter:on -->

