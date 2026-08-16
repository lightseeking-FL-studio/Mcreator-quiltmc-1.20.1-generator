{
    "schema_version": 1,
    "quilt_loader": {
        "group": "${package}",
        "id": "${settings.getModID()}",
        "version": "${settings.getCleanVersion()}",
        "intermediate_mappings": "net.fabricmc:intermediary",
        "load_type": "always",
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
                "id": "quilted_fabric_api",
                "versions": "*"
            }
        ],
        "entrypoints": {
            "init": [
                "${package}.${JavaModName}"
            ],
            "client_init": [
                "${package}.${JavaModName}Client"
            ]
        }
    },
    "minecraft": {
        "environment": "*"
    },
    "mixin": "${modid}.mixins.json"
}
