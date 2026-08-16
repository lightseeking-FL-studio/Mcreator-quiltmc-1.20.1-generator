<#include "procedures.java.ftl">
public ${name}Procedure() {
	PlayerEvents.PLAYER_RIGHT_CLICK_ENTITY.register((player, level, hand, entity) -> {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
			"x": "entity.getX()",
			"y": "entity.getY()",
			"z": "entity.getZ()",
			"world": "level",
			"entity": "entity",
			"sourceentity": "player"
			}/>
		</#assign>
		if (hand == player.getUsedItemHand())
		    execute(${dependenciesCode});
	});
}