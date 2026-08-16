<#include "procedures.java.ftl">
public ${name}Procedure() {
	BlockEvents.BLOCK_BREAK.register((world, pos, state, entity) -> {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
			"x": "pos.getX()",
			"y": "pos.getY()",
			"z": "pos.getZ()",
			"px": "entity != null ? entity.getX() : pos.getX()",
			"py": "entity != null ? entity.getY() : pos.getY()",
			"pz": "entity != null ? entity.getZ() : pos.getZ()",
			"world": "world",
			"entity": "entity",
			"blockstate": "state",
			"blockentity": "world.getBlockEntity(pos)"
			}/>
		</#assign>
		execute(${dependenciesCode});
		boolean result = eventResult;
		eventResult = true;
		return result;
	});
}