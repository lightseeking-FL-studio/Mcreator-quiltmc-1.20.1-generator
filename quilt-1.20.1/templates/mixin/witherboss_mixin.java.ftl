<#-- @formatter:off -->
package ${package}.mixin;

import ${package}.event.LivingEntityEvents;
import net.minecraft.world.entity.LivingEntity;
import net.minecraft.world.entity.boss.wither.WitherBoss;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Unique;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

@Mixin(WitherBoss.class)
public class WitherBossMixin {

	@Unique
	private boolean th$wasAlive = true;

	/**
	 * @reason Fire LivingEntityEvents.ENTITY_GRIEF when a wither shoots a wither skull.
	 * Block destruction from wither skulls is already covered by LevelMixin BLOCK_BREAK.
	 * @author MCreator Quilt Generator
	 */
	@Inject(method = "performRangedAttack(IDDDZ)V", at = @At("HEAD"))
	private void onWitherShootSkull(int head, double x, double y, double z, boolean isDangerous, CallbackInfo ci) {
		WitherBoss self = (WitherBoss) (Object) this;
		LivingEntityEvents.ENTITY_GRIEF.invoker().onEntityGrief(self);
	}

	/**
	 * @reason Fire LivingEntityEvents.ENTITY_GRIEF when a wither dies and explodes.
	 * Detects the transition from alive to dead, which triggers the death explosion.
	 * @author MCreator Quilt Generator
	 */
	@Inject(method = "customServerAiStep", at = @At("TAIL"))
	private void onWitherCustomServerAiStep(CallbackInfo ci) {
		WitherBoss self = (WitherBoss) (Object) this;
		boolean isAlive = self.isAlive();
		if (th$wasAlive && !isAlive) {
			LivingEntityEvents.ENTITY_GRIEF.invoker().onEntityGrief(self);
		}
		th$wasAlive = isAlive;
	}
}
<#-- @formatter:on -->