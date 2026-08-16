<#-- @formatter:off -->
package ${package}.event;

import net.fabricmc.fabric.api.event.Event;
import net.fabricmc.fabric.api.event.EventFactory;
import net.minecraft.world.entity.Entity;
import net.minecraft.world.entity.LivingEntity;
import net.minecraft.world.damagesource.DamageSource;
import net.minecraft.world.item.ItemStack;
import net.minecraft.resources.ResourceKey;
import net.minecraft.world.level.Level;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

public class LivingEntityEvents {

	public static final Map<UUID, ResourceKey<Level>> ENTITY_DIMENSIONS = new HashMap<>();

	public static final Event<EntityTick> ENTITY_TICK = EventFactory.createArrayBacked(EntityTick.class, (callbacks) -> (entity) -> {
		for (EntityTick event : callbacks) {
			event.onEntityTick(entity);
		}
	});

	public static final Event<EntityBlock> ENTITY_BLOCK = EventFactory.createArrayBacked(EntityBlock.class, (callbacks) -> (entity, damagesource, amount) -> {
		for (EntityBlock event : callbacks) {
			boolean result = event.onEntityBlocked(entity, damagesource, amount);
			if (!result) {
				return false;
			}
		}
		return true;
	});

	public static final Event<EntityDropXp> ENTITY_DROP_XP = EventFactory.createArrayBacked(EntityDropXp.class, (callbacks) -> (entity, sourceentity, amount) -> {
		for (EntityDropXp event : callbacks) {
			boolean result = event.onEntityDropXp(entity, sourceentity, amount);
			if (!result) {
				return false;
			}
		}
		return true;
	});

	public static final Event<EntityFall> ENTITY_FALL = EventFactory.createArrayBacked(EntityFall.class, (callbacks) -> (entity, falldistance, damagemultiplier) -> {
		for (EntityFall event : callbacks) {
			boolean result = event.onEntityFall(entity, falldistance, damagemultiplier);
			if (!result) {
				return false;
			}
		}
		return true;
	});

	public static final Event<EntityGrief> ENTITY_GRIEF = EventFactory.createArrayBacked(EntityGrief.class, (callbacks) -> (entity) -> {
		for (EntityGrief event : callbacks) {
			boolean result = event.onEntityGrief(entity);
			if (!result) {
				return false;
			}
		}
		return true;
	});

	public static final Event<EntityTamed> ENTITY_TAMED = EventFactory.createArrayBacked(EntityTamed.class, (callbacks) -> (entity, tamer) -> {
		for (EntityTamed event : callbacks) {
			boolean result = event.onEntityTamed(entity, tamer);
			if (!result) {
				return false;
			}
		}
		return true;
	});

	public static final Event<EntityHeal> ENTITY_HEAL = EventFactory.createArrayBacked(EntityHeal.class, (callbacks) -> (entity, amount) -> {
		for (EntityHeal event : callbacks) {
			boolean result = event.onEntityHeal(entity, amount);
			if (!result) {
				return false;
			}
		}
		return true;
	});

	public static final Event<EntityPickupItem> ENTITY_PICKUP_ITEM = EventFactory.createArrayBacked(EntityPickupItem.class, (callbacks) -> (entity, itemstack) -> {
		for (EntityPickupItem event : callbacks) {
			event.onEntityPickupItem(entity, itemstack);
		}
	});

	public static final Event<EntityPickupXp> ENTITY_PICKUP_XP = EventFactory.createArrayBacked(EntityPickupXp.class, (callbacks) -> (entity, amount) -> {
		for (EntityPickupXp event : callbacks) {
			event.onEntityPickupXp(entity, amount);
		}
	});

	public static final Event<EntityJump> ENTITY_JUMP = EventFactory.createArrayBacked(EntityJump.class, (callbacks) -> (entity) -> {
		for (EntityJump event : callbacks) {
			event.onEntityJump(entity);
		}
	});

	public static final Event<EntityChangeEquipment> ENTITY_CHANGE_EQUIPMENT = EventFactory.createArrayBacked(EntityChangeEquipment.class, (callbacks) -> (entity, slot, oldItem, newItem) -> {
		for (EntityChangeEquipment event : callbacks) {
			event.onEntityChangeEquipment(entity, slot, oldItem, newItem);
		}
	});

	public static final Event<EntitySetAttackTarget> ENTITY_SET_ATTACK_TARGET = EventFactory.createArrayBacked(EntitySetAttackTarget.class, (callbacks) -> (entity, target) -> {
		for (EntitySetAttackTarget event : callbacks) {
			event.onSetAttackTarget(entity, target);
		}
	});

	public static final Event<EntityHurt> ENTITY_HURT = EventFactory.createArrayBacked(EntityHurt.class, (callbacks) -> (entity, damagesource, amount) -> {
		for (EntityHurt event : callbacks) {
			event.onEntityHurt(entity, damagesource, amount);
		}
	});

	public static final Event<EntityStruckByLightning> ENTITY_STRUCK_BY_LIGHTNING = EventFactory.createArrayBacked(EntityStruckByLightning.class, (callbacks) -> (entity, source, target) -> {
		for (EntityStruckByLightning event : callbacks) {
			event.onStruckByLightning(entity, source, target);
		}
	});

	public static final Event<EntityStopUsingItem> ENTITY_STOP_USING_ITEM = EventFactory.createArrayBacked(EntityStopUsingItem.class, (callbacks) -> (entity, itemstack, duration) -> {
		for (EntityStopUsingItem event : callbacks) {
			event.onEntityStopUsingItem(entity, itemstack, duration);
		}
	});

	public static final Event<EntityFinishUsingItem> ENTITY_FINISH_USING_ITEM = EventFactory.createArrayBacked(EntityFinishUsingItem.class, (callbacks) -> (entity, itemstack) -> {
		for (EntityFinishUsingItem event : callbacks) {
			event.onEntityFinishUsingItem(entity, itemstack);
		}
	});

	public static final Event<EntitySwitchHand> ENTITY_SWITCH_HAND = EventFactory.createArrayBacked(EntitySwitchHand.class, (callbacks) -> (entity, mainHand, offHand) -> {
		for (EntitySwitchHand event : callbacks) {
			event.onEntitySwitchHand(entity, mainHand, offHand);
		}
	});

	public static final Event<EntityUseTotem> ENTITY_USE_TOTEM = EventFactory.createArrayBacked(EntityUseTotem.class, (callbacks) -> (entity, hand) -> {
		for (EntityUseTotem event : callbacks) {
			event.onEntityUseTotem(entity, hand);
		}
	});

	public static final Event<EntityTravelsToDimension> ENTITY_TRAVELS_TO_DIMENSION = EventFactory.createArrayBacked(EntityTravelsToDimension.class, (callbacks) -> (entity, origin, destination) -> {
		for (EntityTravelsToDimension event : callbacks) {
			event.onEntityTravelsToDimension(entity, origin, destination);
		}
	});

	@FunctionalInterface
	public interface EntityTick {
		void onEntityTick(LivingEntity entity);
	}

	@FunctionalInterface
	public interface EntityBlock {
		boolean onEntityBlocked(LivingEntity entity, DamageSource damagesource, float amount);
	}

	@FunctionalInterface
	public interface EntityDropXp {
		boolean onEntityDropXp(LivingEntity entity, Entity sourceentity, int amount);
	}

	@FunctionalInterface
	public interface EntityFall {
		boolean onEntityFall(LivingEntity entity, float falldistance, float damagemultiplier);
	}

	@FunctionalInterface
	public interface EntityGrief {
		boolean onEntityGrief(Entity entity);
	}

	@FunctionalInterface
	public interface EntityTamed {
		boolean onEntityTamed(LivingEntity entity, net.minecraft.world.entity.player.Player tamer);
	}

	@FunctionalInterface
	public interface EntityHeal {
		boolean onEntityHeal(LivingEntity entity, float amount);
	}

	@FunctionalInterface
	public interface EntityPickupItem {
		void onEntityPickupItem(LivingEntity entity, ItemStack itemstack);
	}

	@FunctionalInterface
	public interface EntityPickupXp {
		void onEntityPickupXp(LivingEntity entity, int amount);
	}

	@FunctionalInterface
	public interface EntityJump {
		void onEntityJump(LivingEntity entity);
	}

	@FunctionalInterface
	public interface EntityChangeEquipment {
		void onEntityChangeEquipment(LivingEntity entity, net.minecraft.world.entity.EquipmentSlot slot, ItemStack oldItem, ItemStack newItem);
	}

	@FunctionalInterface
	public interface EntitySetAttackTarget {
		void onSetAttackTarget(LivingEntity entity, LivingEntity target);
	}

	@FunctionalInterface
	public interface EntityHurt {
		void onEntityHurt(LivingEntity entity, DamageSource damagesource, float amount);
	}

	@FunctionalInterface
	public interface EntityStruckByLightning {
		void onStruckByLightning(LivingEntity entity, Entity source, Entity target);
	}

	@FunctionalInterface
	public interface EntityStopUsingItem {
		void onEntityStopUsingItem(LivingEntity entity, ItemStack itemstack, int duration);
	}

	@FunctionalInterface
	public interface EntityFinishUsingItem {
		void onEntityFinishUsingItem(LivingEntity entity, ItemStack itemstack);
	}

	@FunctionalInterface
	public interface EntitySwitchHand {
		void onEntitySwitchHand(LivingEntity entity, ItemStack mainHand, ItemStack offHand);
	}

	@FunctionalInterface
	public interface EntityUseTotem {
		void onEntityUseTotem(LivingEntity entity, net.minecraft.world.InteractionHand hand);
	}

	@FunctionalInterface
	public interface EntityTravelsToDimension {
		void onEntityTravelsToDimension(LivingEntity entity, Level origin, Level destination);
	}
}
<#-- @formatter:on -->