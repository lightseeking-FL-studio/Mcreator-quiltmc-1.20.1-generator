<#-- @formatter:off -->
package ${package}.mixin;

import ${package}.event.BlockEvents;
import net.minecraft.world.level.levelgen.feature.ConfiguredFeature;
import net.minecraft.world.level.chunk.ChunkGenerator;
import net.minecraft.world.level.WorldGenLevel;
import net.minecraft.world.level.block.state.BlockState;
import net.minecraft.server.level.ServerLevel;
import net.minecraft.core.BlockPos;
import net.minecraft.util.RandomSource;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Unique;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

@Mixin(ConfiguredFeature.class)
public class ConfiguredFeatureMixin {

	@Unique
	private static final ThreadLocal<BlockState> th$capturedState = new ThreadLocal<>();

	/**
	 * @reason Capture the block state before the feature is placed
	 * @author MCreator Quilt Generator
	 */
	@Inject(method = "place(Lnet/minecraft/world/level/WorldGenLevel;Lnet/minecraft/world/level/chunk/ChunkGenerator;Lnet/minecraft/util/RandomSource;Lnet/minecraft/core/BlockPos;)Z", at = @At("HEAD"))
	private void onPlaceHead(WorldGenLevel level, ChunkGenerator generator, RandomSource random, BlockPos origin, CallbackInfoReturnable<Boolean> cir) {
		if (level instanceof ServerLevel) {
			th$capturedState.set(level.getBlockState(origin));
		}
	}

	/**
	 * @reason Fire BlockEvents.BLOCK_GROWS_FEATURE when a feature is placed on a ServerLevel (not world gen).
	 * This catches all cases: vanilla saplings, mushrooms, fungi, azalea, mangrove propagule,
	 * and any modded blocks that grow into features via ConfiguredFeature.place().
	 * @author MCreator Quilt Generator
	 */
	@Inject(method = "place(Lnet/minecraft/world/level/WorldGenLevel;Lnet/minecraft/world/level/chunk/ChunkGenerator;Lnet/minecraft/util/RandomSource;Lnet/minecraft/core/BlockPos;)Z", at = @At("RETURN"))
	private void onPlaceReturn(WorldGenLevel level, ChunkGenerator generator, RandomSource random, BlockPos origin, CallbackInfoReturnable<Boolean> cir) {
		BlockState state = th$capturedState.get();
		th$capturedState.remove();
		if (level instanceof ServerLevel serverLevel && cir.getReturnValue() && state != null) {
			BlockEvents.BLOCK_GROWS_FEATURE.invoker().onBlockGrowsFeature(serverLevel, origin, state);
		}
	}
}
<#-- @formatter:on -->