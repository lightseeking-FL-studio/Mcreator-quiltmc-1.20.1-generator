<#include "procedures.java.ftl">
public ${name}Procedure() {
	net.fabricmc.fabric.api.client.event.lifecycle.v1.ClientLifecycleEvents.CLIENT_STARTED.register((client) -> {
		execute();
	});
}