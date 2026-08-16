<#-- @formatter:off -->
package ${package}.mixin;

import ${package}.event.LivingEntityEvents;
import net.minecraft.world.entity.monster.Ravager;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Unique;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

@Mixin(Ravager.class)
public class RavagerMixin {

	@Unique
	private long th$lastGriefTime = 0;

	/**
	 * @reason Fire LivingEntityEvents.ENTITY_GRIEF when a ravager roars.
	 * @author MCreator Quilt Generator
	 */
	@Inject(method = "roar", at = @At("HEAD"))
	private void onRavagerRoar(CallbackInfo ci) {
		Ravager self = (Ravager) (Object) this;
		LivingEntityEvents.ENTITY_GRIEF.invoker().onEntityGrief(self);
	}
}
<#-- @formatter:on -->