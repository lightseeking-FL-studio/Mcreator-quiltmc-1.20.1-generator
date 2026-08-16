@Mixin(ItemStack.class)
public abstract class ItemStackMixin {
    @Inject(method = "hurt", at = @At("HEAD"), cancellable = true)
    private void onHurt(int amount, RandomSource random, ServerPlayer player, CallbackInfoReturnable<Boolean> cir) {
        // Item damage event hook
    }
}
