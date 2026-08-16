<#include "procedures.java.ftl">
public ${name}Procedure() {
	BlockEvents.BLOCK_GROWS_FEATURE.register((world, pos, state) -> {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
				"x": "pos.getX()",
				"y": "pos.getY()",
				"z": "pos.getZ()",
				"blockstate": "state",
				"world": "world"
			}/>
		</#assign>
		execute(${dependenciesCode});
	});
}