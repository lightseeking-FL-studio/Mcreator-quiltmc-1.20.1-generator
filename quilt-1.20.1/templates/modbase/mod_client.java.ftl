<#-- @formatter:off -->
package ${package};

import org.quiltmc.loader.api.ModContainer;
import org.quiltmc.qsl.base.api.entrypoint.client.ClientModInitializer;

import net.fabricmc.fabric.api.client.event.lifecycle.v1.ClientTickEvents;
import net.fabricmc.fabric.api.client.networking.v1.ClientPlayNetworking;
import net.minecraft.client.MinecraftClient;
import net.minecraft.resources.ResourceLocation;
import net.fabricmc.fabric.api.networking.v1.PacketByteBufs;
import net.minecraft.world.phys.HitResult;

public class ${JavaModName}Client implements ClientModInitializer {

	private static boolean th$lastAttackDown = false;
	private static boolean th$lastUseDown = false;

	@Override
	public void onInitializeClient(ModContainer mod) {
		// Start of user code block client init
		// End of user code block client init

		<@javacompress>
		<#if w.getGElementsOfType("item")?filter(e -> e.customProperties?has_content)?size != 0
			|| w.getGElementsOfType("tool")?filter(e -> e.toolType == "Shield")?size != 0>
		${JavaModName}Items.clientLoad();
		</#if>
		<#if w.getGElementsOfType("block")?filter(e -> e.tintType != "No tint")?size != 0>
		${JavaModName}Blocks.BlocksClientSideHandler.blockColorLoad();
		${JavaModName}Blocks.BlocksClientSideHandler.itemColorLoad();
		</#if>
		<#if w.getGElementsOfType("block")?filter(e -> e.isSign())?size != 0>
		${JavaModName}Blocks.BlocksClientSideHandler.clientSetup();
		</#if>
		<#if w.hasElementsOfType("fluid")>
		${JavaModName}Fluids.FluidsClientSideHandler.clientSetup();
		</#if>
		<#if w.hasElementsOfType("specialentity")>
		${JavaModName}Models.registerLayerDefinitions();
		</#if>
		${JavaModName}EntityRenderers.registerEntityRenderers();
		<#if w.hasElementsOfType("gui")>
		${JavaModName}Screens.clientLoad();
		</#if>
		<#if w.hasElementsOfType("particle")>
		${JavaModName}Particles.clientLoad();
		</#if>
		<#if w.hasElementsOfType("overlay")>
		${JavaModName}Overlays.registerOverlays();
		</#if>
		<#if w.getGElementsOfType('dimension')?filter(e -> e.useCustomEffects)?size != 0>
		${JavaModName}DimensionsEffects.registerDimensionsEffects();
		</#if>
		<#if w.hasElementsOfType("keybind")>
		${JavaModName}KeyMappings.registerKeyMappings();
		ClientTickEvents.END_CLIENT_TICK.register(minecraft -> {
			${JavaModName}KeyMappings.onClientTick();
		});
		</#if>
		ClientTickEvents.START_CLIENT_TICK.register(client -> {
			boolean attackDown = client.options.keyAttack.isDown();
			if (client.player != null && attackDown && !th$lastAttackDown) {
				if (client.hitResult == null || client.hitResult.getType() == HitResult.Type.MISS) {
					ClientPlayNetworking.send(
						new ResourceLocation("${modid}", "player_left_click_air"),
						PacketByteBufs.create()
					);
				}
			}
			th$lastAttackDown = attackDown;

			boolean useDown = client.options.keyUse.isDown();
			if (client.player != null && useDown && !th$lastUseDown) {
				if (client.player.getMainHandItem().isEmpty() && client.player.getOffhandItem().isEmpty()) {
					ClientPlayNetworking.send(
						new ResourceLocation("${modid}", "player_right_click_empty_hand"),
						PacketByteBufs.create()
					);
				}
			}
			th$lastUseDown = useDown;
		});
		</@javacompress>

		// Start of user code block client post-init
		// End of user code block client post-init
	}
}

<#-- @formatter:on -->
