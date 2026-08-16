<#include "procedures.java.ftl">
public ${name}Procedure() {
	LivingEntityEvents.ENTITY_STRUCK_BY_LIGHTNING.register((entity, source, target) -> {
		if (entity != null) {
			<#assign dependenciesCode>
				<@procedureDependenciesCode dependencies, {
				"x": "entity.getX()",
				"y": "entity.getY()",
				"z": "entity.getZ()",
				"world": "entity.level()",
				"entity": "entity",
				"sourceentity": "source",
				"target": "target"
				}/>
			</#assign>
			execute(${dependenciesCode});
		}
	});
}
