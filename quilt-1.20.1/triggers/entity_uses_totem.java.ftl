<#include "procedures.java.ftl">
public ${name}Procedure() {
	LivingEntityEvents.ENTITY_USE_TOTEM.register((entity, hand) -> {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
			"x": "entity.getX()",
			"y": "entity.getY()",
			"z": "entity.getZ()",
			"world": "entity.level()",
			"entity": "entity",
			"sourceentity": "entity"
			}/>
		</#assign>
		execute(${dependenciesCode});
	});
}
