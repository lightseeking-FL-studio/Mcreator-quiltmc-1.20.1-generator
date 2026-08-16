<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2023, Pylo, opensource contributors
 # Copyright (C) 2026, htqkeku, Lightseeking(FL) Studio — Procedures/DispenseBehaviors conditional init
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

package ${package};

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.quiltmc.loader.api.ModContainer;
import org.quiltmc.qsl.base.api.entrypoint.ModInitializer;

import net.fabricmc.fabric.api.event.lifecycle.v1.ServerTickEvents;
import net.fabricmc.fabric.api.networking.v1.ServerPlayNetworking;
import net.fabricmc.fabric.api.networking.v1.PacketByteBufs;
import org.quiltmc.qsl.networking.api.client.ClientPlayNetworking;
import net.fabricmc.fabric.api.networking.v1.ServerPlayConnectionEvents;
import net.fabricmc.fabric.api.entity.event.v1.ServerPlayerEvents;

import net.minecraft.network.FriendlyByteBuf;
import net.minecraft.resources.ResourceLocation;
import net.minecraft.server.MinecraftServer;
import net.minecraft.server.level.ServerPlayer;
import net.minecraft.world.entity.Entity;
import net.minecraft.world.level.LevelAccessor;
import net.minecraft.world.level.Level;
import net.minecraft.server.level.ServerLevel;

import java.util.Queue;
import java.util.UUID;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.PriorityQueue;
import java.util.Comparator;
import java.util.HashMap;
import java.util.function.BiConsumer;
import java.util.function.Function;
import java.util.function.Supplier;

public class ${JavaModName} implements ModInitializer {

	public static final Logger LOGGER = LoggerFactory.getLogger(${JavaModName}.class);

	public static final String MODID = "${modid}";

	// Used to trigger static initialization of some registry classes
	private static void _init(Class<?> cl) {
		try {
			Class.forName(cl.getName());
		} catch (ClassNotFoundException e) {
			throw new RuntimeException(e);
		}
	}

	@Override
	public void onInitialize(ModContainer mod) {
		// Start of user code block mod init
		// End of user code block mod init

		// Initialize registries
		<@javacompress>
		<#if w.hasSounds()>_init(${JavaModName}Sounds.class);</#if>
		<#if types["base:blocks"]??>${JavaModName}Blocks.registerBlocks();</#if>
		<#if types["base:blockentities"]??>_init(${JavaModName}BlockEntities.class);</#if>
		<#if types["base:items"]??>${JavaModName}Items.registerItems();</#if>
		<#if types["base:entities"]??>_init(${JavaModName}Entities.class);<#if w.hasElementsOfType("livingentity")>${JavaModName}Entities.registerAttributes();</#if></#if>
		<#if w.getGElementsOfType("gamerule")?size != 0>_init(${JavaModName}GameRules.class);</#if>
		<#if w.hasItemsInTabs()>${JavaModName}Tabs.registerTabs(); ${JavaModName}Tabs.buildTabContentsVanilla();</#if>
		<#if w.hasElementsOfType("feature")>_init(${JavaModName}Features.class);</#if>
		<#if w.getGElementsOfType("painting")?size != 0>_init(${JavaModName}Paintings.class);</#if>
		<#if w.getGElementsOfType("potion")?size != 0>_init(${JavaModName}Potions.class);</#if>
		<#if w.getGElementsOfType("potioneffect")?size != 0>_init(${JavaModName}MobEffects.class);</#if>
		<#if w.getGElementsOfType("enchantment")?size != 0>_init(${JavaModName}Enchantments.class);</#if>
		<#if w.getGElementsOfType("gui")?size != 0>_init(${JavaModName}Menus.class);</#if>
		<#if w.getGElementsOfType("particle")?size != 0>_init(${JavaModName}ParticleTypes.class);</#if>
		<#if w.getGElementsOfType("villagerprofession")?size != 0>_init(${JavaModName}VillagerProfessions.class);</#if>
		<#if w.getGElementsOfType("villagertrade")?size != 0>${JavaModName}Trades.registerTrades();</#if>
		<#if w.getGElementsOfType("fluid")?size != 0>
			_init(${JavaModName}Fluids.class);
			_init(${JavaModName}FluidTypes.class);
		</#if>
		<#if w.getGElementsOfType("attribute")?size != 0>
		_init(${JavaModName}Attributes.class);
		${JavaModName}Attributes.addAttributes();
		</#if>
		<#if w.getGElementsOfType("bannerpattern")?size != 0>_init(${JavaModName}BannerPatterns.class);</#if>
		<#if w.hasElementsOfType("command")>${JavaModName}Commands.registerCommands();</#if>
		<#if w.hasElementsOfType("keybind")>${JavaModName}KeyMappingsServer.registerKeyMappingsServer();</#if>
		<#if w.hasElementsOfType("itemextension")>${JavaModName}ItemExtensions.registerItemExtensions();</#if>
		<#if (w.getGElementsOfType('itemextension')?filter(e -> e.hasDispenseBehavior)?size != 0) || w.hasElementsOfType('specialentity')>${JavaModName}DispenseBehaviors.init();</#if>
		<#if w.getGElementsOfType('recipe')?filter(e -> e.recipeType == 'Brewing')?size != 0>${JavaModName}BrewingRecipes.registerBrewingRecipes();</#if>
		<#if w.getGElementsOfType('procedure')?filter(e -> !e.procedurexml?contains('no_ext_trigger'))?size != 0>${JavaModName}Procedures.registerProcedures();</#if>
		</@javacompress>



		<#if w.hasVariablesOfScope("GLOBAL_WORLD") || w.hasVariablesOfScope("GLOBAL_MAP") || w.hasVariablesOfScope("PLAYER_LIFETIME") || w.hasVariablesOfScope("PLAYER_PERSISTENT") || w.hasVariablesOfScope("GLOBAL_SESSION")>
		// Initialize variable networking
		${JavaModName}Variables.init();
		</#if>
		<#if w.hasVariablesOfScope("PLAYER_LIFETIME") || w.hasVariablesOfScope("PLAYER_PERSISTENT")>
		// Register player variable events
		${JavaModName}Variables.registerPlayerEvents();
		</#if>
		<#if w.hasVariablesOfScope("GLOBAL_WORLD") || w.hasVariablesOfScope("GLOBAL_MAP")>
		// Register world variable events
		${JavaModName}Variables.registerWorldEvents();
		</#if>

		// Register networking receivers
		registerNetworking();

		// Register tick handler for server work queue
		ServerTickEvents.END_SERVER_TICK.register(server -> {
			int currentTick = server.getTickCount();

			IntObjectPair<Runnable> work;
			while ((work = workToBeScheduled.poll()) != null) {
				workQueue.add(new TickTask(currentTick + work.leftInt(), work.right()));
			}

			while (!workQueue.isEmpty() && currentTick >= workQueue.peek().getTick()) {
				workQueue.poll().run();
			}
		});

		// Start of user code block mod post-init
		// End of user code block mod post-init
	}

	<#-- Networking support -->
	public static final ResourceLocation CHANNEL = new ResourceLocation(MODID, "main");

	private static final Map<Class<?>, PacketCodec<?>> packetCodecs = new HashMap<>();
	private static int messageID = 0;

	private record PacketCodec<T>(
			Class<T> type,
			BiConsumer<T, FriendlyByteBuf> encoder,
			Function<FriendlyByteBuf, T> decoder,
			BiConsumer<T, Supplier<ServerPlayer>> handler,
			ResourceLocation packetId
		) {}

	public static <T> void addNetworkMessage(ResourceLocation packetId, Class<T> messageType,
											 BiConsumer<T, FriendlyByteBuf> encoder,
											 Function<FriendlyByteBuf, T> decoder,
											 BiConsumer<T, Supplier<ServerPlayer>> messageConsumer) {
		packetCodecs.put(messageType, new PacketCodec<>(messageType, encoder, decoder, messageConsumer, packetId));

		// Register server-side receiver
		ServerPlayNetworking.registerGlobalReceiver(packetId, (server, player, handler, buf, responseSender) -> {
			T message = decoder.apply(buf);
			messageConsumer.accept(message, () -> player);
		});
	}

	private static void registerNetworking() {
		// Networking receivers are registered lazily via addNetworkMessage calls
		ServerPlayNetworking.registerGlobalReceiver(
			new ResourceLocation(MODID, "player_left_click_air"),
			(server, player, handler, buf, sender) -> {
				PlayerEvents.PLAYER_LEFT_CLICKS_AIR.invoker().onPlayerLeftClicksAir(player);
			}
		);
	}

	<#-- Packet sending helpers -->
	public static void sendToServer(Object message) {
		PacketCodec<?> codec = packetCodecs.get(message.getClass());
		if (codec != null) {
			FriendlyByteBuf buf = PacketByteBufs.create();
			@SuppressWarnings("unchecked")
			PacketCodec<Object> c = (PacketCodec<Object>) codec;
			c.encoder().accept(message, buf);
			ClientPlayNetworking.send(c.packetId(), buf);
		}
	}

	public static void sendToPlayer(ServerPlayer player, Object message) {
		PacketCodec<?> codec = packetCodecs.get(message.getClass());
		if (codec != null) {
			FriendlyByteBuf buf = PacketByteBufs.create();
			@SuppressWarnings("unchecked")
			PacketCodec<Object> c = (PacketCodec<Object>) codec;
			c.encoder().accept(message, buf);
			ServerPlayNetworking.send(player, c.packetId(), buf);
		}
	}

	<#-- Wait procedure block support -->
	private static final Queue<IntObjectPair<Runnable>> workToBeScheduled = new ConcurrentLinkedQueue<>();
	private static final PriorityQueue<TickTask> workQueue = new PriorityQueue<>(Comparator.comparingInt(TickTask::getTick));

	public static void queueServerWork(int delay, Runnable action) {
		workToBeScheduled.add(new IntObjectImmutablePair<>(delay, action));
	}

	private record TickTask(int tick, Runnable action) implements Comparable<TickTask>, Runnable {
		public int getTick() { return tick; }

		@Override public void run() { action.run(); }

		@Override public int compareTo(TickTask o) {
			return Integer.compare(this.tick, o.getTick());
		}
	}

	// Simple pair implementation to replace Forge's IntObjectPair
	public interface IntObjectPair<T> {
		int leftInt();
		T right();
	}

	private record IntObjectImmutablePair<T>(int leftInt, T right) implements IntObjectPair<T> {}

}

<#-- @formatter:on -->