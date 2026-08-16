<#-- @formatter:off -->
package ${package}.mixin;

import ${package}.event.LivingEntityEvents;
import net.minecraft.world.entity.LivingEntity;
import net.minecraft.world.entity.Mob;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Unique;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

@Mixin(Mob.class)
public class MobMixin {

	@Unique
	private LivingEntity th$lastTarget = null;

	@Inject(method = "setTarget", at = @At("HEAD"))
	private void onSetTarget(LivingEntity target, CallbackInfo ci) {
		Mob self = (Mob) (Object) this;
		if (self.level().isClientSide()) return;
		if (target == th$lastTarget) return;

		th$lastTarget = target;
		LivingEntityEvents.ENTITY_SET_ATTACK_TARGET.invoker().onSetAttackTarget(self, target);
	}
}
<#-- @formatter:on -->
