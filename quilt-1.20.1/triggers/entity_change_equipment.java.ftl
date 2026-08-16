<#include "procedures.java.ftl">
public ${name}Procedure() {
	ServerEntityEvents.EQUIPMENT_CHANGE.register((entity, slot, oldItem, newItem) -> {
		if (entity != null) {
			<#assign dependenciesCode>
				<@procedureDependenciesCode dependencies, {
				"x": "entity.getX()",
				"y": "entity.getY()",
				"z": "entity.getZ()",
				"world": "entity.level()",
				"entity": "entity",
				"slot": "slot",
				"olditem": "oldItem",
				"newitem": "newItem"
				}/>
			</#assign>
			execute(${dependenciesCode});
		}
	});
}