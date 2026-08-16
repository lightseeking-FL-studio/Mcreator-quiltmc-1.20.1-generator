<#include "procedures.java.ftl">
public ${name}Procedure() {
	UseItemCallback.EVENT.register((player, level, hand) -> {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
			"x": "player.getX()",
			"y": "player.getY()",
			"z": "player.getZ()",
			"world": "level",
			"entity": "player"
			}/>
		</#assign>
		if (hand == player.getUsedItemHand())
			execute(${dependenciesCode});
		boolean result = eventResult;
		eventResult = true;
		return new InteractionResultHolder<>(result ? InteractionResult.PASS : InteractionResult.FAIL, player.getItemInHand(hand));
	});
}