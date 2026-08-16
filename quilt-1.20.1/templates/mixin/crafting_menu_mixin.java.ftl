<#-- @formatter:off -->
package ${package}.mixin;

import ${package}.event.ItemEvents;
import net.minecraft.world.entity.player.Player;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.inventory.ResultSlot;
import net.minecraft.world.level.Level;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

@Mixin(ResultSlot.class)
public class CraftingMenuMixin {

	@Inject(method = "onTake", at = @At("HEAD"))
	private void onResultTaken(Player player, ItemStack stack, CallbackInfo ci) {
		if (player.level().isClientSide()) return;

		ItemEvents.ITEM_CRAFTED.invoker().onItemCrafted(player, stack.copy());
	}
}
<#-- @formatter:on -->