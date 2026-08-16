<#include "procedures.java.ftl">
public ${name}Procedure() {
	PlayerEvents.PLAYER_LEFT_CLICKS_AIR.register((player) -> {
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