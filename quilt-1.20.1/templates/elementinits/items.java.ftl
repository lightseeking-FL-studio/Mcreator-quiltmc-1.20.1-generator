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
<#include "../procedures.java.ftl">

/*
 *    MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

<#assign hasBlocks = false>
<#assign hasDoubleBlocks = false>
<#assign hasSigns = false>
<#assign hasHangingSigns = false>
<#assign hasItemsWithProperties = w.getGElementsOfType("item")?filter(e -> e.customProperties?has_content)?size != 0
	|| w.getGElementsOfType("tool")?filter(e -> e.toolType == "Shield")?size != 0>

<#assign chunks = items?chunk(2500)>
<#assign has_chunks = chunks?size gt 1>

public class ${JavaModName}Items {

	<@javacompress>
	<#list items as item>
		<#if item.getModElement().getTypeString() == "armor">
			<#if item.enableHelmet>public static Item ${item.getModElement().getRegistryNameUpper()}_HELMET;</#if>
			<#if item.enableBody>public static Item ${item.getModElement().getRegistryNameUpper()}_CHESTPLATE;</#if>
			<#if item.enableLeggings>public static Item ${item.getModElement().getRegistryNameUpper()}_LEGGINGS;</#if>
			<#if item.enableBoots>public static Item ${item.getModElement().getRegistryNameUpper()}_BOOTS;</#if>
		<#elseif item.getModElement().getTypeString() == "livingentity">
			public static Item ${item.getModElement().getRegistryNameUpper()}_SPAWN_EGG;
		<#elseif item.getModElement().getTypeString() == "fluid" && item.generateBucket>
			public static Item ${item.getModElement().getRegistryNameUpper()}_BUCKET;
		<#else>
			public static Item ${item.getModElement().getRegistryNameUpper()};
		</#if>
	</#list>
	</@javacompress>

	<#list chunks as sub_items>
	<#if has_chunks>public static void register${sub_items?index}()<#else>public static void registerItems()</#if> {
		<#list sub_items as item>
			<#if item.getModElement().getTypeString() == "armor">
				<#if item.enableHelmet>
				${item.getModElement().getRegistryNameUpper()}_HELMET =
					Registry.register(BuiltInRegistries.ITEM, new ResourceLocation("${modid}", "${item.getModElement().getRegistryName()}_helmet"),
						new ${item.getModElement().getName()}Item.Helmet());
				</#if>
				<#if item.enableBody>
				${item.getModElement().getRegistryNameUpper()}_CHESTPLATE =
					Registry.register(BuiltInRegistries.ITEM, new ResourceLocation("${modid}", "${item.getModElement().getRegistryName()}_chestplate"),
						new ${item.getModElement().getName()}Item.Chestplate());
				</#if>
				<#if item.enableLeggings>
				${item.getModElement().getRegistryNameUpper()}_LEGGINGS =
					Registry.register(BuiltInRegistries.ITEM, new ResourceLocation("${modid}", "${item.getModElement().getRegistryName()}_leggings"),
						new ${item.getModElement().getName()}Item.Leggings());
				</#if>
				<#if item.enableBoots>
				${item.getModElement().getRegistryNameUpper()}_BOOTS =
					Registry.register(BuiltInRegistries.ITEM, new ResourceLocation("${modid}", "${item.getModElement().getRegistryName()}_boots"),
						new ${item.getModElement().getName()}Item.Boots());
				</#if>
			<#elseif item.getModElement().getTypeString() == "livingentity">
				${item.getModElement().getRegistryNameUpper()}_SPAWN_EGG =
					Registry.register(BuiltInRegistries.ITEM, new ResourceLocation("${modid}", "${item.getModElement().getRegistryName()}_spawn_egg"),
						new SpawnEggItem(${JavaModName}Entities.${item.getModElement().getRegistryNameUpper()},
						${item.spawnEggBaseColor.getRGB()}, ${item.spawnEggDotColor.getRGB()}, new Item.Properties()));
			<#elseif item.getModElement().getTypeString() == "specialentity">
				${item.getModElement().getRegistryNameUpper()} =
					Registry.register(BuiltInRegistries.ITEM, new ResourceLocation("${modid}", "${item.getModElement().getRegistryName()}"),
						new ${JavaModName}BoatItem(${JavaModName}Boat.Type.${item.getModElement().getRegistryNameUpper()}));
			<#elseif item.getModElement().getTypeString() == "dimension" && item.hasIgniter()>
				${item.getModElement().getRegistryNameUpper()} =
					Registry.register(BuiltInRegistries.ITEM, new ResourceLocation("${modid}", "${item.getModElement().getRegistryName()}"),
						new ${item.getModElement().getName()}Item());
			<#elseif item.getModElement().getTypeString() == "fluid" && item.generateBucket>
				${item.getModElement().getRegistryNameUpper()}_BUCKET =
					Registry.register(BuiltInRegistries.ITEM, new ResourceLocation("${modid}", "${item.getModElement().getRegistryName()}_bucket"),
						new ${item.getModElement().getName()}Item());
			<#elseif item.getModElement().getTypeString() == "block" || item.getModElement().getTypeString() == "plant">
				<#if item.isDoubleBlock()>
					<#assign hasDoubleBlocks = true>
					${item.getModElement().getRegistryNameUpper()} =
					doubleBlock(${JavaModName}Blocks.${item.getModElement().getRegistryNameUpper()}
					<#if item.hasCustomItemProperties()>, <@blockItemProperties item/></#if>);
				<#elseif (item.getModElement().getTypeString() == "block") && (item.blockBase! == "Sign")>
					<#assign hasSigns = true>
					${item.getModElement().getRegistryNameUpper()} =
					signBlock(${JavaModName}Blocks.${item.getModElement().getRegistryNameUpper()}, ${JavaModName}Blocks.${item.getWallRegistryNameUpper()}
					<#if item.hasCustomItemProperties()>, <@blockItemProperties item/></#if>);
				<#elseif (item.getModElement().getTypeString() == "block") && (item.blockBase! == "HangingSign")>
					<#assign hasHangingSigns = true>
					${item.getModElement().getRegistryNameUpper()} =
					hangingSignBlock(${JavaModName}Blocks.${item.getModElement().getRegistryNameUpper()}, ${JavaModName}Blocks.${item.getWallRegistryNameUpper()}
					<#if item.hasCustomItemProperties()>, <@blockItemProperties item/></#if>);
				<#else>
					<#assign hasBlocks = true>
					${item.getModElement().getRegistryNameUpper()} =
					block(${JavaModName}Blocks.${item.getModElement().getRegistryNameUpper()}
					<#if item.hasCustomItemProperties()>, <@blockItemProperties item/></#if>);
				</#if>
			<#else>
				${item.getModElement().getRegistryNameUpper()} =
					Registry.register(BuiltInRegistries.ITEM, new ResourceLocation("${modid}", "${item.getModElement().getRegistryName()}"),
						new ${item.getModElement().getName()}Item());
			</#if>
		</#list>
	}
	</#list>

	<#if has_chunks>
	public static void registerItems() {
		<#list 0..chunks?size-1 as i>register${i}();</#list>
	}
	</#if>

	// Start of user code block custom items
	// End of user code block custom items

	<#if hasBlocks>
	private static Item block(Block block) {
		return block(block, new Item.Properties());
	}

	private static Item block(Block block, Item.Properties properties) {
		return Registry.register(BuiltInRegistries.ITEM, BuiltInRegistries.BLOCK.getKey(block), new BlockItem(block, properties));
	}
	</#if>

	<#if hasDoubleBlocks>
	private static Item doubleBlock(Block block) {
		return doubleBlock(block, new Item.Properties());
	}

	private static Item doubleBlock(Block block, Item.Properties properties) {
		return Registry.register(BuiltInRegistries.ITEM, BuiltInRegistries.BLOCK.getKey(block), new BlockItem(block, properties));
	}
	</#if>

	<#if hasSigns>
	private static Item signBlock(Block block, Block wallBlock) {
		return signBlock(block, wallBlock, new Item.Properties());
	}

	private static Item signBlock(Block block, Block wallBlock, Item.Properties properties) {
		return Registry.register(BuiltInRegistries.ITEM, BuiltInRegistries.BLOCK.getKey(block), new SignItem(properties, block, wallBlock));
	}
	</#if>

	<#if hasHangingSigns>
	private static Item hangingSignBlock(Block block, Block wallBlock) {
		return hangingSignBlock(block, wallBlock, new Item.Properties());
	}

	private static Item hangingSignBlock(Block block, Block wallBlock, Item.Properties properties) {
		return Registry.register(BuiltInRegistries.ITEM, BuiltInRegistries.BLOCK.getKey(block), new HangingSignItem(block, wallBlock, properties));
	}
	</#if>

	<#if hasItemsWithProperties>
	public static void clientLoad() {
		<@javacompress>
		<#list items as item>
			<#if item.getModElement().getTypeString() == "item">
				<#list item.customProperties.entrySet() as property>
				ItemProperties.register(${item.getModElement().getRegistryNameUpper()},
					new ResourceLocation("${modid}:${item.getModElement().getRegistryName()}_${property.getKey()}"),
					(itemStackToRender, clientWorld, entity, itemEntityId) ->
						<#if hasProcedure(property.getValue())>
							(float) <@procedureCode property.getValue(), {
								"x": "entity != null ? entity.getX() : 0",
								"y": "entity != null ? entity.getY() : 0",
								"z": "entity != null ? entity.getZ() : 0",
								"world": "entity != null ? entity.level() : clientWorld",
								"entity": "entity",
								"itemstack": "itemStackToRender"
							}, false/>
						<#else>0</#if>
				);
				</#list>
			<#elseif item.getModElement().getTypeString() == "tool" && item.toolType == "Shield">
				ItemProperties.register(${item.getModElement().getRegistryNameUpper()}, new ResourceLocation("blocking"),
					ItemProperties.getProperty(Items.SHIELD, new ResourceLocation("blocking")));
			</#if>
		</#list>
		</@javacompress>
	}
	</#if>
}
<#macro blockItemProperties block>
new Item.Properties()
<#if block.maxStackSize != 64>
	.stacksTo(${block.maxStackSize})
</#if>
<#if block.rarity != "COMMON">
	.rarity(Rarity.${block.rarity})
</#if>
<#if block.immuneToFire>
	.fireResistant()
</#if>
</#macro>
<#-- @formatter:on -->