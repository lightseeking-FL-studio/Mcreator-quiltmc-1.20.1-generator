<#include "../mcitems.ftl">
{
  "type": "minecraft:entity",
  "pools": [
    {
      "rolls": 1,
      "entries": [
        {
          "type": "minecraft:item",
          "name": "${modid}:${registryname}_spawn_egg"
        }
      ],
      "conditions": [
        {
          "condition": "minecraft:survives_explosion"
        }
      ]
    }
  ]
}