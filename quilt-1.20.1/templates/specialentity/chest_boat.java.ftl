<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2025, Pylo, opensource contributors
-->

<#-- @formatter:off -->
<#assign specialentities = w.getGElementsOfType("specialentity")?filter(e -> e.entityType == "ChestBoat")>
<#if specialentities?has_content>
package ${package}.entity;

import net.minecraft.world.level.block.Blocks;
import net.minecraft.world.level.block.Block;
import net.minecraft.world.level.Level;
import net.minecraft.world.entity.vehicle.ChestBoat;
import net.minecraft.world.entity.EntityType;
import net.minecraft.util.StringRepresentable;
import net.minecraft.util.ByIdMap;
import net.minecraft.network.syncher.SynchedEntityData;
import net.minecraft.network.syncher.EntityDataSerializers;
import net.minecraft.network.syncher.EntityDataAccessor;
import net.minecraft.world.item.Item;
import net.minecraft.world.entity.vehicle.Boat;
import net.minecraft.network.chat.Component;
import net.minecraft.nbt.CompoundTag;

import ${package}.init.${JavaModName}Entities;
import ${package}.init.${JavaModName}Items;

import java.util.function.IntFunction;

public class ${JavaModName}ChestBoat extends ChestBoat {
	private static final EntityDataAccessor<Integer> DATA_ID_TYPE = SynchedEntityData.defineId(${JavaModName}ChestBoat.class, EntityDataSerializers.INT);

	public ${JavaModName}ChestBoat(EntityType<? extends Boat> entityType, Level level) {
		super(entityType, level);
	}

	public ${JavaModName}ChestBoat(Level level, double x, double y, double z) {
		this(${JavaModName}Entities.${JavaModName?upper_case}_CHEST_BOAT, level);
		this.setPos(x, y, z);
		this.xo = x;
		this.yo = y;
		this.zo = z;
	}

	@Override protected Component getTypeName() {
		return Component.translatable("entity.minecraft.chest_boat");
	}

	@Override public Item getDropItem() {
		return switch (getModVariant()) {
		<#list specialentities as entity>
		    case ${entity.getModElement().getRegistryNameUpper()} -> ${JavaModName}Items.${entity.getModElement().getRegistryNameUpper()};
		</#list>
		    default -> Items.AIR;
		};
	}

	@Override protected void defineSynchedData() {
		super.defineSynchedData();
		this.entityData.define(DATA_ID_TYPE, ${JavaModName}Boat.Type.${specialentities[0].getModElement().getRegistryNameUpper()}.ordinal());
	}

	@Override protected void addAdditionalSaveData(CompoundTag compound) {
		compound.putString("Type", getModVariant().getSerializedName());
	}

	@Override protected void readAdditionalSaveData(CompoundTag compound) {
		if (compound.contains("Type", 8)) {
			setVariant(${JavaModName}Boat.Type.byName(compound.getString("Type")));
		}
	}

	public void setVariant(${JavaModName}Boat.Type variant) {
		this.entityData.set(DATA_ID_TYPE, variant.ordinal());
	}

	public ${JavaModName}Boat.Type getModVariant() {
		return ${JavaModName}Boat.Type.byId(this.entityData.get(DATA_ID_TYPE));
	}
}
</#if>
<#-- @formatter:on -->
