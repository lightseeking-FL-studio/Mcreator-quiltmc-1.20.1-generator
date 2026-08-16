<#-- @formatter:off -->
package ${package}.mixin;

import ${package}.event.LivingEntityEvents;
import ${package}.event.PlayerEvents;
import net.minecraft.world.entity.player.Player;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.entity.Entity;

import java.util.Map;
import java.util.HashMap;
import java.util.UUID;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Unique;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

@Mixin(Player.class)
public class PlayerMixin {

	@Unique
	private static final Map<UUID, Integer> th$XP_MAP = new HashMap<>();
	@Unique
	private static final Map<UUID, Integer> th$LEVEL_MAP = new HashMap<>();

	@Unique
	private int th$lastExperience = 0;
	@Unique
	private int th$lastLevel = 0;
	@Unique
	private ItemStack th$lastMainHand = ItemStack.EMPTY;
	@Unique
	private ItemStack th$lastOffHand = ItemStack.EMPTY;
	@Unique
	private boolean th$wasSleeping = false;
	@Unique
	private boolean th$firstTick = true;

	/**
	 * @reason Fire PlayerEvents.PICKUP_XP and PlayerEvents.XP_CHANGE when a player picks up experience.
	 * Injects at the end of Player.tick() to detect experience changes, which happens
	 * when the player picks up experience orbs or gains/loses experience by other means.
	 * Uses a static Map to track XP across player instance recreation on death/respawn.
	 * @author MCreator Quilt Generator
	 */
	@Inject(method = "tick", at = @At("TAIL"))
	private void onPlayerTick(CallbackInfo ci) {
		Player self = (Player) (Object) this;
		int currentExperience = self.totalExperience;
		int currentLevel = self.experienceLevel;

		// Skip first tick after login/respawn to avoid false positive.
		// Because ServerPlayer is recreated on respawn, th$firstTick is true for the new instance.
		if (th$firstTick) {
			th$firstTick = false;
			th$lastExperience = currentExperience;
			th$lastLevel = currentLevel;

			// Check if this player had XP stored from a previous instance (death detection)
			Integer storedXp = th$XP_MAP.remove(self.getUUID());
			if (storedXp != null) {
				int deathDiff = currentExperience - storedXp;
				if (deathDiff < 0) {
					PlayerEvents.XP_CHANGE.invoker().onXpChange(self, deathDiff);
				}
			}
			// Check if level changed due to death
			Integer storedLevel = th$LEVEL_MAP.remove(self.getUUID());
			if (storedLevel != null && currentLevel != storedLevel) {
				PlayerEvents.LEVEL_CHANGE.invoker().onLevelChange(self, currentLevel - storedLevel);
			}
			return;
		}

		// While dead, don't update tracked XP so we can detect the change on respawn
		if (!self.isAlive()) {
			return;
		}

		int diff = currentExperience - th$lastExperience;
		if (diff > 0) {
			PlayerEvents.XP_CHANGE.invoker().onXpChange(self, diff);
			PlayerEvents.PICKUP_XP.invoker().onPickupXp(self);
		} else if (diff < 0) {
			PlayerEvents.XP_CHANGE.invoker().onXpChange(self, diff);
		}

		if (currentLevel != th$lastLevel) {
			PlayerEvents.LEVEL_CHANGE.invoker().onLevelChange(self, currentLevel - th$lastLevel);
		}

		ItemStack currentMainHand = self.getMainHandItem();
		ItemStack currentOffHand = self.getOffhandItem();
		if (!th$lastMainHand.isEmpty() || !th$lastOffHand.isEmpty()) {
			boolean mainWasOff = ItemStack.isSameItemSameTags(th$lastMainHand, currentOffHand);
			boolean offWasMain = ItemStack.isSameItemSameTags(th$lastOffHand, currentMainHand);
			boolean mainChanged = !ItemStack.isSameItemSameTags(th$lastMainHand, currentMainHand);
			boolean offChanged = !ItemStack.isSameItemSameTags(th$lastOffHand, currentOffHand);
			if (mainWasOff && offWasMain && (mainChanged || offChanged)) {
				LivingEntityEvents.ENTITY_SWITCH_HAND.invoker().onEntitySwitchHand(self, currentMainHand.copy(), currentOffHand.copy());
			}
		}

		th$lastExperience = currentExperience;
		th$lastLevel = currentLevel;
		th$lastMainHand = currentMainHand.copy();
		th$lastOffHand = currentOffHand.copy();

		// Store XP in static map so the next instance can detect death XP loss
		th$XP_MAP.put(self.getUUID(), currentExperience);
		// Store level in static map so the next instance can detect death level loss
		th$LEVEL_MAP.put(self.getUUID(), currentLevel);

		PlayerEvents.END_PLAYER_TICK.invoker().onEndPlayerTick(self);
	}

	/**
	 * @reason Fire PlayerEvents.PLAYER_CRITICAL_HIT when a player lands a critical hit on an entity.
	 * Injects at HEAD of the attack method to detect critical hit conditions before the attack proceeds.
	 * @author MCreator Quilt Generator
	 */
	@Inject(method = "attack", at = @At("HEAD"))
	private void onAttack(Entity target, CallbackInfo ci) {
		Player self = (Player) (Object) this;
		if (target == null || target == self) {
			PlayerEvents.PLAYER_LEFT_CLICKS_AIR.invoker().onPlayerLeftClicksAir(self);
			return;
		}
		if (self.fallDistance > 0.0F && !self.onGround() && !self.isShiftKeyDown() && !self.isInWater() && !self.hasEffect(net.minecraft.world.effect.MobEffects.BLINDNESS) && !self.isPassenger()) {
			PlayerEvents.PLAYER_CRITICAL_HIT.invoker().onPlayerCriticalHit(self, target, 1.5F);
		}
	}

	@Inject(method = "interactOn", at = @At("HEAD"))
	private void onInteractOn(Entity entity, net.minecraft.world.InteractionHand hand, CallbackInfoReturnable<net.minecraft.world.InteractionResult> cir) {
		Player self = (Player) (Object) this;
		if (self.level().isClientSide())
			return;
		PlayerEvents.PLAYER_RIGHT_CLICK_ENTITY.invoker().onPlayerRightClickEntity(self, self.level(), hand, entity);
	}

	@Inject(method = "tick", at = @At("TAIL"))
	private void onPlayerSleepCheck(CallbackInfo ci) {
		Player self = (Player) (Object) this;
		if (self.level().isClientSide())
			return;
		boolean sleeping = self.isSleeping();
		if (sleeping && !th$wasSleeping) {
			PlayerEvents.PLAYER_START_SLEEPING.invoker().onPlayerStartSleeping(self, self.blockPosition());
		} else if (!sleeping && th$wasSleeping) {
			PlayerEvents.PLAYER_STOP_SLEEPING.invoker().onPlayerStopSleeping(self, self.blockPosition());
		}
		th$wasSleeping = sleeping;
	}

}

<#-- @formatter:on -->