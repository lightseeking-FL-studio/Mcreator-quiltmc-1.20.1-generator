<#-- @formatter:off -->
package ${package}.mixin;

import ${package}.event.WorldEvents;
import net.minecraft.core.BlockPos;
import net.minecraft.server.level.ServerLevel;
import net.minecraft.world.entity.ai.village.VillageSiege;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Shadow;
import org.spongepowered.asm.mixin.Unique;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

@Mixin(VillageSiege.class)
public class VillageSiegeMixin {

	@Shadow
	private int spawnX;

	@Shadow
	private int spawnY;

	@Shadow
	private int spawnZ;

	@Unique
	private boolean th$siegeFired = false;

	/**
	 * @reason Reset the siege fired flag at the start of each setup attempt.
	 * @author MCreator Quilt Generator
	 */
	@Inject(method = "tryToSetupSiege", at = @At("HEAD"))
	private void onTryToSetupSiegeHead(ServerLevel level, CallbackInfoReturnable<Boolean> cir) {
		this.th$siegeFired = false;
	}

	/**
	 * @reason Fire WorldEvents.VILLAGE_SIEGE when a zombie siege is successfully set up.
	 * @author MCreator Quilt Generator
	 */
	@Inject(method = "tryToSetupSiege", at = @At("RETURN"))
	private void onTryToSetupSiegeReturn(ServerLevel level, CallbackInfoReturnable<Boolean> cir) {
		if (cir.getReturnValue() && !this.th$siegeFired) {
			this.th$siegeFired = true;
			WorldEvents.VILLAGE_SIEGE.invoker().onVillageSiege(
				level,
				new BlockPos(this.spawnX, this.spawnY, this.spawnZ)
			);
		}
	}
}
<#-- @formatter:on -->