<#-- @formatter:off -->
package ${package}.mixin;

import ${package}.event.LivingEntityEvents;
import net.minecraft.world.entity.monster.Zombie;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Shadow;
import org.spongepowered.asm.mixin.Unique;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

@Mixin(Zombie.class)
public class ZombieMixin {

	@Shadow
	private boolean canBreakDoors;

	@Unique
	private boolean th$griefFired = false;

	@Unique
	private int th$debugCounter = 0;

	/**
	 * @reason Fire LivingEntityEvents.ENTITY_GRIEF when a zombie can break doors.
	 * Uses TAIL so the AI has already set canBreakDoors before we check.
	 * @author MCreator Quilt Generator
	 */
	@Inject(method = "tick", at = @At("TAIL"))
	private void onZombieTick(CallbackInfo ci) {
		Zombie self = (Zombie) (Object) this;
		// DEBUG: print zombie state every 100 ticks (~5 sec) for nearby zombies
		th$debugCounter++;
		if (th$debugCounter % 100 == 0) {
			System.out.println("[MCreator-ZOMBIE-DEBUG] Zombie at " + self.blockPosition()
				+ " canBreakDoors=" + canBreakDoors
				+ " publicCanBreakDoors=" + self.canBreakDoors()
				+ " target=" + self.getTarget()
				+ " level=" + self.level().getDifficulty());
		}
		if (canBreakDoors && !th$griefFired) {
			th$griefFired = true;
			System.out.println("[MCreator-ENTITY_GRIEF] Zombie grief at " + self.blockPosition() + " canBreakDoors=" + canBreakDoors);
			LivingEntityEvents.ENTITY_GRIEF.invoker().onEntityGrief(self);
		}
		if (!canBreakDoors) {
			th$griefFired = false;
		}
	}
}
<#-- @formatter:on -->