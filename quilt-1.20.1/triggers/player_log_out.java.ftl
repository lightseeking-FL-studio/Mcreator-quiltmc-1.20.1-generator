<#include "procedures.java.ftl">
public ${name}Procedure() {
	net.fabricmc.fabric.api.networking.v1.ServerPlayConnectionEvents.DISCONNECT.register((handler, server) -> {
		var player = handler.getPlayer();
		if (player == null) return;
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
	});
}