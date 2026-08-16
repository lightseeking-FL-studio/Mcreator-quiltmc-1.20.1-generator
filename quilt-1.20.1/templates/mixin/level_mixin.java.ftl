<#-- @formatter:off -->
package ${package}.mixin;

import ${package}.event.BlockEvents;
import ${package}.event.LivingEntityEvents;
import net.minecraft.core.BlockPos;
import net.minecraft.world.entity.Entity;
import net.minecraft.world.entity.LivingEntity;
import net.minecraft.world.entity.animal.Sheep;
import net.minecraft.world.entity.animal.SnowGolem;
import net.minecraft.world.level.Level;
import net.minecraft.world.level.block.Blocks;
import net.minecraft.world.level.block.state.BlockState;
import net.minecraft.world.phys.AABB;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Unique;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

@Mixin(Level.class)
public class LevelMixin {

	@Unique
	private BlockPos th$lastBreakPos = null;
	@Unique
	private long th$lastBreakTime = 0;
	@Unique
	private BlockPos th$lastSnowPos = null;
	@Unique
	private long th$lastSnowTime = 0;

	/**
	 * @reason Fire BlockEvents.BLOCK_BREAK when any block is destroyed by any means
	 * (player, explosion, enderman, water, piston, etc.).
	 * Skips TNT block removal on ignition to avoid triggering on ignition, only counts actual
	 * destroyed blocks from explosions, mobs, player, etc.
	 * Deduplicates by position within 2 ticks.
	 * @author MCreator Quilt Generator
	 */
	@Inject(method = "setBlock(Lnet/minecraft/core/BlockPos;Lnet/minecraft/world/level/block/state/BlockState;II)Z", at = @At("HEAD"), cancellable = true)
	private void onSetBlock(BlockPos pos, BlockState newState, int flags, int recursion, CallbackInfoReturnable<Boolean> cir) {
		Level self = (Level) (Object) this;
		if (self.isClientSide()) return; // Only run on server to avoid duplicates
		BlockState oldState = self.getBlockState(pos);
		if (!oldState.isAir() && newState.isAir()) {
			// Skip TNT block removal on ignition to avoid double trigger with explosion
			if (oldState.getBlock() == net.minecraft.world.level.block.Blocks.TNT) return;
			long now = self.getGameTime();
			if (th$lastBreakPos != null && th$lastBreakPos.equals(pos) && now - th$lastBreakTime < 2) {
				return; // Skip duplicate within 2 ticks
			}
			th$lastBreakPos = pos.immutable();
			th$lastBreakTime = now;
			if (!BlockEvents.BLOCK_BREAK.invoker().onBlockBreak(self, pos, oldState, null)) {
				cir.setReturnValue(false);
			}
		}
	}

	/**
	 * @reason Fire LivingEntityEvents.ENTITY_GRIEF when any non-player living entity
	 * destroys a block via Level.destroyBlock(). This covers ravager block breaking,
	 * silverfish hiding, enderman picking up blocks, wither explosions, etc.
	 * Uses HEAD injection to catch the entity before the block is actually destroyed.
	 * @author MCreator Quilt Generator
	 */
	@Inject(method = "destroyBlock(Lnet/minecraft/core/BlockPos;ZLnet/minecraft/world/entity/Entity;I)Z", at = @At("HEAD"))
	private void onDestroyBlock(BlockPos pos, boolean dropExperience, Entity entity, int unused, CallbackInfoReturnable<Boolean> cir) {
		Level self = (Level) (Object) this;
		if (self.isClientSide()) return;
		if (entity instanceof LivingEntity living && !(entity instanceof net.minecraft.world.entity.player.Player)) {
			LivingEntityEvents.ENTITY_GRIEF.invoker().onEntityGrief(living);
		}
	}

	/**
	 * @reason Fire LivingEntityEvents.ENTITY_GRIEF when a sheep eats grass.
	 * Sheep eating grass changes a GRASS_BLOCK to DIRT via Level.setBlock.
	 * We detect this specific block change and check if a sheep is standing on it.
	 * Uses HEAD injection to catch the block change before it happens.
	 * @author MCreator Quilt Generator
	 */
	@Inject(method = "setBlock(Lnet/minecraft/core/BlockPos;Lnet/minecraft/world/level/block/state/BlockState;II)Z", at = @At("HEAD"))
	private void onSheepEatGrass(BlockPos pos, BlockState newState, int flags, int recursion, CallbackInfoReturnable<Boolean> cir) {
		Level self = (Level) (Object) this;
		if (self.isClientSide()) return;
		BlockState oldState = self.getBlockState(pos);
		if (oldState.is(Blocks.GRASS_BLOCK) && newState.is(Blocks.DIRT)) {
			AABB box = new AABB(pos).inflate(0.5D);
			for (Sheep sheep : self.getEntitiesOfClass(Sheep.class, box)) {
				LivingEntityEvents.ENTITY_GRIEF.invoker().onEntityGrief(sheep);
				break;
			}
		}
	}

	/**
	 * @reason Fire LivingEntityEvents.ENTITY_GRIEF when a snow golem leaves snow while walking.
	 * Snow golems place snow blocks when moving over air. We detect this specific block
	 * placement and check if a snow golem is standing exactly on that block.
	 * Only triggers when old state is AIR, excluding player-placed snow or snow replacing
	 * existing blocks.
	 * Uses HEAD injection to catch the block placement and deduplicates by position.
	 * @author MCreator Quilt Generator
	 */
	@Inject(method = "setBlock(Lnet/minecraft/core/BlockPos;Lnet/minecraft/world/level/block/state/BlockState;II)Z", at = @At("HEAD"))
	private void onSnowGolemPlaceSnow(BlockPos pos, BlockState newState, int flags, int recursion, CallbackInfoReturnable<Boolean> cir) {
		Level self = (Level) (Object) this;
		if (self.isClientSide()) return;
		BlockState oldState = self.getBlockState(pos);
		if (oldState.isAir() && newState.is(Blocks.SNOW)) {
			long now = self.getGameTime();
			if (th$lastSnowPos != null && th$lastSnowPos.equals(pos) && now - th$lastSnowTime < 20) {
				return; // Skip duplicate within 20 ticks
			}
			th$lastSnowPos = pos.immutable();
			th$lastSnowTime = now;
			AABB box = new AABB(pos).inflate(0.5D);
			for (SnowGolem snowGolem : self.getEntitiesOfClass(SnowGolem.class, box)) {
				BlockPos golemPos = snowGolem.blockPosition();
				if (golemPos.equals(pos) || golemPos.below().equals(pos)) {
					LivingEntityEvents.ENTITY_GRIEF.invoker().onEntityGrief(snowGolem);
					break;
				}
			}
		}
	}
}
<#-- @formatter:on -->