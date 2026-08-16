<#include "procedures.java.ftl">
public ${name}Procedure() {
	LivingEntityEvents.ENTITY_TAMED.register((entity, tamer) -> {
		if (entity != null) {
			<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
				"x": "entity.getX()",
				"y": "entity.getY()",
				"z": "entity.getZ()",
				"world": "entity.level()",
				"entity": "entity",
				"sourceentity": "tamer"
				}/>
			</#assign>
			execute(${dependenciesCode});
		}
		boolean result = eventResult;
		eventResult = true;
		return result;
	});
}