<#-- @formatter:off -->
package ${package}.mixin;

import ${package}.event.LivingEntityEvents;
import net.minecraft.world.entity.raid.Raider;
import net.minecraft.world.entity.LivingEntity;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Unique;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

@Mixin(Raider.class)
public class RaiderMixin {

	@Unique
	private boolean th$griefTriggered = false;

	/**
	 * @reason Detect when a raider is active and fire LivingEntityEvents.ENTITY_GRIEF.
	 * @author MCreator Quilt Generator
	 */
	@Inject(method = "tick", at = @At("HEAD"))
	private void onRaiderTick(CallbackInfo ci) {
		Raider self = (Raider) (Object) this;
		if (!th$griefTriggered) {
			th$griefTriggered = true;
			LivingEntityEvents.ENTITY_GRIEF.invoker().onEntityGrief(self);
		}
	}
}
<#-- @formatter:on -->