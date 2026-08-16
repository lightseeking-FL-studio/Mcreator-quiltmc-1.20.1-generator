<#include "procedures.java.ftl">
public ${name}Procedure() {
	PlayerEvents.PLAYER_CRITICAL_HIT.register((player, target, damage) -> {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
			"x": "player.getX()",
			"y": "player.getY()",
			"z": "player.getZ()",
			"world": "player.level()",
			"entity": "player",
			"targetentity": "target",
			"damage": "damage"
			}/>
		</#assign>
		execute(${dependenciesCode});
	});
}