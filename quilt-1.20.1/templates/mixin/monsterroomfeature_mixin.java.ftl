<#-- @formatter:off -->
<#compress>
package ${package}.mixin;

import org.spongepowered.asm.mixin.Mutable;
import org.spongepowered.asm.mixin.Final;
import org.spongepowered.asm.mixin.Shadow;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

import net.minecraft.world.entity.EntityType;
import net.minecraft.world.level.levelgen.feature.MonsterRoomFeature;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Mixin(MonsterRoomFeature.class)
public abstract class MonsterRoomFeatureMixin {

	@Shadow @Final @Mutable
	private static EntityType<?>[] MOBS;

	@Inject(method = "<clinit>", at = @At("TAIL"))
	private static void injectCustomEntity(CallbackInfo ci) {
		List<EntityType<?>> entities = new ArrayList<>(Arrays.asList(MOBS));
		<#list w.getGElementsOfType("livingentity") as entity>
			<#if entity.spawnInDungeons>
		entities.add(${JavaModName}Entities.${entity.getModElement().getRegistryNameUpper()});
			</#if>
		</#list>
		MOBS = entities.toArray(new EntityType[0]);
	}
}
</#compress>
<#-- @formatter:on -->
