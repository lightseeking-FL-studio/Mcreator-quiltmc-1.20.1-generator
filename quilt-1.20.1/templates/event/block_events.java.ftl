<#-- @formatter:off -->
package ${package}.event;

import net.fabricmc.fabric.api.event.Event;
import net.fabricmc.fabric.api.event.EventFactory;
import net.minecraft.core.BlockPos;
import net.minecraft.world.entity.Entity;
import net.minecraft.world.level.block.state.BlockState;
import net.minecraft.world.level.LevelAccessor;
import net.minecraft.world.phys.Vec3;

public class BlockEvents {

	public static final Event<CropGrow> CROP_ATTEMPTS_GROWTH = EventFactory.createArrayBacked(CropGrow.class, (callbacks) -> (position, state, world) -> {
		for (CropGrow event : callbacks) {
			boolean result = event.onCropGrow(position, state, world);
			if (!result) {
				return false;
			}
		}
		return true;
	});

	public static final Event<BlockBreak> BLOCK_BREAK = EventFactory.createArrayBacked(BlockBreak.class, (callbacks) -> (world, pos, state, entity) -> {
		for (BlockBreak event : callbacks) {
			boolean result = event.onBlockBreak(world, pos, state, entity);
			if (!result) {
				return false;
			}
		}
		return true;
	});

	public static final Event<BlockMultiplace> BLOCK_MULTIPLACE = EventFactory.createArrayBacked(BlockMultiplace.class, (callbacks) -> (position, entity, placed, placedAgainst) -> {
		for (BlockMultiplace event : callbacks) {
			boolean result = event.onMultiplaced(position, entity, placed, placedAgainst);
			if (!result) {
				return false;
			}
		}
		return true;
	});

	public static final Event<BlockPlace> BLOCK_PLACE = EventFactory.createArrayBacked(BlockPlace.class, (callbacks) -> (position, entity, placed, placedAgainst) -> {
		for (BlockPlace event : callbacks) {
			boolean result = event.onBlockPlaced(position, entity, placed, placedAgainst);
			if (!result) {
				return false;
			}
		}
		return true;
	});

	public static final Event<ExplosionOccurs> EXPLOSION_OCCURS = EventFactory.createArrayBacked(ExplosionOccurs.class, (callbacks) -> (world, source, position, power) -> {
		for (ExplosionOccurs event : callbacks) {
			event.onExplosionOccurs(world, source, position, power);
		}
	});

	public static final Event<FarmlandTrample> FARMLAND_TRAMPLE = EventFactory.createArrayBacked(FarmlandTrample.class, (callbacks) -> (world, pos, state, entity, fallDistance) -> {
		for (FarmlandTrample event : callbacks) {
			boolean result = event.onFarmlandTrample(world, pos, state, entity, fallDistance);
			if (!result) {
				return false;
			}
		}
		return true;
	});

	public static final Event<BlockGrowsFeature> BLOCK_GROWS_FEATURE = EventFactory.createArrayBacked(BlockGrowsFeature.class, (callbacks) -> (world, pos, state) -> {
		for (BlockGrowsFeature event : callbacks) {
			event.onBlockGrowsFeature(world, pos, state);
		}
	});

	@FunctionalInterface
	public interface BlockBreak {
		boolean onBlockBreak(LevelAccessor world, BlockPos pos, BlockState state, Entity entity);
	}

	@FunctionalInterface
	public interface BlockMultiplace {
		boolean onMultiplaced(BlockPos position, Entity entity, BlockState placed, BlockState placedAgainst);
	}

	@FunctionalInterface
	public interface BlockPlace {
		boolean onBlockPlaced(BlockPos position, Entity entity, BlockState placed, BlockState placedAgainst);
	}

	@FunctionalInterface
	public interface CropGrow {
		boolean onCropGrow(BlockPos position, BlockState state, LevelAccessor world);
	}

	@FunctionalInterface
	public interface ExplosionOccurs {
		void onExplosionOccurs(LevelAccessor world, Entity source, Vec3 position, float power);
	}

	@FunctionalInterface
	public interface FarmlandTrample {
		boolean onFarmlandTrample(LevelAccessor world, BlockPos pos, BlockState state, Entity entity, float fallDistance);
	}

	@FunctionalInterface
	public interface BlockGrowsFeature {
		void onBlockGrowsFeature(LevelAccessor world, BlockPos pos, BlockState state);
	}
}
<#-- @formatter:on -->