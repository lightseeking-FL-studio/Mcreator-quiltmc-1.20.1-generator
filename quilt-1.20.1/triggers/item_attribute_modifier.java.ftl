<#include "procedures.java.ftl">
public ${name}Procedure() {
	ItemEvents.ITEM_ATTRIBUTE_MODIFIER.register((itemstack) -> {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
			"itemstack": "itemstack"
			}/>
		</#assign>
		execute(${dependenciesCode});
	});
}