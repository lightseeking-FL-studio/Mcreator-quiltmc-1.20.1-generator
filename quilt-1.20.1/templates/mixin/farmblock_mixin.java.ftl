<#-- @formatter:off -->
package ${package}.mixin;

import ${package}.event.BlockEvents;
import ${package}.event.LivingEntityEvents;
import net.minecraft.core.BlockPos;
import net.minecraft.world.entity.Entity;
import net.minecraft.world.entity.LivingEntity;
import net.minecraft.world.entity.monster.Ravager;
import net.minecraft.world.level.Level;
import net.minecraft.world.level.block.FarmBlock;
import net.minecraft.world.level.block.state.BlockState;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

@Mixin(FarmBlock.class)
public class FarmBlockMixin {

	@Inject(method = "fallOn", at = @At("TAIL"))
	private void onFallOn(Level level, BlockState state, BlockPos pos, Entity entity, float fallDistance, CallbackInfo ci) {
		if (!level.isClientSide() && !(level.getBlockState(pos).getBlock() instanceof FarmBlock)) {
			BlockEvents.FARMLAND_TRAMPLE.invoker().onFarmlandTrample(level, pos, state, entity, fallDistance);
		}
		if (!level.isClientSide() && entity instanceof Ravager) {
			LivingEntityEvents.ENTITY_GRIEF.invoker().onEntityGrief((LivingEntity) entity);
		}
	}
}
<#-- @formatter:on -->