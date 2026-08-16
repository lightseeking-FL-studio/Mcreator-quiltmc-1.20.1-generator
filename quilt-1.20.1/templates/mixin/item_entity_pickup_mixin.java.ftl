<#-- @formatter:off -->
package ${package}.mixin;

import ${package}.event.LivingEntityEvents;
import net.minecraft.world.entity.LivingEntity;
import net.minecraft.world.entity.item.ItemEntity;
import net.minecraft.world.entity.player.Player;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.phys.AABB;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Unique;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.UUID;
import java.util.WeakHashMap;

@Mixin(ItemEntity.class)
public class ItemEntityPickupMixin {

	@Unique
	private static final Set<UUID> th$recentPickups = Collections.newSetFromMap(new WeakHashMap<>());

	@Inject(method = "playerTouch", at = @At("HEAD"))
	private void onPlayerTouch(Player player, CallbackInfo ci) {
		ItemEntity self = (ItemEntity) (Object) this;
		if (self.level().isClientSide()) return;
		if (self.tickCount < 20) return;

		UUID key = UUID.nameUUIDFromBytes((player.getUUID() + "|" + self.getUUID()).getBytes(java.nio.charset.StandardCharsets.UTF_8));
		synchronized (th$recentPickups) {
			if (!th$recentPickups.add(key)) {
				return;
			}
		}
		LivingEntityEvents.ENTITY_PICKUP_ITEM.invoker().onEntityPickupItem(player, self.getItem().copy());
	}

	@Inject(method = "tick", at = @At("HEAD"))
	private void onTick(CallbackInfo ci) {
		ItemEntity self = (ItemEntity) (Object) this;
		if (self.level().isClientSide()) return;

		if (self.tickCount >= 5999) {
			ItemEvents.ITEM_DESPAWN.invoker().onItemDespawn(self, self.getItem());
		}

		AABB box = self.getBoundingBox().inflate(0.25);
		List<LivingEntity> entities = self.level().getEntitiesOfClass(LivingEntity.class, box);
		for (LivingEntity entity : entities) {
			UUID key = UUID.nameUUIDFromBytes((entity.getUUID() + "|" + self.getUUID()).getBytes(java.nio.charset.StandardCharsets.UTF_8));
			synchronized (th$recentPickups) {
				if (!th$recentPickups.add(key)) {
					continue;
				}
			}
			LivingEntityEvents.ENTITY_PICKUP_ITEM.invoker().onEntityPickupItem(entity, self.getItem().copy());
		}
	}
}
<#-- @formatter:on -->
