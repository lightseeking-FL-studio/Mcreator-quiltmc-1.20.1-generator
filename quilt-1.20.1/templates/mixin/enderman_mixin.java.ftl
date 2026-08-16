<#-- @formatter:off -->
package ${package}.mixin;

import ${package}.event.LivingEntityEvents;
import ${package}.event.BlockEvents;
import net.minecraft.world.entity.monster.EnderMan;
import net.minecraft.world.level.block.state.BlockState;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

@Mixin(EnderMan.class)
public class EnderManMixin {

	/**
	 * @reason Fire LivingEntityEvents.ENTITY_GRIEF when an enderman picks up a block,
	 * and BlockEvents.BLOCK_PLACE when it places one down.
	 * In 1.20.1 Mojang mappings, the methods are setCarriedBlock/getCarriedBlock.
	 * @author MCreator Quilt Generator
	 */
	@Inject(method = "setCarriedBlock", at = @At("HEAD"))
	private void onSetCarriedBlock(BlockState state, CallbackInfo ci) {
		EnderMan self = (EnderMan) (Object) this;
		BlockState oldState = self.getCarriedBlock();
		boolean hadBlock = oldState != null && !oldState.isAir();
		boolean willHaveBlock = state != null && !state.isAir();

		if (!hadBlock && willHaveBlock) {
			// Enderman is picking up a block → grief event
			LivingEntityEvents.ENTITY_GRIEF.invoker().onEntityGrief(self);
		} else if (hadBlock && !willHaveBlock) {
			// Enderman is placing a block → block place event
			// The position is approximate: enderman places at its own block position
			BlockEvents.BLOCK_PLACE.invoker().onBlockPlaced(
				self.blockPosition(), self, oldState,
				self.level().getBlockState(self.blockPosition().below())
			);
		}
	}
}
<#-- @formatter:on -->