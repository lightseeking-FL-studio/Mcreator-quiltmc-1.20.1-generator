<#-- @formatter:off -->
package ${package}.mixin;

import ${package}.event.BlockEvents;
import net.minecraft.world.entity.Entity;
import net.minecraft.world.level.Explosion;
import net.minecraft.world.level.Level;
import net.minecraft.world.phys.Vec3;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

@Mixin(Level.class)
public class LevelExplosionMixin {

	@Inject(method = "explode(Lnet/minecraft/world/entity/Entity;DDDFLnet/minecraft/world/level/Level$ExplosionInteraction;)Lnet/minecraft/world/level/Explosion;", at = @At("HEAD"))
	private void onExplode(Entity entity, double x, double y, double z, float power, Level.ExplosionInteraction interaction, CallbackInfoReturnable<Explosion> cir) {
		Level self = (Level) (Object) this;
		if (self.isClientSide()) return;
		BlockEvents.EXPLOSION_OCCURS.invoker().onExplosionOccurs(self, entity, new Vec3(x, y, z), power);
	}
}
<#-- @formatter:on -->
