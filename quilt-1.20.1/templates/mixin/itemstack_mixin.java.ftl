<#-- @formatter:off -->
package ${package}.mixin;

import ${package}.event.ItemEvents;
import net.minecraft.world.entity.LivingEntity;
import net.minecraft.world.entity.player.Player;
import net.minecraft.world.item.ItemStack;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Unique;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

import java.util.WeakHashMap;

@Mixin(ItemStack.class)
public class ItemStackMixin {

	@Unique
	private static final WeakHashMap<ItemStack, ItemStack> th$previousStacks = new WeakHashMap<>();

	@Inject(method = "hurtAndBreak", at = @At("HEAD"))
	private void onHurtAndBreak(int amount, LivingEntity entity, java.util.function.Consumer<LivingEntity> onBroken, CallbackInfo ci) {
		ItemStack self = (ItemStack) (Object) this;
		if (self.isEmpty()) return;
		if (!self.isDamageableItem()) return;

		th$previousStacks.put(self, self.copy());
	}

	@Inject(method = "hurtAndBreak", at = @At("TAIL"))
	private void onHurtAndBreakReturn(int amount, LivingEntity entity, java.util.function.Consumer<LivingEntity> onBroken, CallbackInfo ci) {
		ItemStack self = (ItemStack) (Object) this;
		ItemStack previous = th$previousStacks.remove(self);
		if (previous == null) return;

		if (self.isEmpty() && !previous.isEmpty() && entity instanceof Player player) {
			ItemEvents.ITEM_DESTROYED.invoker().onItemDestroyed(player, previous.copy());
		}
	}
}
<#-- @formatter:on -->