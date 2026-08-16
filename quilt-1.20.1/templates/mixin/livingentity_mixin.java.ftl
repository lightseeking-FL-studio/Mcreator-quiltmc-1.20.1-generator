<#-- @formatter:off -->
<#include "../procedures.java.ftl">

<#assign itemsWithEntitySwing = []>
<#list w.getGElementsOfType("item") as item>
	<#if hasProcedure(item.onEntitySwing)>
	<#assign itemsWithEntitySwing += [item]>
	</#if>
</#list>
<#list w.getGElementsOfType("tool") as tool>
	<#if hasProcedure(tool.onEntitySwing)>
	<#assign itemsWithEntitySwing += [tool]>
	</#if>
</#list>

package ${package}.mixin;

import ${package}.event.ItemEvents;
import ${package}.event.LivingEntityEvents;
import ${package}.event.PlayerEvents;
import net.minecraft.world.entity.LivingEntity;
import net.minecraft.world.damagesource.DamageSource;
import net.minecraft.world.entity.item.ItemEntity;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.entity.player.Player;
import net.minecraft.world.effect.MobEffectInstance;
import net.minecraft.world.InteractionHand;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Unique;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

import java.util.List;
import java.util.ArrayList;
import java.util.WeakHashMap;

@Mixin(LivingEntity.class)
public abstract class LivingEntityMixin {

	@Unique
	private boolean th$wasOnGround = false;

	@Unique
	private static final WeakHashMap<LivingEntity, ItemStack> th$previousUseItems = new WeakHashMap<>();

	<#if itemsWithEntitySwing?has_content>
	@Inject(method = "swing(Lnet/minecraft/world/InteractionHand;Z)V", at = @At("HEAD"))
	public void swing(InteractionHand hand, boolean updateSelf, CallbackInfo ci) {
		ItemStack stack = ((LivingEntity) (Object) this).getItemInHand(hand);
		if (!stack.isEmpty()) {
		<#list itemsWithEntitySwing as item>
			if (stack.getItem() instanceof ${item.getModElement().getName()}Item)
				((${item.getModElement().getName()}Item)stack.getItem()).onEntitySwing(stack, (LivingEntity) (Object) this, hand);
		</#list>
		}
	}
	</#if>

	@Inject(method = "tick", at = @At("HEAD"))
	private void onEntityTickHead(CallbackInfo ci) {
		LivingEntity self = (LivingEntity) (Object) this;
		th$wasOnGround = self.onGround();
	}

	@Inject(method = "tick", at = @At("TAIL"))
	private void onEntityTick(CallbackInfo ci) {
		LivingEntity self = (LivingEntity) (Object) this;
		LivingEntityEvents.ENTITY_TICK.invoker().onEntityTick(self);

		if (!th$wasOnGround && self.onGround()) {
			LivingEntityEvents.ENTITY_FALL.invoker().onEntityFall(self, 1.0F, 1.0F);
		}

		if (th$wasOnGround && !self.onGround()) {
			LivingEntityEvents.ENTITY_JUMP.invoker().onEntityJump(self);
		}
	}

	@Inject(method = "releaseUsingItem", at = @At("HEAD"))
	private void onFinishUsingItemHead(CallbackInfo ci) {
		LivingEntity self = (LivingEntity) (Object) this;
		ItemStack used = self.getUseItem();
		if (!used.isEmpty() && self instanceof Player) {
			th$previousUseItems.put(self, used.copy());
		}
	}

	@Inject(method = "releaseUsingItem", at = @At("RETURN"))
	private void onFinishUsingItemReturn(CallbackInfo ci) {
		LivingEntity self = (LivingEntity) (Object) this;
		if (!(self instanceof Player player)) return;
		ItemStack previous = th$previousUseItems.remove(self);
		if (previous == null) return;

		ItemStack current = self.getUseItem();
		if (current.isEmpty() && (previous.isDamageableItem() || previous.getItem().isEdible())) {
			ItemEvents.ITEM_DESTROYED.invoker().onItemDestroyed(player, previous.copy());
		}

		int duration = previous.getUseDuration();
		LivingEntityEvents.ENTITY_STOP_USING_ITEM.invoker().onEntityStopUsingItem(player, previous.copy(), duration);
	}

	@Inject(method = "completeUsingItem", at = @At("HEAD"))
	private void onCompleteUsingItem(CallbackInfo ci) {
		LivingEntity self = (LivingEntity) (Object) this;
		if (self.level().isClientSide())
			return;
		ItemStack used = self.getUseItem();
		LivingEntityEvents.ENTITY_FINISH_USING_ITEM.invoker().onEntityFinishUsingItem(self, used.copy());
	}

	@Inject(method = "hurt", at = @At("HEAD"))
	private void onShieldBlock(DamageSource source, float amount, CallbackInfoReturnable<Boolean> cir) {
		LivingEntity self = (LivingEntity) (Object) this;
		if (self.getUseItem().getItem() instanceof net.minecraft.world.item.ShieldItem) {
			LivingEntityEvents.ENTITY_BLOCK.invoker().onEntityBlocked(self, source, amount);
		}
	}

	@Inject(method = "hurt", at = @At("HEAD"))
	private void onEntityHurt(DamageSource source, float amount, CallbackInfoReturnable<Boolean> cir) {
		LivingEntity self = (LivingEntity) (Object) this;
		if (self.level().isClientSide()) return;
		LivingEntityEvents.ENTITY_HURT.invoker().onEntityHurt(self, source, amount);
	}

	@Inject(method = "heal", at = @At("HEAD"))
	private void onEntityHeal(float amount, CallbackInfo ci) {
		LivingEntity self = (LivingEntity) (Object) this;
		LivingEntityEvents.ENTITY_HEAL.invoker().onEntityHeal(self, amount);
	}

	@Inject(method = "dropExperience", at = @At("HEAD"))
	private void onEntityDropXp(CallbackInfo ci) {
		LivingEntity self = (LivingEntity) (Object) this;
		LivingEntityEvents.ENTITY_DROP_XP.invoker().onEntityDropXp(self, null, self.getExperienceReward());
	}

	@Inject(method = "removeAllEffects", at = @At("HEAD"), cancellable = true)
	private void onRemoveAllEffects(CallbackInfoReturnable<Boolean> cir) {
		LivingEntity self = (LivingEntity) (Object) this;
		List<MobEffectInstance> effects = new ArrayList<>(self.getActiveEffects());
		for (MobEffectInstance effect : effects) {
			self.removeEffect(effect.getEffect());
		}
		cir.cancel();
	}
}
<#-- @formatter:on -->