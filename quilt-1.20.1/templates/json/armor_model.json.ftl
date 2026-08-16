<#-- Pick the correct texture for this armor piece -->
<#assign textureName = data.armorTextureFile!"netherite">
{
  "parent": "item/generated",
  "textures": {
    "layer0": "${modid}:item/${textureName}"
  }
}