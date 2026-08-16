<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2025, Pylo, opensource contributors
-->

<#-- @formatter:off -->
package ${package}.mixin;

import net.minecraft.client.renderer.entity.BoatRenderer;
import net.minecraft.world.entity.vehicle.Boat;
import net.minecraft.resources.ResourceLocation;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Unique;
import org.spongepowered.asm.mixin.Overwrite;
import com.mojang.datafixers.util.Pair;

import com.mojang.blaze3d.vertex.PoseStack;
import com.mojang.blaze3d.vertex.VertexConsumer;
import net.minecraft.client.renderer.MultiBufferSource;
import net.minecraft.client.model.BoatModel;
import net.minecraft.client.renderer.RenderType;
import net.minecraft.util.Mth;
import java.util.Map;

<#assign specialentities = w.getGElementsOfType("specialentity")?filter(e -> e.entityType == "Boat")>
@Mixin(BoatRenderer.class)
public abstract class ${JavaModName}BoatRendererMixin {

	@Unique private static final Map<String, ResourceLocation> MOD_BOAT_TEXTURES = Map.ofEntries(
		<#list specialentities as entity>
		Map.entry("${entity.getModElement().getRegistryName()}", new ResourceLocation("${modid}", "textures/entity/boat/${entity.getModElement().getRegistryName()}.png"))
		</#list>
	);

	/**
	 * @reason Custom boat texture rendering for modded boats
	 * @author MCreator Quilt Generator
	 */
	@Overwrite
	public void render(Boat boat, float entityYaw, float partialTicks, PoseStack poseStack,
					   MultiBufferSource buffer, int packedLight) {
		poseStack.pushPose();
		poseStack.translate(0.0F, 0.375F, 0.0F);
		poseStack.mulPose(com.mojang.math.Axis.YP.rotationDegrees(180.0F - entityYaw));
		float hurt = boat.getHurtTime() - partialTicks;
		if (hurt >= 0.0F) {
			float damage = boat.getDamage() - partialTicks;
			if (damage < 0.0F) {
				damage = 0.0F;
			}
			poseStack.mulPose(com.mojang.math.Axis.XP.rotationDegrees(Mth.sin(hurt) * hurt * damage / 10.0F * (float) boat.getHurtDir()));
		}
		float bubble = boat.getBubbleAngle(partialTicks);
		if (bubble != 0.0F) {
			poseStack.mulPose(com.mojang.math.Axis.XP.rotationDegrees(Mth.equal(bubble, 0.0F) ? 0.0F : Mth.sin(bubble) * bubble * 0.2F * (float) boat.getHurtDir()));
		}

		// Determine custom texture for modded boats
		ResourceLocation texture = null;
		<#list specialentities as entity>
		if (boat.getClass().getSimpleName().equals("${JavaModName}Boat")) {
			texture = MOD_BOAT_TEXTURES.get("${entity.getModElement().getRegistryName()}");
		}
		</#list>

		poseStack.scale(-1.0F, -1.0F, 1.0F);
		poseStack.mulPose(com.mojang.math.Axis.YP.rotationDegrees(90.0F));

		// Use vanilla BoatModel with custom texture
		BoatModel model = new BoatModel(BoatModel.createBodyModel().bakeRoot());

		RenderType renderType = texture != null ?
			RenderType.entityCutout(texture) :
			RenderType.entityCutout(new ResourceLocation("minecraft", "textures/entity/boat/oak.png"));

		VertexConsumer vertexConsumer = buffer.getBuffer(renderType);
		model.setupAnim(boat, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F);
		model.renderToBuffer(poseStack, vertexConsumer, packedLight, net.minecraft.client.renderer.texture.OverlayTexture.NO_OVERLAY, 1.0F, 1.0F, 1.0F, 1.0F);

		if (!boat.isUnderWater()) {
			VertexConsumer waterConsumer = buffer.getBuffer(RenderType.waterMask());
			if (model instanceof net.minecraft.client.model.WaterPatchModel) {
				net.minecraft.client.model.WaterPatchModel waterPatchModel = (net.minecraft.client.model.WaterPatchModel) model;
				waterPatchModel.waterPatch().render(poseStack, waterConsumer, packedLight, net.minecraft.client.renderer.texture.OverlayTexture.NO_OVERLAY);
			}
		}

		poseStack.popPose();
	}

}
<#-- @formatter:on -->
