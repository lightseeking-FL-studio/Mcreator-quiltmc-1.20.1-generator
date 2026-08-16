<#-- @formatter:off -->
package ${package}.mixin;

import ${package}.event.ItemEvents;
import net.minecraft.world.item.BoneMealItem;
import net.minecraft.world.item.context.UseOnContext;
import net.minecraft.world.InteractionResult;
import net.minecraft.core.BlockPos;
import net.minecraft.world.entity.Entity;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.level.block.state.BlockState;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

@Mixin(BoneMealItem.class)
public class BoneMealItemMixin {

	/**
	 * @reason Fire ItemEvents.BONEMEAL_USED event when bone meal is successfully used
	 * @author MCreator Quilt Generator
	 */
	@Inject(method = "useOn", at = @At("RETURN"))
	public void useOn(UseOnContext context, CallbackInfoReturnable<InteractionResult> cir) {
		if (cir.getReturnValue() == InteractionResult.CONSUME || cir.getReturnValue() == InteractionResult.SUCCESS) {
			if (context.getPlayer() != null && context.getLevel() != null) {
				BlockPos pos = context.getClickedPos();
				Entity entity = context.getPlayer();
				ItemStack itemstack = context.getItemInHand();
				BlockState blockstate = context.getLevel().getBlockState(pos);
				ItemEvents.BONEMEAL_USED.invoker().onBonemealUsed(pos, entity, itemstack, blockstate);
			}
		}
	}
}
<#-- @formatter:on -->
