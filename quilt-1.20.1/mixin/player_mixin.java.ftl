@Mixin(Player.class)
public abstract class PlayerMixin {
    @Inject(method = "clone", at = @At("RETURN"))
    private void onCloned(ServerPlayer original, boolean alive, CallbackInfoReturnable<ServerPlayer> cir) {
        // Player clone event hook
    }
}
