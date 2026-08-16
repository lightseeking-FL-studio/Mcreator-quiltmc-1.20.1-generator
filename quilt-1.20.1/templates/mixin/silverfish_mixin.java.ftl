<#-- @formatter:off -->
package ${package}.mixin;

import ${package}.event.LivingEntityEvents;
import net.minecraft.world.entity.LivingEntity;
import net.minecraft.world.entity.monster.Silverfish;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Unique;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

@Mixin(Silverfish.class)
public class SilverfishMixin {

	@Unique
	private boolean th$hadTarget = false;

	/**
	 * @reason Fire LivingEntityEvents.ENTITY_GRIEF when a silverfish becomes active.
	 * Silverfish "break" blocks when they enter/exit infested blocks.
	 * Detects when the silverfish starts targeting something (becomes active).
	 * @author MCreator Quilt Generator
	 */
	@Inject(method = "tick", at = @At("TAIL"))
	private void onSilverfishTick(CallbackInfo ci) {
		Silverfish self = (Silverfish) (Object) this;
		if (!self.isAlive()) {
			th$hadTarget = false;
			return;
		}
		LivingEntity target = self.getTarget();
		boolean hasTarget = target != null;
		// Fire when silverfish becomes active (gets a target)
		if (hasTarget && !th$hadTarget) {
			LivingEntityEvents.ENTITY_GRIEF.invoker().onEntityGrief(self);
		}
		th$hadTarget = hasTarget;
	}

	/**
	 * @reason Fire LivingEntityEvents.ENTITY_GRIEF when a silverfish hides in a block.
	 * Silverfish break infested blocks when they take damage and hide.
	 * This catches the actual block-breaking behavior that occurs on hurt.
	 * @author MCreator Quilt Generator
	 */
	@Inject(method = "hurt", at = @At("TAIL"))
	private void onSilverfishHurt(net.minecraft.world.damagesource.DamageSource source, float amount, CallbackInfoReturnable<Boolean> cir) {
		Silverfish self = (Silverfish) (Object) this;
		if (self.isAlive() && !self.level().isClientSide()) {
			LivingEntityEvents.ENTITY_GRIEF.invoker().onEntityGrief(self);
		}
	}
}
<#-- @formatter:on -->