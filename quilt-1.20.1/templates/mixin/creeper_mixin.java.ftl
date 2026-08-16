<#-- @formatter:off -->
package ${package}.mixin;

import ${package}.event.LivingEntityEvents;
import net.minecraft.world.entity.monster.Creeper;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Shadow;
import org.spongepowered.asm.mixin.Unique;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

@Mixin(Creeper.class)
public class CreeperMixin {

	@Shadow
	private int swell;

	@Unique
	private int th$lastSwell = 0;

	/**
	 * @reason Fire LivingEntityEvents.ENTITY_GRIEF when a creeper becomes ignited.
	 * Detects the rising edge of the 'swell' field: only fires when it transitions from
	 * 0 to >0. This covers both flint &amp; steel and AI targeting.
	 * Forge equivalent: EntityMobGriefingEvent in Creeper explosion.
	 * @author MCreator Quilt Generator
	 */
	@Inject(method = "tick", at = @At("TAIL"))
	private void onCreeperTick(CallbackInfo ci) {
		Creeper self = (Creeper) (Object) this;
		if (swell > 0 && th$lastSwell == 0) {
			LivingEntityEvents.ENTITY_GRIEF.invoker().onEntityGrief(self);
		}
		th$lastSwell = swell;
	}
}
<#-- @formatter:on -->