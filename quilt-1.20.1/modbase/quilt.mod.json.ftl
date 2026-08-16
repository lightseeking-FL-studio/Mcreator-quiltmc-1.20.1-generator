{
	"schema_version": 1,
	"quilt_loader": {
		"group": "${settings.getMavenGroup()}",
		"id": "${settings.getModID()}",
		"version": "${settings.getCleanVersion()}",
		"metadata": {
			"name": "${JavaConventions.escapeStringForJava(settings.getModName())}",
			"description": "${JavaConventions.escapeStringForJava(settings.getDescription())}",
			"contributors": {
				<#if settings.getAuthor()?has_content>"${JavaConventions.escapeStringForJava(settings.getAuthor())}": {}</#if>
			},
			"contact": {
				<#if settings.getWebsiteURL()?has_content>"homepage": "${JavaConventions.escapeStringForJava(settings.getWebsiteURL())}",</#if>
				<#if settings.getUpdateURL()?has_content>"issues": "${JavaConventions.escapeStringForJava(settings.getUpdateURL())}"</#if>
			},
			"icon": "${settings.getModPicture()?has_content?then("logo.png", "${settings.getModID()}.png")}"
		},
		"intermediate_mappings": "net.fabricmc:intermediary",
		"load_type": "${settings.isServerSideOnly()?then("if_possible", "always")}",
		<#if settings.getLicense()?has_content>
		"license": "${JavaConventions.escapeStringForJava(settings.getLicense())}",
		</#if>
		"depends": [
			{
				"id": "quilt_loader",
				"versions": ">=0.17.0"
			},
			{
				"id": "minecraft",
				"versions": "${generator.getGeneratorMinecraftVersion()}"
			},
			{
				"id": "fabric-api",
				"versions": "*"
			}
			<#list settings.getRequiredMods() as e>
			,
			{
				"id": "${e}",
				"versions": "${settings.getVersionRange(e)}"
			}
			</#list>
		],
		"provides": [
			{
				"id": "${settings.getModID()}",
				"version": "${settings.getCleanVersion()}"
			}
		]
		<#if (settings.getDependencies()?has_content) && (settings.getDependencies()?size > 0)>
		,
		"suggests": [
			<#list settings.getDependencies() as e>
			{
				"id": "${e}",
				"versions": "${settings.getVersionRange(e)}"
			}<#sep>,</#sep>
			</#list>
		]
		</#if>
		<#if !settings.isServerSideOnly()>
		,
		"entrypoints": {
			"init": [
				"${package}.${JavaModName}"
			],
			"client_init": [
				"${package}.${JavaModNameClient}"
			]
		}
		<#else>
		,
		"entrypoints": {
			"server_init": [
				"${package}.${JavaModName}"
			]
		}
		</#if>
	},
	"minecraft": {
		"environment": "${settings.isServerSideOnly()?then("server", "*")}"
		<#if w.getGElementsOfType("biome")?filter(e -> e.spawnBiome || e.spawnInCaves || e.spawnBiomeNether)?size != 0
			|| w.hasElementsOfType("feature")>
		,
		"access_widener": "${modid}.accesswidener"
		</#if>
	}
	<#if w.hasElementsOfType("feature")>
	,
	"fabric": {
		"load_type": "always"
	}
	</#if>
}