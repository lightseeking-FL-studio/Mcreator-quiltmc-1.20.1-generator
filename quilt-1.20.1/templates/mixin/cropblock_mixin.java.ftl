<#-- @formatter:off -->
package ${package}.mixin;

import ${package}.event.BlockEvents;
import net.minecraft.world.level.block.CropBlock;
import net.minecraft.world.level.block.state.BlockState;
import net.minecraft.core.BlockPos;
import net.minecraft.server.level.ServerLevel;
import net.minecraft.util.RandomSource;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

@Mixin(CropBlock.class)
public class CropBlockMixin {

	/**
	 * @reason Fire BlockEvents.CROP_ATTEMPTS_GROWTH event when a crop attempts to grow
	 * @author MCreator Quilt Generator
	 */
	@Inject(method = "randomTick", at = @At("HEAD"))
	private void onCropGrow(BlockState state, ServerLevel level, BlockPos pos, RandomSource random, CallbackInfo ci) {
		BlockEvents.CROP_ATTEMPTS_GROWTH.invoker().onCropGrow(pos, state, level);
	}
}
<#-- @formatter:on -->
