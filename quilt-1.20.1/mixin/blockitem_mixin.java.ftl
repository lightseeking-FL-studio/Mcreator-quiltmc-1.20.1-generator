@Mixin(BlockItem.class)
public abstract class BlockItemMixin {
    @Inject(method = "place", at = @At("HEAD"), cancellable = true)
    private void onPlace(BlockPlaceContext context, CallbackInfoReturnable<InteractionResult> cir) {
        // Block place event hook
    }
}
