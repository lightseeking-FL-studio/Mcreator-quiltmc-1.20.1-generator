<#-- @formatter:off -->
package ${package}.mixin;

import ${package}.event.PlayerEvents;
import net.minecraft.server.level.ServerPlayer;
import net.minecraft.resources.ResourceLocation;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Shadow;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

import java.util.Set;
import java.util.HashSet;
import java.util.Map;
import java.util.HashMap;
import java.util.UUID;

@Mixin(net.minecraft.server.PlayerAdvancements.class)
public class PlayerAdvancementsMixin {

	@Shadow
	private ServerPlayer player;

	@Unique
	private static final Map<UUID, Set<ResourceLocation>> th$completedAdvancements = new HashMap<>();

	/**
	 * @reason Fire PlayerEvents.PLAYER_COMPLETES_ADVANCEMENT when a player completes an advancement.
	 * Injects into the award method to detect when a player is granted an advancement.
	 * @author MCreator Quilt Generator
	 */
	@Inject(method = "award", at = @At("TAIL"))
	private void onAdvancementAwarded(net.minecraft.advancements.Advancement advancement, String criterion, CallbackInfoReturnable<Boolean> cir) {
		if (!cir.getReturnValue()) {
			return;
		}
		UUID uuid = player.getUUID();
		if (uuid == null) {
			return;
		}
		Set<ResourceLocation> set = th$completedAdvancements.computeIfAbsent(uuid, k -> new HashSet<>());
		if (set.add(advancement.getId())) {
			PlayerEvents.PLAYER_COMPLETES_ADVANCEMENT.invoker().onPlayerCompletesAdvancement(player, advancement);
		}
	}
}
<#-- @formatter:on -->
