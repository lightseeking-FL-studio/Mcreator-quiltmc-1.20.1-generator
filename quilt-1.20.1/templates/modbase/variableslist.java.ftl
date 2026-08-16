<#-- @formatter:off -->
package ${package}.network;

import ${package}.${JavaModName};

import net.fabricmc.fabric.api.networking.v1.PacketByteBufs;
import net.fabricmc.fabric.api.networking.v1.ServerPlayNetworking;
import net.fabricmc.fabric.api.networking.v1.ServerPlayConnectionEvents;
import net.fabricmc.fabric.api.networking.v1.PlayerLookup;
import net.fabricmc.fabric.api.entity.event.v1.ServerPlayerEvents;
import net.fabricmc.fabric.api.event.lifecycle.v1.ServerTickEvents;
import net.fabricmc.fabric.api.networking.v1.ServerPlayNetworking;

import net.minecraft.nbt.CompoundTag;
import net.minecraft.world.level.Level;
import net.minecraft.world.level.LevelAccessor;
import net.minecraft.world.level.saveddata.SavedData;
import net.minecraft.server.level.ServerLevel;
import net.minecraft.server.level.ServerPlayer;
import net.minecraft.world.entity.Entity;
import net.minecraft.world.entity.player.Player;
import net.minecraft.network.FriendlyByteBuf;
import net.minecraft.resources.ResourceLocation;
import net.minecraft.client.Minecraft;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.function.Supplier;

public class ${JavaModName}Variables {

	<#if w.hasVariablesOfScope("GLOBAL_SESSION")>
		<#list variables as var>
			<#if var.getScope().name() == "GLOBAL_SESSION">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_SESSION")['init']?interpret/>
			</#if>
		</#list>
	</#if>

	public static void init() {
		<#if w.hasVariablesOfScope("GLOBAL_WORLD") || w.hasVariablesOfScope("GLOBAL_MAP")>
			${JavaModName}.addNetworkMessage(SavedDataSyncMessage.ID, SavedDataSyncMessage.class, SavedDataSyncMessage::buffer, SavedDataSyncMessage::new, SavedDataSyncMessage::handleData);
		</#if>

		<#if w.hasVariablesOfScope("PLAYER_LIFETIME") || w.hasVariablesOfScope("PLAYER_PERSISTENT")>
			${JavaModName}.addNetworkMessage(PlayerVariablesSyncMessage.ID, PlayerVariablesSyncMessage.class, PlayerVariablesSyncMessage::buffer, PlayerVariablesSyncMessage::new, PlayerVariablesSyncMessage::handleData);
		</#if>
	}

	<#if w.hasVariablesOfScope("PLAYER_LIFETIME") || w.hasVariablesOfScope("PLAYER_PERSISTENT")>
	public static void registerPlayerEvents() {
		ServerPlayConnectionEvents.JOIN.register((handler, sender, server) -> {
			ServerPlayer player = handler.getPlayer();
			if (player instanceof ServerPlayer serverPlayer) {
				PlayerVariables playerVars = PlayerVariables.get(player.getUUID());
				FriendlyByteBuf buf = PacketByteBufs.create();
				buf.writeNbt(playerVars.serializeNBT());
				ServerPlayNetworking.send(serverPlayer, PlayerVariablesSyncMessage.ID, buf);
			}
		});

		ServerPlayerEvents.AFTER_RESPAWN.register((oldPlayer, newPlayer, alive) -> {
			ServerPlayer player = (ServerPlayer) newPlayer;
			PlayerVariables playerVars = PlayerVariables.get(player.getUUID());
			FriendlyByteBuf buf = PacketByteBufs.create();
			buf.writeNbt(playerVars.serializeNBT());
			ServerPlayNetworking.send(player, PlayerVariablesSyncMessage.ID, buf);
		});

		ServerPlayerEvents.COPY_FROM.register((oldPlayer, newPlayer, alive) -> {
			PlayerVariables oldVars = PlayerVariables.get(oldPlayer.getUUID());
			PlayerVariables newVars = PlayerVariables.get(newPlayer.getUUID());
			<#list variables as var>
				<#if var.getScope().name() == "PLAYER_PERSISTENT">
				newVars.${var.getName()} = oldVars.${var.getName()};
				</#if>
			</#list>
			if(!alive) {
				<#list variables as var>
					<#if var.getScope().name() == "PLAYER_LIFETIME">
					newVars.${var.getName()} = oldVars.${var.getName()};
					</#if>
				</#list>
			}
		});
	}
	</#if>

	<#if w.hasVariablesOfScope("GLOBAL_WORLD") || w.hasVariablesOfScope("GLOBAL_MAP")>
	public static void registerWorldEvents() {
		ServerPlayConnectionEvents.JOIN.register((handler, sender, server) -> {
			ServerPlayer player = handler.getPlayer();
			if (player instanceof ServerPlayer serverPlayer) {
				SavedData mapdata = MapVariables.get(player.level());
				SavedData worlddata = WorldVariables.get(player.level());
				if (mapdata != null) {
					FriendlyByteBuf buf = PacketByteBufs.create();
				buf.writeInt(0);
				buf.writeNbt(mapdata.save(new CompoundTag()));
				ServerPlayNetworking.send(serverPlayer, SavedDataSyncMessage.ID, buf);
			}
			if (worlddata != null) {
				FriendlyByteBuf buf = PacketByteBufs.create();
				buf.writeInt(1);
				buf.writeNbt(worlddata.save(new CompoundTag()));
				ServerPlayNetworking.send(serverPlayer, SavedDataSyncMessage.ID, buf);
			}
			}
		});

		ServerTickEvents.END_WORLD_TICK.register(world -> {
			if (world instanceof ServerLevel level) {
				WorldVariables worldVariables = WorldVariables.get(level);
				if (worldVariables._syncDirty) {
					FriendlyByteBuf buf = PacketByteBufs.create();
					buf.writeInt(1);
					buf.writeNbt(worldVariables.save(new CompoundTag()));
					for (ServerPlayer player : PlayerLookup.world(level)) {
						ServerPlayNetworking.send(player, SavedDataSyncMessage.ID, buf);
					}
					worldVariables._syncDirty = false;
				}

				MapVariables mapVariables = MapVariables.get(level);
				if (mapVariables._syncDirty) {
					FriendlyByteBuf buf = PacketByteBufs.create();
					buf.writeInt(0);
					buf.writeNbt(mapVariables.save(new CompoundTag()));
					for (ServerPlayer player : PlayerLookup.all(level.getServer())) {
						ServerPlayNetworking.send(player, SavedDataSyncMessage.ID, buf);
					}
					mapVariables._syncDirty = false;
				}
			}
		});
	}
	</#if>

	<#if w.hasVariablesOfScope("GLOBAL_WORLD") || w.hasVariablesOfScope("GLOBAL_MAP")>
	public static class WorldVariables extends SavedData {

		public static final String DATA_NAME = "${modid}_worldvars";

		boolean _syncDirty = false;

		<#list variables as var>
			<#if var.getScope().name() == "GLOBAL_WORLD">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_WORLD")['init']?interpret/>
			</#if>
		</#list>

		public static WorldVariables load(CompoundTag tag) {
			WorldVariables data = new WorldVariables();
			data.read(tag);
			return data;
		}

		public void read(CompoundTag nbt) {
			<#list variables as var>
				<#if var.getScope().name() == "GLOBAL_WORLD">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_WORLD")['read']?interpret/>
				</#if>
			</#list>
		}

		@Override public CompoundTag save(CompoundTag nbt) {
			<#list variables as var>
				<#if var.getScope().name() == "GLOBAL_WORLD">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_WORLD")['write']?interpret/>
				</#if>
			</#list>
			return nbt;
		}

		public void markSyncDirty() {
			this.setDirty();
			this._syncDirty = true;
		}

		static WorldVariables clientSide = new WorldVariables();

		public static WorldVariables get(LevelAccessor world) {
			if (world instanceof ServerLevel level) {
				return level.getDataStorage().computeIfAbsent(e -> WorldVariables.load(e), WorldVariables::new, DATA_NAME);
			} else {
				return clientSide;
			}
		}
	}

	public static class MapVariables extends SavedData {

		public static final String DATA_NAME = "${modid}_mapvars";

		boolean _syncDirty = false;

		<#list variables as var>
			<#if var.getScope().name() == "GLOBAL_MAP">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_MAP")['init']?interpret/>
			</#if>
		</#list>

		public static MapVariables load(CompoundTag tag) {
			MapVariables data = new MapVariables();
			data.read(tag);
			return data;
		}

		public void read(CompoundTag nbt) {
			<#list variables as var>
				<#if var.getScope().name() == "GLOBAL_MAP">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_MAP")['read']?interpret/>
				</#if>
			</#list>
		}

		@Override public CompoundTag save(CompoundTag nbt) {
			<#list variables as var>
				<#if var.getScope().name() == "GLOBAL_MAP">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_MAP")['write']?interpret/>
				</#if>
			</#list>
			return nbt;
		}

		public void markSyncDirty() {
			this.setDirty();
			_syncDirty = true;
		}

		static MapVariables clientSide = new MapVariables();

		public static MapVariables get(LevelAccessor world) {
			if (world instanceof ServerLevel serverLevel) {
				return serverLevel.getServer().getLevel(Level.OVERWORLD).getDataStorage()
						.computeIfAbsent(e -> MapVariables.load(e), MapVariables::new, DATA_NAME);
			} else {
				return clientSide;
			}
		}
	}

	public static class SavedDataSyncMessage {
		public static final ResourceLocation ID = new ResourceLocation("${modid}", "saved_data_sync");
		private final int dataType;
		private final SavedData data;

		public SavedDataSyncMessage(int dataType, SavedData data) {
			this.dataType = dataType;
			this.data = data;
		}

		public SavedDataSyncMessage(FriendlyByteBuf buffer) {
			int dataType = buffer.readInt();
			CompoundTag nbt = buffer.readNbt();
			SavedData data = null;
			if (nbt != null) {
				data = dataType == 0 ? new MapVariables() : new WorldVariables();
				if (data instanceof MapVariables mapVariables)
					mapVariables.read(nbt);
				else if (data instanceof WorldVariables worldVariables)
					worldVariables.read(nbt);
			}

			this.dataType = dataType;
			this.data = data;
		}

		public static void buffer(SavedDataSyncMessage message, FriendlyByteBuf buffer) {
			buffer.writeInt(message.dataType);
			if (message.data != null)
				buffer.writeNbt(message.data.save(new CompoundTag()));
		}

		public static void handleData(final SavedDataSyncMessage message, final Supplier<ServerPlayer> contextSupplier) {
			if (message.data != null) {
				if (message.dataType == 0)
					MapVariables.clientSide.read(message.data.save(new CompoundTag()));
				else
					WorldVariables.clientSide.read(message.data.save(new CompoundTag()));
			}
		}
	}
	</#if>

	<#if w.hasVariablesOfScope("PLAYER_LIFETIME") || w.hasVariablesOfScope("PLAYER_PERSISTENT")>
	private static final Map<UUID, PlayerVariables> PLAYER_VARIABLES_MAP = new HashMap<>();

	public static class PlayerVariables {

		boolean _syncDirty = false;

		<#list variables as var>
			<#if var.getScope().name() == "PLAYER_LIFETIME">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_LIFETIME")['init']?interpret/>
			<#elseif var.getScope().name() == "PLAYER_PERSISTENT">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_PERSISTENT")['init']?interpret/>
			</#if>
		</#list>

		public static PlayerVariables get(UUID uuid) {
			return PLAYER_VARIABLES_MAP.computeIfAbsent(uuid, k -> new PlayerVariables());
		}

		public CompoundTag serializeNBT() {
			CompoundTag nbt = new CompoundTag();
			<#list variables as var>
				<#if var.getScope().name() == "PLAYER_LIFETIME">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_LIFETIME")['write']?interpret/>
				<#elseif var.getScope().name() == "PLAYER_PERSISTENT">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_PERSISTENT")['write']?interpret/>
				</#if>
			</#list>
			return nbt;
		}

		public void deserializeNBT(CompoundTag nbt) {
			<#list variables as var>
				<#if var.getScope().name() == "PLAYER_LIFETIME">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_LIFETIME")['read']?interpret/>
				<#elseif var.getScope().name() == "PLAYER_PERSISTENT">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_PERSISTENT")['read']?interpret/>
				</#if>
			</#list>
		}

		public void markSyncDirty() {
			_syncDirty = true;
		}
	}

	public record PlayerVariablesSyncMessage(PlayerVariables data) {
		public static final ResourceLocation ID = new ResourceLocation("${modid}", "player_variables_sync");

		public PlayerVariablesSyncMessage(FriendlyByteBuf buffer) {
			this(new PlayerVariables());
			data.deserializeNBT(buffer.readNbt());
		}

		public static void buffer(PlayerVariablesSyncMessage message, FriendlyByteBuf buffer) {
			buffer.writeNbt(message.data().serializeNBT());
		}

		public static void handleData(final PlayerVariablesSyncMessage message, final Supplier<ServerPlayer> contextSupplier) {
			// Client-side handling is registered separately via ClientPlayNetworking
		}
	}

	public static void handlePlayerVariablesSyncClient(PlayerVariablesSyncMessage message) {
		if (Minecraft.getInstance().player != null && message.data != null) {
			PlayerVariables playerVars = PlayerVariables.get(Minecraft.getInstance().player.getUUID());
			<#list variables as var>
				<#if var.getScope().name() == "PLAYER_LIFETIME" || var.getScope().name() == "PLAYER_PERSISTENT">
				playerVars.${var.getName()} = message.data().${var.getName()};
				</#if>
			</#list>
		}
	}
	</#if>

}
<#-- @formatter:on -->