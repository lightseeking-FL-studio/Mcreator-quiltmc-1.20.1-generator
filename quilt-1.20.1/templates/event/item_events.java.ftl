<#-- @formatter:off -->
package ${package}.event;

import net.fabricmc.fabric.api.event.Event;
import net.fabricmc.fabric.api.event.EventFactory;
import net.fabricmc.fabric.api.item.v1.ModifyItemAttributeModifiersCallback;
import net.minecraft.core.BlockPos;
import net.minecraft.world.entity.Entity;
import net.minecraft.world.entity.player.Player;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.level.block.state.BlockState;

public class ItemEvents {

	public static final Event<BonemealUsed> BONEMEAL_USED = EventFactory.createArrayBacked(BonemealUsed.class, (callbacks) -> (position, entity, itemstack, blockstate) -> {
		for (BonemealUsed event : callbacks) {
			boolean result = event.onBonemealUsed(position, entity, itemstack, blockstate);
			if (!result) {
				return false;
			}
		}
		return true;
	});

	public static final Event<ItemDespawn> ITEM_DESPAWN = EventFactory.createArrayBacked(ItemDespawn.class, (callbacks) -> (entity, itemstack) -> {
		for (ItemDespawn event : callbacks) {
			event.onItemDespawn(entity, itemstack);
		}
	});

	public static final Event<ItemSmelted> ITEM_SMELTED = EventFactory.createArrayBacked(ItemSmelted.class, (callbacks) -> (entity, itemstack) -> {
		for (ItemSmelted event : callbacks) {
			event.onItemSmelted(entity, itemstack);
		}
	});

	public static final Event<ItemCrafted> ITEM_CRAFTED = EventFactory.createArrayBacked(ItemCrafted.class, (callbacks) -> (entity, itemstack) -> {
		for (ItemCrafted event : callbacks) {
			event.onItemCrafted(entity, itemstack);
		}
	});

	public static final Event<ItemDestroyed> ITEM_DESTROYED = EventFactory.createArrayBacked(ItemDestroyed.class, (callbacks) -> (entity, itemstack) -> {
		for (ItemDestroyed event : callbacks) {
			event.onItemDestroyed(entity, itemstack);
		}
	});

	public static final Event<ItemAttributeModifier> ITEM_ATTRIBUTE_MODIFIER = EventFactory.createArrayBacked(ItemAttributeModifier.class, (callbacks) -> (itemstack) -> {
		for (ItemAttributeModifier event : callbacks) {
			event.onItemAttributeModifier(itemstack);
		}
	});

	static {
		ModifyItemAttributeModifiersCallback.EVENT.register((stack, slot, attributeModifiers) -> {
			ITEM_ATTRIBUTE_MODIFIER.invoker().onItemAttributeModifier(stack);
		});
	}

	@FunctionalInterface
	public interface BonemealUsed {
		boolean onBonemealUsed(BlockPos position, Entity entity, ItemStack itemstack, BlockState blockstate);
	}

	@FunctionalInterface
	public interface ItemDespawn {
		void onItemDespawn(net.minecraft.world.entity.Entity entity, ItemStack itemstack);
	}

	@FunctionalInterface
	public interface ItemSmelted {
		void onItemSmelted(Player entity, ItemStack itemstack);
	}

	@FunctionalInterface
	public interface ItemCrafted {
		void onItemCrafted(Player entity, ItemStack itemstack);
	}

	@FunctionalInterface
	public interface ItemDestroyed {
		void onItemDestroyed(Player entity, ItemStack itemstack);
	}

	@FunctionalInterface
	public interface ItemAttributeModifier {
		void onItemAttributeModifier(ItemStack itemstack);
	}
}
<#-- @formatter:on -->