<#include "procedures.java.ftl">
public ${name}Procedure() {
	WorldEvents.VILLAGE_SIEGE.register((world, pos) -> {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
			"x": "pos.getX()",
			"y": "pos.getY()",
			"z": "pos.getZ()",
			"world": "world"
			}/>
		</#assign>
		execute(${dependenciesCode});
	});
}