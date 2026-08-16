<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2025, Pylo, opensource contributors
-->

<#-- @formatter:off -->
<#assign specialentities = w.getGElementsOfType("specialentity")>
<#assign hasBoat = specialentities?filter(e -> e.entityType == "Boat")?size != 0>
<#assign hasChestBoat = specialentities?filter(e -> e.entityType == "ChestBoat")?size != 0>
package ${package}.client.renderer.entity;

import net.minecraft.client.renderer.entity.BoatRenderer;
import net.minecraft.client.renderer.entity.EntityRendererProvider;
import net.minecraft.resources.ResourceLocation;
import net.minecraft.world.entity.vehicle.Boat;
import ${package}.entity.${JavaModName}Boat;
<#if hasChestBoat>
import ${package}.entity.${JavaModName}ChestBoat;
</#if>

import net.fabricmc.api.Environment;
import net.fabricmc.api.EnvType;

@Environment(EnvType.CLIENT)
public class ${JavaModName}BoatRenderer extends BoatRenderer {

	public ${JavaModName}BoatRenderer(EntityRendererProvider.Context context) {
		super(context, ${hasChestBoat?string('true', 'false')});
	}

	@Override
	public ResourceLocation getTextureLocation(Boat boat) {
		<#if hasChestBoat && hasBoat>
		if (boat instanceof ${JavaModName}Boat entityBoat) {
			return getCustomTextureLocation(entityBoat.getModVariant().getName(), entityBoat.getModVariant().hasChest());
		} else if (boat instanceof ${JavaModName}ChestBoat entityChestBoat) {
			return getCustomTextureLocation(entityChestBoat.getModVariant().getName(), true);
		}
		<#elseif hasChestBoat>
		if (boat instanceof ${JavaModName}ChestBoat entityChestBoat) {
			return getCustomTextureLocation(entityChestBoat.getModVariant().getName(), true);
		}
		<#else>
		if (boat instanceof ${JavaModName}Boat entityBoat) {
			return getCustomTextureLocation(entityBoat.getModVariant().getName(), false);
		}
		</#if>
		return super.getTextureLocation(boat);
	}

	private ResourceLocation getCustomTextureLocation(String typeName, boolean hasChest) {
		return new ResourceLocation("${modid}", hasChest ? "textures/entity/chest_boat/" + typeName + ".png" : "textures/entity/boat/" + typeName + ".png");
	}

}
<#-- @formatter:on -->
