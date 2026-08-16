<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2023, Pylo, opensource contributors
 # Copyright (C) 2026, htqkeku, Lightseeking(FL) Studio — Lightning strike dedup via ConcurrentHashMap<UUID> Set
 #
 # This program is free software: you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <https://www.gnu.org/licenses/>.
 #
 # Additional permission for code generator templates (*.ftl files)
 #
 # As a special exception, you may create a larger work that contains part or
 # all of the MCreator code generator templates (*.ftl files) and distribute
 # that work under terms of your choice, so long as that work isn't itself a
 # template for code generation. Alternatively, if you modify or redistribute
 # the template itself, you may (at your option) remove this special exception,
 # which will cause the template and the resulting code generator output files
 # to be licensed under the GNU General Public License without this special
 # exception.
-->

<#-- @formatter:off -->

/*
 *    MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.mixin;

import ${package}.event.LivingEntityEvents;
import net.minecraft.world.entity.Entity;
import net.minecraft.world.entity.LightningBolt;
import net.minecraft.world.entity.LivingEntity;
import net.minecraft.world.phys.AABB;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Unique;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

import java.util.Set;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

@Mixin(LightningBolt.class)
public class LightningBoltMixin {

	@Unique
	private final Set<UUID> th$recentHits = ConcurrentHashMap.newKeySet();

	@Inject(method = "tick", at = @At("TAIL"))
	private void onLightningTick(CallbackInfo ci) {
		LightningBolt self = (LightningBolt) (Object) this;
		if (self.level().isClientSide()) return;

		AABB box = new AABB(self.getX() - 3.0, self.getY() - 6.0, self.getZ() - 3.0, self.getX() + 3.0, self.getY() + 6.0, self.getZ() + 3.0);
		for (Entity entity : self.level().getEntitiesOfClass(LivingEntity.class, box)) {
			if (entity == self) continue;
			UUID uuid = entity.getUUID();
			if (!th$recentHits.add(uuid)) {
				continue;
			}
			LivingEntityEvents.ENTITY_STRUCK_BY_LIGHTNING.invoker().onStruckByLightning((LivingEntity) entity, self, self);
		}
	}
}
<#-- @formatter:on -->
