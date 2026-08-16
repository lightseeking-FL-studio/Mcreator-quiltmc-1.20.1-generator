<#-- @formatter:off -->
package ${package}.mixin;

import ${package}.event.PlayerEvents;
import net.minecraft.world.entity.player.Player;
import net.minecraft.world.entity.projectile.FishingHook;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

@Mixin(FishingHook.class)
public class FishingHookMixin {

	/**
	 * @reason Fire PlayerEvents.PLAYER_FISHES_ITEM when a player catches an item while fishing.
	 * Injects into the retrieve method to detect when a player successfully reels in a fishing line.
	 * @author MCreator Quilt Generator
	 */
	@Inject(method = "retrieve", at = @At("TAIL"))
	private void onRetrieve(net.minecraft.world.item.ItemStack itemStack, CallbackInfoReturnable<Integer> cir) {
		if (cir.getReturnValue() > 0) {
			Player player = ((FishingHook) (Object) this).getPlayerOwner();
			if (player != null) {
				PlayerEvents.PLAYER_FISHES_ITEM.invoker().onPlayerFishesItem(player);
			}
		}
	}
}
<#-- @formatter:on -->
