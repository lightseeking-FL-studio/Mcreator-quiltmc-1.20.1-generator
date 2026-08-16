<#-- @formatter:off -->
package ${package}.mixin;

import ${package}.event.PlayerEvents;
import net.minecraft.world.entity.Entity;
import net.minecraft.world.entity.item.ItemEntity;
import net.minecraft.world.entity.player.Player;
import net.minecraft.world.item.ItemStack;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Unique;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

import java.util.Collections;
import java.util.Set;
import java.util.UUID;
import java.util.WeakHashMap;

@Mixin(ItemEntity.class)
public class ItemEntityDropMixin {

	@Unique
	private static final Set<UUID> th$reportedDrops = Collections.newSetFromMap(new WeakHashMap<>());

	@Inject(method = "tick", at = @At("HEAD"))
	private void onTick(CallbackInfo ci) {
		ItemEntity self = (ItemEntity) (Object) this;
		if (self.level().isClientSide()) return;

		Entity owner = self.getOwner();
		if (owner instanceof Player player) {
			UUID key = UUID.nameUUIDFromBytes((player.getUUID() + "|" + self.getUUID()).getBytes(java.nio.charset.StandardCharsets.UTF_8));
			synchronized (th$reportedDrops) {
				if (!th$reportedDrops.add(key)) {
					return;
				}
			}
			PlayerEvents.PLAYER_DROP_ITEM.invoker().onPlayerDropItem(player, self.getItem().copy());
		}
	}
}
<#-- @formatter:on -->
