<#-- @formatter:off -->
package ${package}.mixin;

import ${package}.event.LivingEntityEvents;
import net.minecraft.resources.ResourceKey;
import net.minecraft.world.entity.Entity;
import net.minecraft.world.entity.LivingEntity;
import net.minecraft.server.level.ServerPlayer;
import net.minecraft.world.level.Level;
import net.minecraft.server.level.ServerLevel;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Unique;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

import java.util.UUID;

@Mixin(ServerLevel.class)
public class ServerLevelMixin {

	/**
	 * @reason Fire LivingEntityEvents.ENTITY_TRAVELS_TO_DIMENSION when any entity is teleported
	 * to this server level, regardless of whether the entity is currently ticked/loaded.
	 * This catches dimension changes for entities that are teleported via commands, portals,
	 * or other means that don't rely on the entity's tick() method.
	 * Uses the shared ENTITY_DIMENSIONS map to track entity dimensions across mixins.
	 * @author MCreator Quilt Generator
	 */
	@Inject(method = "addDuringTeleport", at = @At("TAIL"))
	private void onEntityTeleported(Entity entity, CallbackInfo ci) {
		ServerLevel self = (ServerLevel) (Object) this;
		if (entity instanceof LivingEntity) {
			UUID uuid = entity.getUUID();
			ResourceKey<Level> currentDim = entity.level().dimension();

			if (LivingEntityEvents.ENTITY_DIMENSIONS.containsKey(uuid)) {
				ResourceKey<Level> lastDim = LivingEntityEvents.ENTITY_DIMENSIONS.get(uuid);
				if (!currentDim.equals(lastDim)) {
					Level originLevel = self.getServer().getLevel(lastDim);
					LivingEntityEvents.ENTITY_TRAVELS_TO_DIMENSION.invoker().onEntityTravelsToDimension(
						(LivingEntity) entity,
						originLevel != null ? originLevel : self,
						self);
				}
			}

			LivingEntityEvents.ENTITY_DIMENSIONS.put(uuid, currentDim);
		}
	}

	/**
	 * @reason Fire LivingEntityEvents.ENTITY_TRAVELS_TO_DIMENSION when a player changes dimensions
	 * via portal or other means. This ensures players are always tracked for dimension changes.
	 * Uses the shared ENTITY_DIMENSIONS map to track entity dimensions across mixins.
	 * @author MCreator Quilt Generator
	 */
	@Inject(method = "addDuringPortalTeleport", at = @At("TAIL"))
	private void onPlayerPortalTeleport(ServerPlayer player, CallbackInfo ci) {
		ServerLevel self = (ServerLevel) (Object) this;
		UUID uuid = player.getUUID();
		ResourceKey<Level> currentDim = player.level().dimension();

		if (LivingEntityEvents.ENTITY_DIMENSIONS.containsKey(uuid)) {
			ResourceKey<Level> lastDim = LivingEntityEvents.ENTITY_DIMENSIONS.get(uuid);
			if (!currentDim.equals(lastDim)) {
				Level originLevel = self.getServer().getLevel(lastDim);
				LivingEntityEvents.ENTITY_TRAVELS_TO_DIMENSION.invoker().onEntityTravelsToDimension(
					player,
					originLevel != null ? originLevel : self,
					self);
			}
		}

		LivingEntityEvents.ENTITY_DIMENSIONS.put(uuid, currentDim);
	}
}
<#-- @formatter:on -->
