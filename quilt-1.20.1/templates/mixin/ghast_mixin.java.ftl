<#-- @formatter:off -->
package ${package}.mixin;

import ${package}.event.LivingEntityEvents;
import net.minecraft.world.entity.Entity;
import net.minecraft.world.entity.LivingEntity;
import net.minecraft.world.entity.monster.Ghast;
import net.minecraft.world.entity.projectile.Fireball;
import net.minecraft.world.entity.projectile.Projectile;
import net.minecraft.world.phys.HitResult;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

@Mixin(Projectile.class)
public class GhastMixin {

	/**
	 * @reason Fire LivingEntityEvents.ENTITY_GRIEF when a ghast fireball hits a block.
	 * The event is triggered at the exact moment the fireball collides with a block,
	 * which is when the explosion will be created and attempt to destroy surrounding blocks.
	 * Only triggers for ghast fireballs (owner is Ghast), not for other projectiles.
	 * @author MCreator Quilt Generator
	 */
	@Inject(method = "onHit(Lnet/minecraft/world/phys/HitResult;)V", at = @At("HEAD"))
	private void onFireballHit(HitResult hitResult, CallbackInfo ci) {
		Entity owner = ((Projectile) (Object) this).getOwner();
		if (hitResult.getType() == HitResult.Type.BLOCK && owner instanceof Ghast) {
			LivingEntityEvents.ENTITY_GRIEF.invoker().onEntityGrief((LivingEntity) owner);
		}
	}
}
<#-- @formatter:on -->