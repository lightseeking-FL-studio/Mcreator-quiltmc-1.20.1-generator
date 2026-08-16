<#include "procedures.java.ftl">
public ${name}Procedure() {
	ItemEvents.ITEM_CRAFTED.register((entity, itemstack) -> {
		if (entity != null) {
			<#assign dependenciesCode>
				<@procedureDependenciesCode dependencies, {
				"x": "entity.getX()",
				"y": "entity.getY()",
				"z": "entity.getZ()",
				"world": "entity.level()",
				"entity": "entity",
				"itemstack": "itemstack"
				}/>
			</#assign>
			execute(${dependenciesCode});
		}
	});
}