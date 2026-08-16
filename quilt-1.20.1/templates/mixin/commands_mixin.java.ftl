<#-- @formatter:off -->
package ${package}.mixin;

import ${package}.event.MiscEvents;
import net.minecraft.commands.Commands;
import com.mojang.brigadier.ParseResults;
import net.minecraft.commands.CommandSourceStack;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

@Mixin(Commands.class)
public abstract class CommandsMixin {

	/**
	 * @reason Fire MiscEvents.COMMAND_EXECUTE event when a command is performed
	 * @author MCreator Quilt Generator
	 */
	@Inject(method = "performCommand(Lcom/mojang/brigadier/ParseResults;Ljava/lang/String;)I",
			at = @At("HEAD"), cancellable = true)
	public void performCommand(ParseResults<CommandSourceStack> parseResults, String string, CallbackInfoReturnable<Integer> cir) {
		boolean result = MiscEvents.COMMAND_EXECUTE.invoker().onCommandExecuted(parseResults);
		if (!result) {
			cir.setReturnValue(0);
		}
	}
}
<#-- @formatter:on -->
