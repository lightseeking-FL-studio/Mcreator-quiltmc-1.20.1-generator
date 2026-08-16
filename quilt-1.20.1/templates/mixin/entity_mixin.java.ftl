<#-- @formatter:off -->
package ${package}.mixin;

import ${package}.event.LivingEntityEvents;
import net.minecraft.world.entity.Entity;
import net.minecraft.world.entity.LivingEntity;
import net.minecraft.world.level.Level;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Unique;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

@Mixin(Entity.class)
public class EntityMixin {

	@Unique
	private Level th$lastLevel = null;

	/**
	 * @reason Fire LivingEntityEvents.ENTITY_TRAVELS_TO_DIMENSION when an entity changes dimensions.
	 * This covers entities that are already loaded and ticking, as a fallback to ServerLevelMixin.
	 * Uses the shared ENTITY_DIMENSIONS map to track entity dimensions across mixins.
	 * Skips the initial tick to avoid false triggers on entity spawn.
	 * @author MCreator Quilt Generator
	 */
	@Inject(method = "tick", at = @At("TAIL"))
	private void onEntityTick(CallbackInfo ci) {
		Entity self = (Entity) (Object) this;
		if (self.level().isClientSide()) return;

		if (th$lastLevel == null) {
			th$lastLevel = self.level();
			if (self instanceof LivingEntity) {
				LivingEntityEvents.ENTITY_DIMENSIONS.put(self.getUUID(), self.level().dimension());
			}
			return;
		}

		if (self.level() != th$lastLevel) {
			Level oldLevel = th$lastLevel;
			th$lastLevel = self.level();
			if (self instanceof LivingEntity) {
				LivingEntityEvents.ENTITY_DIMENSIONS.put(self.getUUID(), self.level().dimension());
				LivingEntityEvents.ENTITY_TRAVELS_TO_DIMENSION.invoker().onEntityTravelsToDimension(
					(LivingEntity) self, oldLevel, self.level());
			}
		}
	}
}
<#-- @formatter:on -->
