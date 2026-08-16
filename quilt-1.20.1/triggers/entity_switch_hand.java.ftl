<#include "procedures.java.ftl">
public ${name}Procedure() {
	LivingEntityEvents.ENTITY_SWITCH_HAND.register((entity, mainHand, offHand) -> {
		if (entity != null) {
			<#assign dependenciesCode>
				<@procedureDependenciesCode dependencies, {
				"x": "entity.getX()",
				"y": "entity.getY()",
				"z": "entity.getZ()",
				"world": "entity.level()",
				"entity": "entity",
				"newmainhanditem": "mainHand",
				"newoffhanditem": "offHand"
				}/>
			</#assign>
			execute(${dependenciesCode});
		}
	});
}
