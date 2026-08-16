<#include "procedures.java.ftl">
public ${name}Procedure() {
	UseBlockCallback.EVENT.register((player, level, hand, hitResult) -> {
		if (level.isClientSide())
			return InteractionResult.PASS;
		var stack = player.getItemInHand(hand);
		if (stack.isEmpty() || !stack.is(net.minecraft.tags.ItemTags.HOES))
			return InteractionResult.PASS;
		var pos = hitResult.getBlockPos();
		var state = level.getBlockState(pos);
		boolean isDirt = state.is(net.minecraft.tags.BlockTags.DIRT);
		boolean isGrassBlock = state.is(net.minecraft.world.level.block.Blocks.GRASS_BLOCK);
		if (!isDirt && !isGrassBlock)
			return InteractionResult.PASS;
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
			"x": "pos.getX()",
			"y": "pos.getY()",
			"z": "pos.getZ()",
			"world": "level",
			"entity": "player",
			"direction": "hitResult.getDirection()",
			"blockstate": "state"
			}/>
		</#assign>
		execute(${dependenciesCode});
		boolean result = eventResult;
		eventResult = true;
		return result ? InteractionResult.PASS : InteractionResult.FAIL;
	});
}