@Mixin(Commands.class)
public abstract class CommandsMixin {
    @Inject(method = "performCommand", at = @At("HEAD"), cancellable = true)
    private static void onPerformCommand(CommandSourceStack source, String command, CallbackInfoReturnable<Integer> cir) {
        // Command execution event hook
    }
}
