<#include "procedures.java.ftl">
public ${name}Procedure() {
	LivingEntityEvents.ENTITY_HURT.register((entity, damagesource, amount) -> {
		if (entity != null) {
			<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
				"x": "entity.getX()",
				"y": "entity.getY()",
				"z": "entity.getZ()",
				"amount": "amount",
				"world": "entity.level()",
				"entity": "entity",
				"damagesource": "damagesource",
				"sourceentity": "damagesource.getEntity()",
				"immediatesourceentity": "damagesource.getDirectEntity()"
				}/>
			</#assign>
			execute(${dependenciesCode});
		}
	});
}