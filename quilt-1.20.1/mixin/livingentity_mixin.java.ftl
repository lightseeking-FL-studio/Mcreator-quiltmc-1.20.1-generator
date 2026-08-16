@Mixin(LivingEntity.class)
public abstract class LivingEntityMixin {
    @Inject(method = "hurt", at = @At("HEAD"), cancellable = true)
    private void onHurt(DamageSource source, float amount, CallbackInfoReturnable<Boolean> cir) {
        // LivingEntity damage event hook
    }
}
