<#include "procedures.java.ftl">
public ${name}Procedure() {
	LivingEntityEvents.ENTITY_FALL.register((entity, falldistance, damagemultiplier) -> {
		if (entity != null) {
			<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
				"x": "entity.getX()",
				"y": "entity.getY()",
				"z": "entity.getZ()",
				"distance": "falldistance",
				"damagemultiplier": "damagemultiplier",
				"world": "entity.level()",
				"entity": "entity"
				}/>
			</#assign>
			execute(${dependenciesCode});
		}
		boolean result = eventResult;
		eventResult = true;
		return result;
	});
}