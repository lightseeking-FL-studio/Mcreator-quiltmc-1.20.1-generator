@Mixin(BoneMealItem.class)
public abstract class BoneMealItemMixin {
    @Inject(method = "growWaterPlant", at = @At("HEAD"), cancellable = true)
    private static void onGrowWaterPlant(Level level, BlockPos pos, Direction direction, ItemStack stack, CallbackInfoReturnable<Boolean> cir) {
        // Bone meal event hook
    }
}
