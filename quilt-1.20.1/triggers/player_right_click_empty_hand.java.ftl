<#include "procedures.java.ftl">
public ${name}Procedure() {
	net.fabricmc.fabric.api.networking.v1.ServerPlayNetworking.registerGlobalReceiver(
		new net.minecraft.resources.ResourceLocation("${modid}", "player_right_click_empty_hand"),
		(server, player, handler, buf, sender) -> {
			<#assign dependenciesCode>
				<@procedureDependenciesCode dependencies, {
				"x": "player.getX()",
				"y": "player.getY()",
				"z": "player.getZ()",
				"world": "player.level()",
				"entity": "player"
				}/>
			</#assign>
			execute(${dependenciesCode});
		}
	);
}