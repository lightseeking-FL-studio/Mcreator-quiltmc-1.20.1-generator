<#include "procedures.java.ftl">
public ${name}Procedure() {
	BlockEvents.CROP_ATTEMPTS_GROWTH.register((position, state, world) -> {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
				"x": "position.getX()",
				"y": "position.getY()",
				"z": "position.getZ()",
				"blockstate": "state",
				"world": "world"
			}/>
		</#assign>
		execute(${dependenciesCode});
		boolean result = eventResult;
		eventResult = true;
		return result;
	});
}
