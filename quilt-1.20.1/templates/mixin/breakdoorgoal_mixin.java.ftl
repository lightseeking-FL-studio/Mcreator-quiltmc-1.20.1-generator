<#-- @formatter:off -->
package ${package}.mixin;

import ${package}.event.LivingEntityEvents;
import net.minecraft.world.entity.LivingEntity;
import net.minecraft.world.entity.Mob;
import net.minecraft.world.entity.ai.goal.BreakDoorGoal;
import net.minecraft.world.Difficulty;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Unique;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

import java.util.function.Predicate;

@Mixin(BreakDoorGoal.class)
public class BreakDoorGoalMixin {

	@Unique
	private LivingEntity th$mob = null;

	/**
	 * @reason Capture mob reference from constructor (2-arg).
	 * @author MCreator Quilt Generator
	 */
	@Inject(method = "<init>(Lnet/minecraft/world/entity/Mob;Ljava/util/function/Predicate;)V", at = @At("TAIL"))
	private void onConstruct2(Mob mob, Predicate<Difficulty> predicate, CallbackInfo ci) {
		th$mob = mob;
	}

	/**
	 * @reason Capture mob reference from constructor (3-arg).
	 * @author MCreator Quilt Generator
	 */
	@Inject(method = "<init>(Lnet/minecraft/world/entity/Mob;ILjava/util/function/Predicate;)V", at = @At("TAIL"))
	private void onConstruct3(Mob mob, int breakTime, Predicate<Difficulty> predicate, CallbackInfo ci) {
		th$mob = mob;
	}

	/**
	 * @reason Fire LivingEntityEvents.ENTITY_GRIEF when a zombie starts breaking a door.
	 * This is the exact moment the zombie begins the door-breaking action.
	 * Forge equivalent: EntityMobGriefingEvent in BreakDoorGoal.
	 * @author MCreator Quilt Generator
	 */
	@Inject(method = "start", at = @At("HEAD"))
	private void onBreakDoorStart(CallbackInfo ci) {
		if (th$mob != null) {
			LivingEntityEvents.ENTITY_GRIEF.invoker().onEntityGrief(th$mob);
		}
	}
}
<#-- @formatter:on -->