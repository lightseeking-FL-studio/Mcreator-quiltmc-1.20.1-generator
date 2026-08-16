<#-- @formatter:off -->
package ${package}.mixin;

import ${package}.event.BlockEvents;
import net.minecraft.world.item.BlockItem;
import net.minecraft.world.item.context.BlockPlaceContext;
import net.minecraft.world.InteractionResult;
import net.minecraft.core.BlockPos;
import net.minecraft.world.entity.Entity;
import net.minecraft.world.level.block.Block;
import net.minecraft.world.level.block.state.BlockState;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Unique;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

@Mixin(BlockItem.class)
public abstract class BlockItemMixin {

	@Unique
	private BlockState th$originalState = null;

	/**
	 * @reason Capture original block state before placement
	 * @author MCreator Quilt Generator
	 */
	@Inject(method = "place", at = @At("HEAD"))
	public void placeHead(BlockPlaceContext context, CallbackInfoReturnable<InteractionResult> cir) {
		if (context.getLevel() != null) {
			th$originalState = context.getLevel().getBlockState(context.getClickedPos());
		} else {
			th$originalState = null;
		}
	}

	/**
	 * @reason Fire BlockEvents.BLOCK_PLACE and BLOCK_MULTIPLACE events after a block is successfully placed.
	 *         BLOCK_PLACE fires on every successful placement.
	 *         BLOCK_MULTIPLACE fires only when stacking onto the same block type (e.g. candles, snow).
	 * @author MCreator Quilt Generator
	 */
	@Inject(method = "place", at = @At("RETURN"))
	public void placeReturn(BlockPlaceContext context, CallbackInfoReturnable<InteractionResult> cir) {
		if (th$originalState == null) return;
		InteractionResult result = cir.getReturnValue();
		if (result != InteractionResult.SUCCESS && result != InteractionResult.CONSUME) return;
		if (context.getPlayer() != null && context.getLevel() != null) {
			BlockPos pos = context.getClickedPos();
			Entity entity = context.getPlayer();
			Block placedBlock = ((BlockItem) (Object) this).getBlock();
			BlockState placed = placedBlock.defaultBlockState();

			// BLOCK_PLACE: fires on every successful block placement
			BlockEvents.BLOCK_PLACE.invoker().onBlockPlaced(pos, entity, placed, th$originalState);

			// BLOCK_MULTIPLACE: fires only when stacking on top of the same block type
			if (th$originalState.getBlock() == placedBlock) {
				BlockEvents.BLOCK_MULTIPLACE.invoker().onMultiplaced(pos, entity, placed, th$originalState);
			}
		}
		th$originalState = null;
	}
}
<#-- @formatter:on -->
