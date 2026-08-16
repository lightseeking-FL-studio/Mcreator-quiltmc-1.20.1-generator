<#include "procedures.java.ftl">
public ${name}Procedure() {
	PlayerEvents.PLAYER_START_SLEEPING.register((player, blockPos) -> {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
			"x": "blockPos.getX()",
			"y": "blockPos.getY()",
			"z": "blockPos.getZ()",
			"world": "player.level()",
			"entity": "player"
			}/>
		</#assign>
		execute(${dependenciesCode});
	});
}