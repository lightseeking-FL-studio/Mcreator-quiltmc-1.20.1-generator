@Mixin(ExperienceOrb.class)
public abstract class ExperienceOrbMixin {
    @Inject(method = "tick", at = @At("HEAD"))
    private void onTick(CallbackInfo ci) {
        // Experience orb tick event hook
    }
}
