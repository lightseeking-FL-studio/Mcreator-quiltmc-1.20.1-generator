<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2023, Pylo, opensource contributors
 #
 # This program is free software: you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <https://www.gnu.org/licenses/>.
 #
 # Additional permission for code generator templates (*.ftl files)
 #
 # As a special exception, you may create a larger work that contains part or
 # all of the MCreator code generator templates (*.ftl files) and distribute
 # that work under terms of your choice, so long as that work isn't itself a
 # template for code generation. Alternatively, if you modify or redistribute
 # the template itself, you may (at your option) remove this special exception,
 # which will cause the template and the resulting code generator output files
 # to be licensed under the GNU General Public License without this special
 # exception.
-->

<#-- @formatter:off -->

/*
 *    MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

import net.minecraft.core.Registry;
import net.minecraft.core.registries.BuiltInRegistries;
import net.minecraft.resources.ResourceLocation;
import net.minecraft.world.entity.ai.attributes.RangedAttribute;
import net.minecraft.world.entity.ai.attributes.Attribute;
import net.minecraft.world.entity.ai.attributes.AttributeSupplier;
import net.minecraft.world.entity.ai.attributes.DefaultAttributes;
import net.minecraft.world.entity.EntityType;
import net.minecraft.world.entity.player.Player;

import java.util.Map;

public class ${JavaModName}Attributes {

	public static final Attribute SWIM_SPEED = Registry.register(
		BuiltInRegistries.ATTRIBUTE, new ResourceLocation("${modid}", "swim_speed"),
		new RangedAttribute("attribute.name.${modid}.swim_speed", 1.0D, 0.0D, 1024.0D).setSyncable(true)
	);

	public static final Attribute NAMETAG_RENDER_DISTANCE = Registry.register(
		BuiltInRegistries.ATTRIBUTE, new ResourceLocation("${modid}", "nametag_distance"),
		new RangedAttribute("attribute.name.${modid}.nametag_distance", 64.0D, 0.0D, 1024.0D).setSyncable(true)
	);

	public static final Attribute ENTITY_GRAVITY = Registry.register(
		BuiltInRegistries.ATTRIBUTE, new ResourceLocation("${modid}", "entity_gravity"),
		new RangedAttribute("attribute.name.${modid}.entity_gravity", 0.08D, -1.0D, 1.0D).setSyncable(true)
	);

	public static final Attribute BLOCK_REACH = Registry.register(
		BuiltInRegistries.ATTRIBUTE, new ResourceLocation("${modid}", "block_reach"),
		new RangedAttribute("attribute.name.${modid}.block_reach", 4.5D, 0.0D, 1024.0D).setSyncable(true)
	);

	public static final Attribute ENTITY_REACH = Registry.register(
		BuiltInRegistries.ATTRIBUTE, new ResourceLocation("${modid}", "entity_reach"),
		new RangedAttribute("attribute.name.${modid}.entity_reach", 3.0D, 0.0D, 1024.0D).setSyncable(true)
	);

	public static final Attribute STEP_HEIGHT = Registry.register(
		BuiltInRegistries.ATTRIBUTE, new ResourceLocation("${modid}", "step_height_addition"),
		new RangedAttribute("attribute.name.${modid}.step_height_addition", 0.0D, 0.0D, 1024.0D).setSyncable(true)
	);

	<#if attributes??>
	<#list attributes as attribute>
	public static final Attribute ${attribute.getModElement().getRegistryNameUpper()} = Registry.register(
		BuiltInRegistries.ATTRIBUTE, new ResourceLocation("${modid}", "${attribute.getModElement().getRegistryName()}"),
		new RangedAttribute("attribute.name.${modid}.${attribute.getModElement().getRegistryName()}", ${attribute.defaultValue}, ${attribute.minValue}, ${attribute.maxValue}).setSyncable(true)
	);
	</#list>
	</#if>

	public static void addAttributes() {
		<#if attributes??>
		<#list attributes as attribute>
			<#if attribute.addToAllEntities>
				DefaultAttributes.getAllTypes().forEach(entityType -> modifyEntityAttributes(entityType, ${attribute.getModElement().getRegistryNameUpper()}));
			<#else>
				<#if attribute.entities?has_content>
					<#list attribute.entities as entity>
						modifyEntityAttributes(${generator.map(entity.getUnmappedValue(), "entities", 1)}, ${attribute.getModElement().getRegistryNameUpper()});
					</#list>
				</#if>
				<#if attribute.addToPlayers>
					modifyEntityAttributes(EntityType.PLAYER, ${attribute.getModElement().getRegistryNameUpper()});
				</#if>
			</#if>
		</#list>
		</#if>
	}

	@SuppressWarnings("unchecked")
	private static void modifyEntityAttributes(EntityType<?> entityType, Attribute attribute) {
		try {
			java.lang.reflect.Field field = DefaultAttributes.class.getDeclaredField("SUPPLIERS");
			field.setAccessible(true);
			Map<EntityType<? extends net.minecraft.world.entity.LivingEntity>, AttributeSupplier> suppliers =
				(Map<EntityType<? extends net.minecraft.world.entity.LivingEntity>, AttributeSupplier>) field.get(null);
			if (suppliers.containsKey(entityType)) {
				AttributeSupplier original = suppliers.get(entityType);
				java.lang.reflect.Field instancesField = AttributeSupplier.class.getDeclaredField("instances");
				instancesField.setAccessible(true);
				Map<Attribute, net.minecraft.world.entity.ai.attributes.AttributeInstance> instances =
					(Map<Attribute, net.minecraft.world.entity.ai.attributes.AttributeInstance>) instancesField.get(original);
				AttributeSupplier.Builder builder = AttributeSupplier.builder();
				for (var entry : instances.entrySet()) {
					builder.add(entry.getKey(), entry.getValue().getBaseValue());
				}
				builder.add(attribute, attribute.getDefaultValue());
				suppliers.put((EntityType<? extends net.minecraft.world.entity.LivingEntity>) entityType, builder.build());
			}
		} catch (Exception e) {
			throw new RuntimeException("Failed to add attribute to entity", e);
		}
	}

}
<#-- @formatter:on -->
