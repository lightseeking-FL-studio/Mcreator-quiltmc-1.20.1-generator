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
 *	MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

import net.fabricmc.fabric.api.client.networking.v1.ClientPlayNetworking;
import net.fabricmc.fabric.api.networking.v1.PlayerLookup;
import net.fabricmc.fabric.api.networking.v1.ServerPlayNetworking;
import net.minecraft.client.Minecraft;
import net.minecraft.core.Registry;
import net.minecraft.core.registries.BuiltInRegistries;
import net.minecraft.resources.ResourceLocation;
import net.minecraft.server.level.ServerPlayer;
import net.minecraft.world.entity.player.Player;
import net.minecraft.world.flag.FeatureFlagSet;
import net.minecraft.world.inventory.MenuType;
import net.minecraft.world.inventory.Slot;

import java.util.HashMap;
import java.util.Map;

public class ${JavaModName}Menus {

	<#list guis as gui>
	public static final MenuType<${gui.getModElement().getName()}Menu> ${gui.getModElement().getRegistryNameUpper()}
		= Registry.register(BuiltInRegistries.MENU, new ResourceLocation("${modid}", "${gui.getModElement().getRegistryName()}"),
			new MenuType<>(${gui.getModElement().getName()}Menu::new, FeatureFlagSet.of()));
	</#list>

	public interface MenuAccessor {
		Map<String, Object> getMenuState();

		Map<Integer, Slot> getSlots();

		default void sendMenuStateUpdate(Player player, int elementType, String name, Object elementState, boolean needClientUpdate) {
			getMenuState().put(elementType + ":" + name, elementState);
			if (player instanceof ServerPlayer serverPlayer) {
				net.minecraft.network.FriendlyByteBuf buf = new net.minecraft.network.FriendlyByteBuf(io.netty.buffer.ByteBufAllocator.DEFAULT.buffer());
				MenuStateUpdateMessage.buffer(new MenuStateUpdateMessage(elementType, name, elementState), buf);
				ServerPlayNetworking.send(serverPlayer, MenuStateUpdateMessage.ID, buf);
			} else if (player.level().isClientSide) {
				if (Minecraft.getInstance().screen instanceof ${JavaModName}Screens.ScreenAccessor accessor && needClientUpdate)
					accessor.updateMenuState(elementType, name, elementState);
				net.minecraft.network.FriendlyByteBuf buf = new net.minecraft.network.FriendlyByteBuf(io.netty.buffer.ByteBufAllocator.DEFAULT.buffer());
				MenuStateUpdateMessage.buffer(new MenuStateUpdateMessage(elementType, name, elementState), buf);
				ClientPlayNetworking.send(MenuStateUpdateMessage.ID, buf);
			}
		}

		default <T> T getMenuState(int elementType, String name, T defaultValue) {
			try {
				return (T) getMenuState().getOrDefault(elementType + ":" + name, defaultValue);
			} catch (ClassCastException e) {
				return defaultValue;
			}
		}
	}

}

<#-- @formatter:on -->