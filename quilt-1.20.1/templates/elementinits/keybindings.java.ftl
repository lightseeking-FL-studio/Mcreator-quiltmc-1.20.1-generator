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
 *	MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

import net.fabricmc.fabric.api.client.event.lifecycle.v1.ClientTickEvents;
import net.fabricmc.fabric.api.client.keybinding.v1.KeyBindingHelper;
import net.fabricmc.fabric.api.networking.v1.PacketByteBufs;
import org.quiltmc.qsl.networking.api.client.ClientPlayNetworking;
import net.minecraft.client.KeyMapping;
import net.minecraft.client.Minecraft;

public class ${JavaModName}KeyMappings {

	<#list keybinds as keybind>
	public static final KeyMapping ${keybind.getModElement().getRegistryNameUpper()} = KeyBindingHelper.registerKeyBinding(new KeyMapping(
			"key.${modid}.${keybind.getModElement().getRegistryName()}",
			<#if keybind.triggerKey?starts_with("MOUSE")>
				InputConstants.Type.MOUSE, GLFW.GLFW_${generator.map(keybind.triggerKey, "keybuttons")},
			<#else>
				GLFW.GLFW_KEY_${generator.map(keybind.triggerKey, "keybuttons")},
			</#if>
			"key.categories.${keybind.keyBindingCategoryKey}")
				<#if hasProcedure(keybind.onKeyReleased) || hasProcedure(keybind.onKeyPressed)>
				{
					private boolean isDownOld = false;

					@Override public void setDown(boolean isDown) {
						super.setDown(isDown);

						if (isDownOld != isDown && isDown) {
							<#if hasProcedure(keybind.onKeyPressed)>
								net.minecraft.network.FriendlyByteBuf buf = PacketByteBufs.create();
								buf.writeInt(0);
								buf.writeInt(0);
								org.quiltmc.qsl.networking.api.client.ClientPlayNetworking.send(${keybind.getModElement().getName()}Message.ID, buf);
								${keybind.getModElement().getName()}Message.pressAction(Minecraft.getInstance().player, 0, 0);
							</#if>

							<#if hasProcedure(keybind.onKeyReleased)>
								${keybind.getModElement().getRegistryNameUpper()}_LASTPRESS = System.currentTimeMillis();
							</#if>
						}
						<#if hasProcedure(keybind.onKeyReleased)>
						else if (isDownOld != isDown && !isDown) {
							int dt = (int) (System.currentTimeMillis() - ${keybind.getModElement().getRegistryNameUpper()}_LASTPRESS);
							net.minecraft.network.FriendlyByteBuf buf = PacketByteBufs.create();
							buf.writeInt(1);
							buf.writeInt(dt);
							org.quiltmc.qsl.networking.api.client.ClientPlayNetworking.send(${keybind.getModElement().getName()}Message.ID, buf);
							${keybind.getModElement().getName()}Message.pressAction(Minecraft.getInstance().player, 1, dt);
						}
						</#if>

						isDownOld = isDown;
					}
				}
				</#if>
			);
	</#list>

	<#list keybinds as keybind>
		<#if hasProcedure(keybind.onKeyReleased)>
		private static long ${keybind.getModElement().getRegistryNameUpper()}_LASTPRESS = 0;
		</#if>
	</#list>

	public static void registerKeyMappings() {
		// Key mappings are registered via KeyBindingHelper.registerKeyBinding above
	}

	public static void onClientTick() {
		if (Minecraft.getInstance().screen == null) {
		<#list keybinds as keybind>
			<#if hasProcedure(keybind.onKeyPressed) || hasProcedure(keybind.onKeyReleased)>
				${keybind.getModElement().getRegistryNameUpper()}.consumeClick();
			</#if>
		</#list>
		}
	}

}

<#-- @formatter:on -->