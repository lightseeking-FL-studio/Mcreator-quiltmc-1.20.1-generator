<#include "procedures.java.ftl">
public ${name}Procedure() {
	BlockEvents.FARMLAND_TRAMPLE.register((world, pos, state, entity, fallDistance) -> {
		if (world != null && pos != null && state != null) {
			<#assign dependenciesCode>
				<@procedureDependenciesCode dependencies, {
				"x": "pos.getX()",
				"y": "pos.getY()",
				"z": "pos.getZ()",
				"world": "world",
				"blockstate": "state",
				"entity": "entity",
				"falldistance": "fallDistance"
				}/>
			</#assign>
			execute(${dependenciesCode});
		}
		return true;
	});
}
