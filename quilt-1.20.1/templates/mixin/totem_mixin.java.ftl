<#-- @formatter:off -->
package ${package}.mixin;

import ${package}.event.LivingEntityEvents;
import net.minecraft.world.InteractionHand;
import net.minecraft.world.entity.LivingEntity;
import net.minecraft.world.damagesource.DamageSource;
import net.minecraft.world.item.Items;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Unique;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

@Mixin(LivingEntity.class)
public class TotemMixin {

	@Unique
	private float th$lastHealth = -1.0F;
	@Unique
	private int th$mainCountBefore = 0;
	@Unique
	private int th$offCountBefore = 0;

	/**
	 * @reason Detect when a living entity actually consumes a totem of undying.
	 * This records the health and totem counts before damage is applied,
	 * then checks after if a totem was consumed and health was restored to 1.0,
	 * which indicates real totem usage.
	 * @author MCreator Quilt Generator
	 */
	@Inject(method = "hurt", at = @At("HEAD"))
	private void onHurtHead(DamageSource source, float amount, CallbackInfoReturnable<Boolean> cir) {
		LivingEntity self = (LivingEntity) (Object) this;
		if (self.level().isClientSide()) return;

		th$lastHealth = self.getHealth();
		th$mainCountBefore = self.getMainHandItem().is(Items.TOTEM_OF_UNDYING) ? self.getMainHandItem().getCount() : 0;
		th$offCountBefore = self.getOffhandItem().is(Items.TOTEM_OF_UNDYING) ? self.getOffhandItem().getCount() : 0;
	}

	@Inject(method = "hurt", at = @At("TAIL"))
	private void onHurtTail(DamageSource source, float amount, CallbackInfoReturnable<Boolean> cir) {
		LivingEntity self = (LivingEntity) (Object) this;
		if (self.level().isClientSide()) return;
		if (!Boolean.TRUE.equals(cir.getReturnValue())) return;

		int mainCountAfter = self.getMainHandItem().is(Items.TOTEM_OF_UNDYING) ? self.getMainHandItem().getCount() : 0;
		int offCountAfter = self.getOffhandItem().is(Items.TOTEM_OF_UNDYING) ? self.getOffhandItem().getCount() : 0;
		boolean mainHandConsumed = th$mainCountBefore > 0 && mainCountAfter < th$mainCountBefore;
		boolean offHandConsumed = th$offCountBefore > 0 && offCountAfter < th$offCountBefore;

		if ((mainHandConsumed || offHandConsumed) && self.getHealth() == 1.0F) {
			InteractionHand hand = mainHandConsumed ? InteractionHand.MAIN_HAND : InteractionHand.OFF_HAND;
			LivingEntityEvents.ENTITY_USE_TOTEM.invoker().onEntityUseTotem(self, hand);
		}
	}
}
<#-- @formatter:on -->
