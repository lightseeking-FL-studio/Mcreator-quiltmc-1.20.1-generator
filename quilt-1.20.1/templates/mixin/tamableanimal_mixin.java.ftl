<#-- @formatter:off -->
package ${package}.mixin;

import ${package}.event.LivingEntityEvents;
import net.minecraft.world.entity.TamableAnimal;
import net.minecraft.world.entity.player.Player;
import net.minecraft.world.entity.LivingEntity;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

@Mixin(TamableAnimal.class)
public class TamableAnimalMixin {

	/**
	 * @reason Fire LivingEntityEvents.ENTITY_TAMED event when a tamable animal is tamed
	 * @author MCreator Quilt Generator
	 */
	@Inject(method = "tame", at = @At("HEAD"))
	private void onTamed(Player player, CallbackInfo ci) {
		TamableAnimal self = (TamableAnimal) (Object) this;
		LivingEntityEvents.ENTITY_TAMED.invoker().onEntityTamed(self, player);
	}
}
<#-- @formatter:on -->