<#include "procedures.java.ftl">
public ${name}Procedure() {
	BlockEvents.EXPLOSION_OCCURS.register((world, source, position, power) -> {
		if (world != null && position != null) {
			<#assign dependenciesCode>
				<@procedureDependenciesCode dependencies, {
				"x": "position.x()",
				"y": "position.y()",
				"z": "position.z()",
				"world": "world",
				"power": "power",
				"sourceentity": "source"
				}/>
			</#assign>
			execute(${dependenciesCode});
		}
	});
}
