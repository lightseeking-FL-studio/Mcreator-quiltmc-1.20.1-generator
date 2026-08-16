<#-- @formatter:off -->
<#include "../procedures.java.ftl">

<#assign itemsWithDroppedByPlayer = []>
<#list w.getGElementsOfType("item") as item>
	<#if hasProcedure(item.onDroppedByPlayer)>
	<#assign itemsWithDroppedByPlayer += [item]>
	</#if>
</#list>
<#list w.getGElementsOfType("tool") as tool>
	<#if hasProcedure(tool.onDroppedByPlayer)>
	<#assign itemsWithDroppedByPlayer += [tool]>
	</#if>
</#list>

package ${package}.mixin;

import net.minecraft.server.level.ServerPlayer;
import net.minecraft.world.entity.item.ItemEntity;
import net.minecraft.world.item.ItemStack;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

@Mixin(ServerPlayer.class)
public abstract class ServerPlayerMixin {
	@Inject(method = "drop(Lnet/minecraft/world/item/ItemStack;ZZ)Lnet/minecraft/world/entity/item/ItemEntity;", at = @At("HEAD"))
	public void onDropItem(ItemStack stack, boolean throwRandomly, boolean retainOwnership, CallbackInfoReturnable<ItemEntity> cir) {
		ServerPlayer self = (ServerPlayer) (Object) this;
		if (!stack.isEmpty()) {
		<#list itemsWithDroppedByPlayer as item>
			if (stack.getItem() instanceof ${item.getModElement().getName()}Item)
				((${item.getModElement().getName()}Item)stack.getItem()).onDroppedByPlayer(stack, self);
		</#list>
		}
	}
}
<#-- @formatter:on -->