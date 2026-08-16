<#include "procedures.java.ftl">
public ${name}Procedure() {
	LivingEntityEvents.ENTITY_SET_ATTACK_TARGET.register((entity, target) -> {
		if (entity != null) {
			<#assign dependenciesCode>
				<@procedureDependenciesCode dependencies, {
				"x": "entity.getX()",
				"y": "entity.getY()",
				"z": "entity.getZ()",
				"world": "entity.level()",
				"entity": "entity",
				"target": "target",
				"sourceentity": "target"
				}/>
			</#assign>
			execute(${dependenciesCode});
		}
	});
}
