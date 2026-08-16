<#include "procedures.java.ftl">
public ${name}Procedure() {
	MiscEvents.COMMAND_EXECUTE.register((results) -> {
		net.minecraft.commands.CommandSourceStack source = results.getContext().getSource();
		Entity entity = source.getEntity();
		if (entity != null) {
			<#assign dependenciesCode>
				<@procedureDependenciesCode dependencies, {
					"x": "entity.getX()",
					"y": "entity.getY()",
					"z": "entity.getZ()",
					"world": "entity.level()",
					"entity": "entity",
					"command": "results.getReader().getString()",
					"arguments": "source"
				}/>
			</#assign>
			execute(${dependenciesCode});
		}
		boolean result = eventResult;
		eventResult = true;
		return result;
	});
}
