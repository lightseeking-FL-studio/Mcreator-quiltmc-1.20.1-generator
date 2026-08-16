<#include "procedures.java.ftl">
public ${name}Procedure() {
	LivingEntityEvents.ENTITY_TRAVELS_TO_DIMENSION.register((entity, origin, destination) -> {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
			"x": "entity.getX()",
			"y": "entity.getY()",
			"z": "entity.getZ()",
			"world": "destination",
			"dimension": "destination.dimension()",
			"entity": "entity",
			"origin": "origin",
			"sourceentity": "origin"
			}/>
		</#assign>
		execute(${dependenciesCode});
	});
}

public static boolean isDimension(ResourceKey<Level> dimension, ResourceKey<Level> target) {
	return dimension != null && dimension.equals(target);
}
