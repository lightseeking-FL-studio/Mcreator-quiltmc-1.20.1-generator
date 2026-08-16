<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2025, Pylo, opensource contributors
-->

<#-- @formatter:off -->
package ${package}.item;

import net.minecraft.world.entity.EntitySelector;
import net.minecraft.world.phys.HitResult;
import net.minecraft.world.phys.Vec3;
import net.minecraft.server.level.ServerLevel;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.level.ClipContext;
import net.minecraft.world.entity.player.Player;
import net.minecraft.world.InteractionResultHolder;
import net.minecraft.world.InteractionHand;
import net.minecraft.world.level.Level;
import net.minecraft.world.entity.Entity;
import net.minecraft.world.entity.vehicle.Boat;

<#assign specialentities = w.getGElementsOfType("specialentity")>
<#assign hasBoat = specialentities?filter(e -> e.entityType == "Boat")?size != 0>
<#assign hasChestBoat = specialentities?filter(e -> e.entityType == "ChestBoat")?size != 0>

<#assign variantSetterCode>
<#if hasChestBoat && hasBoat>
		if(boat instanceof ${JavaModName}ChestBoat chestBoat) {
			chestBoat.setVariant(this.type);
		} else if(boat instanceof ${JavaModName}Boat boatt) {
			boatt.setVariant(this.type);
		}
<#elseif hasChestBoat>
		if(boat instanceof ${JavaModName}ChestBoat chestBoat)
			chestBoat.setVariant(this.type);
<#else>
		if(boat instanceof ${JavaModName}Boat boatt)
			boatt.setVariant(this.type);
</#if>
</#assign>

public class ${JavaModName}BoatItem extends Item {
	private static final Predicate<Entity> ENTITY_PREDICATE = EntitySelector.NO_SPECTATORS.and(Entity::isPickable);
	private final ${JavaModName}Boat.Type type;
	private final boolean hasChest;

	public ${JavaModName}BoatItem(${JavaModName}Boat.Type type) {
		super(new Item.Properties().stacksTo(1));
		this.hasChest = type.hasChest();
		this.type = type;
	}

	@Override
	public InteractionResultHolder<ItemStack> use(Level level, Player player, InteractionHand hand) {
		ItemStack itemstack = player.getItemInHand(hand);
		HitResult hitresult = getPlayerPOVHitResult(level, player, ClipContext.Fluid.ANY);
		if (hitresult.getType() == HitResult.Type.MISS) {
			return InteractionResultHolder.pass(itemstack);
		} else {
			Vec3 vec3 = hitresult.getLocation();
			Boat boat = this.getBoat(level, hitresult);
			${variantSetterCode}
			boat.setYRot(player.getYRot());
			boat.moveTo(vec3.x, vec3.y, vec3.z);
			if (level instanceof ServerLevel serverlevel) {
				if (!level.noCollision(boat, boat.getBoundingBox())) {
					return InteractionResultHolder.fail(itemstack);
				}
				serverlevel.addFreshEntity(boat);
			}
			itemstack.shrink(1);
			return InteractionResultHolder.sidedSuccess(itemstack, level.isClientSide());
		}
	}

	private Boat getBoat(Level level, HitResult hitResult) {
		<#if hasBoat && hasChestBoat>
		return hasChest ? new ${JavaModName}ChestBoat(level, hitResult.getLocation().x, hitResult.getLocation().y, hitResult.getLocation().z) : new ${JavaModName}Boat(level, hitResult.getLocation().x, hitResult.getLocation().y, hitResult.getLocation().z);
		<#elseif hasChestBoat>
		return new ${JavaModName}ChestBoat(level, hitResult.getLocation().x, hitResult.getLocation().y, hitResult.getLocation().z);
		<#else>
		return new ${JavaModName}Boat(level, hitResult.getLocation().x, hitResult.getLocation().y, hitResult.getLocation().z);
		</#if>
	}
}
<#-- @formatter:on -->
