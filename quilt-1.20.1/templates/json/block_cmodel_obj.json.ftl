{
  "parent": "minecraft:block/cube_all",
  "textures": {
    "all": "${data.texture.format("%s:block/%s")}",
    "particle": "${(parent???then(data.getParticleTexture(parent.getParticleTexture()), data.getParticleTexture())).format("%s:block/%s")}"
  }
}