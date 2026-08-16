<#-- @formatter:off -->
package ${package}.event;

import net.fabricmc.fabric.api.event.Event;
import net.fabricmc.fabric.api.event.EventFactory;
import net.minecraft.world.entity.player.Player;
import net.minecraft.advancements.Advancement;

public class PlayerEvents {

	public static final Event<PickupXp> PICKUP_XP = EventFactory.createArrayBacked(PickupXp.class, (callbacks) -> (entity) -> {
		for (PickupXp event : callbacks) {
			boolean result = event.onPickupXp(entity);
			if (!result) {
				return false;
			}
		}
		return true;
	});

	public static final Event<EndPlayerTick> END_PLAYER_TICK = EventFactory.createArrayBacked(EndPlayerTick.class, (callbacks) -> (entity) -> {
		for (EndPlayerTick event : callbacks) {
			event.onEndPlayerTick(entity);
		}
	});

	public static final Event<XpChange> XP_CHANGE = EventFactory.createArrayBacked(XpChange.class, (callbacks) -> (entity, amount) -> {
		for (XpChange event : callbacks) {
			event.onXpChange(entity, amount);
		}
	});

	public static final Event<LevelChange> LEVEL_CHANGE = EventFactory.createArrayBacked(LevelChange.class, (callbacks) -> (entity, amount) -> {
		for (LevelChange event : callbacks) {
			event.onLevelChange(entity, amount);
		}
	});

	public static final Event<PlayerDropItem> PLAYER_DROP_ITEM = EventFactory.createArrayBacked(PlayerDropItem.class, (callbacks) -> (entity, itemstack) -> {
		for (PlayerDropItem event : callbacks) {
			event.onPlayerDropItem(entity, itemstack);
		}
	});

	public static final Event<PlayerCompletesAdvancement> PLAYER_COMPLETES_ADVANCEMENT = EventFactory.createArrayBacked(PlayerCompletesAdvancement.class, (callbacks) -> (player, advancement) -> {
		for (PlayerCompletesAdvancement event : callbacks) {
			event.onPlayerCompletesAdvancement(player, advancement);
		}
	});

	public static final Event<PlayerCriticalHit> PLAYER_CRITICAL_HIT = EventFactory.createArrayBacked(PlayerCriticalHit.class, (callbacks) -> (player, target, damage) -> {
		for (PlayerCriticalHit event : callbacks) {
			event.onPlayerCriticalHit(player, target, damage);
		}
	});

	public static final Event<PlayerFishesItem> PLAYER_FISHES_ITEM = EventFactory.createArrayBacked(PlayerFishesItem.class, (callbacks) -> (player) -> {
		for (PlayerFishesItem event : callbacks) {
			event.onPlayerFishesItem(player);
		}
	});

	public static final Event<PlayerLeftClicksAir> PLAYER_LEFT_CLICKS_AIR = EventFactory.createArrayBacked(PlayerLeftClicksAir.class, (callbacks) -> (player) -> {
		for (PlayerLeftClicksAir event : callbacks) {
			event.onPlayerLeftClicksAir(player);
		}
	});

	public static final Event<PlayerRightClickEntity> PLAYER_RIGHT_CLICK_ENTITY = EventFactory.createArrayBacked(PlayerRightClickEntity.class, (callbacks) -> (player, level, hand, entity) -> {
		for (PlayerRightClickEntity event : callbacks) {
			event.onPlayerRightClickEntity(player, level, hand, entity);
		}
	});

	public static final Event<PlayerRightClickEmptyHand> PLAYER_RIGHT_CLICK_EMPTY_HAND = EventFactory.createArrayBacked(PlayerRightClickEmptyHand.class, (callbacks) -> (player, level, hand) -> {
		for (PlayerRightClickEmptyHand event : callbacks) {
			event.onPlayerRightClickEmptyHand(player, level, hand);
		}
	});

	public static final Event<PlayerStartSleeping> PLAYER_START_SLEEPING = EventFactory.createArrayBacked(PlayerStartSleeping.class, (callbacks) -> (player, blockPos) -> {
		for (PlayerStartSleeping event : callbacks) {
			event.onPlayerStartSleeping(player, blockPos);
		}
	});

	public static final Event<PlayerStopSleeping> PLAYER_STOP_SLEEPING = EventFactory.createArrayBacked(PlayerStopSleeping.class, (callbacks) -> (player, blockPos) -> {
		for (PlayerStopSleeping event : callbacks) {
			event.onPlayerStopSleeping(player, blockPos);
		}
	});

	@FunctionalInterface
	public interface PickupXp {
		boolean onPickupXp(Player entity);
	}

	@FunctionalInterface
	public interface EndPlayerTick {
		void onEndPlayerTick(Player entity);
	}

	@FunctionalInterface
	public interface XpChange {
		void onXpChange(Player entity, int amount);
	}

	@FunctionalInterface
	public interface LevelChange {
		void onLevelChange(Player entity, int amount);
	}

	@FunctionalInterface
	public interface PlayerDropItem {
		void onPlayerDropItem(Player entity, net.minecraft.world.item.ItemStack itemstack);
	}

	@FunctionalInterface
	public interface PlayerCompletesAdvancement {
		void onPlayerCompletesAdvancement(Player player, Advancement advancement);
	}

	@FunctionalInterface
	public interface PlayerCriticalHit {
		void onPlayerCriticalHit(Player player, net.minecraft.world.entity.Entity target, float damage);
	}

	@FunctionalInterface
	public interface PlayerFishesItem {
		void onPlayerFishesItem(Player player);
	}

	@FunctionalInterface
	public interface PlayerLeftClicksAir {
		void onPlayerLeftClicksAir(Player player);
	}

	@FunctionalInterface
	public interface PlayerRightClickEntity {
		void onPlayerRightClickEntity(Player player, net.minecraft.world.level.Level level, net.minecraft.world.InteractionHand hand, net.minecraft.world.entity.Entity entity);
	}

	@FunctionalInterface
	public interface PlayerRightClickEmptyHand {
		void onPlayerRightClickEmptyHand(Player player, net.minecraft.world.level.Level level, net.minecraft.world.InteractionHand hand);
	}

	@FunctionalInterface
	public interface PlayerStartSleeping {
		void onPlayerStartSleeping(Player player, net.minecraft.core.BlockPos blockPos);
	}

	@FunctionalInterface
	public interface PlayerStopSleeping {
		void onPlayerStopSleeping(Player player, net.minecraft.core.BlockPos blockPos);
	}
}
<#-- @formatter:on -->
