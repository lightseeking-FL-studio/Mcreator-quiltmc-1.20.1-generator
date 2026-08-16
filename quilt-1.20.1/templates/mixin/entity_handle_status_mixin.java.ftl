<#-- @formatter:off -->
package ${package}.mixin;

import ${package}.event.ItemEvents;
import net.minecraft.world.entity.Entity;
import net.minecraft.world.entity.item.ItemEntity;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.level.Level;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

@Mixin(Entity.class)
public class EntityHandleStatusMixin {

	@Inject(method = "remove", at = @At("HEAD"))
	private void onRemove(Entity.RemovalReason reason, CallbackInfo ci) {
		Entity self = (Entity) (Object) this;
		Level level = self.level();
		if (level == null || level.isClientSide()) return;
		if (self instanceof ItemEntity itemEntity) {
			ItemStack snapshot = itemEntity.getItem().copy();
			ItemEvents.ITEM_DESPAWN.invoker().onItemDespawn(itemEntity, snapshot);
		}
	}
}
<#-- @formatter:on -->
