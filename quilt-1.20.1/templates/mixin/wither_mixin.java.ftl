<#-- @formatter:off -->
package ${package}.mixin;

import ${package}.event.LivingEntityEvents;
import net.minecraft.world.entity.boss.wither.WitherBoss;
import net.minecraft.world.entity.LivingEntity;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

@Mixin(WitherBoss.class)
public class WitherMixin {

	/**
	 * @reason Fire LivingEntityEvents.ENTITY_GRIEF event when a wither fires a skull
	 * @author MCreator Quilt Generator
	 */
	@Inject(method = "performRangedAttack", at = @At("HEAD"))
	private void onWitherSkull(int phase, LivingEntity target, CallbackInfo ci) {
		WitherBoss self = (WitherBoss) (Object) this;
		LivingEntityEvents.ENTITY_GRIEF.invoker().onEntityGrief(self);
	}
}
<#-- @formatter:on -->