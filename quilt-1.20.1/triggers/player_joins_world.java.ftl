<#include "procedures.java.ftl">
public ${name}Procedure() {
	net.fabricmc.fabric.api.networking.v1.ServerPlayConnectionEvents.JOIN.register((handler, sender, server) -> {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
			"x": "handler.getPlayer().getX()",
			"y": "handler.getPlayer().getY()",
			"z": "handler.getPlayer().getZ()",
			"world": "handler.getPlayer().level()",
			"entity": "handler.getPlayer()"
			}/>
		</#assign>
		execute(${dependenciesCode});
	});
}
