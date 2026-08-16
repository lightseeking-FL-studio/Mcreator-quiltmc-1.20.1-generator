{
	"schemaVersion": 1,
	"id": "${settings.getModID()}",
	"version": "${settings.getCleanVersion()}",
	"name": "${JavaConventions.escapeStringForJava(settings.getModName())}",
	"description": "${JavaConventions.escapeStringForJava(settings.getDescription())}",
	<#if settings.getAuthor()?has_content>
	"authors": [
		"${JavaConventions.escapeStringForJava(settings.getAuthor())}"
	],
	</#if>
	"contact": {
		<#if settings.getWebsiteURL()?has_content>
		"homepage": "${JavaConventions.escapeStringForJava(settings.getWebsiteURL())}"<#if settings.getUpdateURL()?has_content>,</#if>
		</#if>
		<#if settings.getUpdateURL()?has_content>
		"issues": "${JavaConventions.escapeStringForJava(settings.getUpdateURL())}"
		</#if>
	},
	"icon": "${settings.getModPicture()?has_content?then("logo.png", "${settings.getModID()}.png")}",
	<#if settings.getLicense()?has_content>
	"license": "${JavaConventions.escapeStringForJava(settings.getLicense())}",
	</#if>
	"environment": "${settings.isServerSideOnly()?then("server", "*")}",
	"entrypoints": {
		<#if !settings.isServerSideOnly()>
		"main": [
			"${package}.${JavaModName}"
		],
		"client": [
			"${package}.${JavaModName}Client"
		]
		<#else>
		"server": [
			"${package}.${JavaModName}"
		]
		</#if>
	},
	"depends": {
		"fabricloader": ">=0.14.0",
		"minecraft": "${generator.getGeneratorMinecraftVersion()}",
		"fabric-api": "*"
		<#list settings.getRequiredMods() as e>
		,
		"${e}": "${settings.getVersionRange(e)}"
		</#list>
	}
	<#if (settings.getDependencies()?has_content) && (settings.getDependencies()?size > 0)>
	,
	"suggests": {
		<#list settings.getDependencies() as e>
		"${e}": "${settings.getVersionRange(e)}"<#sep>,</#sep>
		</#list>
	}
	</#if>
	<#if w.getGElementsOfType("biome")?filter(e -> e.spawnBiome || e.spawnInCaves || e.spawnBiomeNether)?size != 0
		|| w.hasElementsOfType("feature")>
	,
	"accessWidener": "${modid}.accesswidener"
	</#if>
	<#if w.hasElementsOfType("feature")>
	,
	"custom": {
		"fabric:load_type": "always"
	}
	</#if>
}