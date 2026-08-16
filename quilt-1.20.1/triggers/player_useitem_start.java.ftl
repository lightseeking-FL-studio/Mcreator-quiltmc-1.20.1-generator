<#include "procedures.java.ftl">
public ${name}Procedure() {
	UseItemCallback.EVENT.register((player, level, hand) -> {
		if (level.isClientSide())
			return new InteractionResultHolder<>(InteractionResult.PASS, player.getItemInHand(hand));
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
			"x": "player.getX()",
			"y": "player.getY()",
			"z": "player.getZ()",
			"world": "level",
			"entity": "player",
			"itemstack": "player.getItemInHand(hand)"
			}/>
		</#assign>
		execute(${dependenciesCode});
		return new InteractionResultHolder<>(InteractionResult.PASS, player.getItemInHand(hand));
	});
}
