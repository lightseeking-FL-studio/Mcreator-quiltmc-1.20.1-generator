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

<#assign hasTintedBlocks = false>
<#assign hasTintedBlockItems = false>
<#list blocks as block>
	<#if block.getModElement().getTypeString() == "block">
		<#if block.tintType != "No tint">
			<#assign hasTintedBlocks = true>
			<#if block.isItemTinted && block.hasBlockItem>
				<#assign hasTintedBlockItems = true>
			</#if>
		</#if>
	<#elseif block.getModElement().getTypeString() == "plant">
		<#if block.tintType != "No tint">
			<#assign hasTintedBlocks = true>
			<#if block.isItemTinted && block.hasBlockItem>
				<#assign hasTintedBlockItems = true>
			</#if>
		</#if>
	</#if>
</#list>

<#assign signs = w.getGElementsOfType("block")?filter(e -> e.isSign())>

<#assign chunks = blocks?chunk(2500)>
<#assign has_chunks = chunks?size gt 1>

public class ${JavaModName}Blocks {

	<@javacompress>
	<#list blocks as block>
		<#if block.getModElement().getTypeString() == "dimension">
			<#if block.enablePortal>
            public static Block ${block.getModElement().getRegistryNameUpper()}_PORTAL;
			</#if>
		<#else>
			public static Block ${block.getModElement().getRegistryNameUpper()};
			<#if (block.getModElement().getTypeString() == "block") && block.isSign()>
				public static Block ${block.getWallRegistryNameUpper()};
			</#if>
		</#if>
	</#list>
	</@javacompress>

	<#list chunks as sub_blocks>
	<#if has_chunks>public static void register${sub_blocks?index}()<#else>public static void registerBlocks()</#if> {
		<#list sub_blocks as block>
			<#if block.getModElement().getTypeString() == "dimension">
				<#if block.enablePortal>
        	    ${block.getModElement().getRegistryNameUpper()}_PORTAL =
					Registry.register(BuiltInRegistries.BLOCK, new ResourceLocation("${modid}", "${block.getModElement().getRegistryName()}_portal"),
						new ${block.getModElement().getName()}PortalBlock());
				</#if>
			<#else>
				${block.getModElement().getRegistryNameUpper()} =
					Registry.register(BuiltInRegistries.BLOCK, new ResourceLocation("${modid}", "${block.getModElement().getRegistryName()}"),
						new ${block.getModElement().getName()}Block());
				<#if (block.getModElement().getTypeString() == "block") && block.isSign()>
					${block.getWallRegistryNameUpper()} =
						Registry.register(BuiltInRegistries.BLOCK, new ResourceLocation("${modid}", "${block.getWallRegistryName()}"),
							new ${block.getWallName()}Block());
				</#if>
			</#if>
		</#list>
	}
	</#list>

	<#if has_chunks>
	public static void registerBlocks() {
		<#list 0..chunks?size-1 as i>register${i}();</#list>
	}
	</#if>

	// Start of user code block custom blocks
	// End of user code block custom blocks

	<#if hasTintedBlocks || hasTintedBlockItems || (signs?size != 0)>
	public static class BlocksClientSideHandler {
		<#if hasTintedBlocks>
		public static void blockColorLoad() {
			<#list blocks as block>
				<#if block.getModElement().getTypeString() == "block" || block.getModElement().getTypeString() == "plant">
					<#if block.tintType != "No tint">
						 ${block.getModElement().getName()}Block.blockColorLoad();
					</#if>
				</#if>
			</#list>
		}
		</#if>

		<#if hasTintedBlockItems>
		public static void itemColorLoad() {
			<#list blocks as block>
				<#if block.getModElement().getTypeString() == "block" || block.getModElement().getTypeString() == "plant">
					<#if block.tintType != "No tint" && block.isItemTinted && block.hasBlockItem>
						 ${block.getModElement().getName()}Block.itemColorLoad();
					</#if>
				</#if>
			</#list>
		}
		</#if>

		<#if signs?size != 0>
		public static void clientSetup() {
			<#list signs as block>
				Sheets.addWoodType(${JavaModName}WoodTypes.${block.getModElement().getRegistryNameUpper()}_WOOD_TYPE);
			</#list>
		}
		</#if>
	}
	</#if>

}
<#-- @formatter:on -->