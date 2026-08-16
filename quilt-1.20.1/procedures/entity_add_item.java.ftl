<#include "mcitems.ftl">
if (${input$entity} instanceof Player _player) {
	ItemStack _setstack = ${mappedMCItemToItemStackCode(input$item, 1)}.copy();
	_setstack.setCount(${opt.toInt(input$amount)});
	// add to inventory first; anything that doesn't fit drops at player feet
	boolean _added = _player.getInventory().add(_setstack);
	if (!_added || !_setstack.isEmpty()) {
		_player.level().addFreshEntity(new net.minecraft.world.entity.item.ItemEntity(
				_player.level(),
				_player.getX(),
				_player.getY() + 0.5,
				_player.getZ(),
				_setstack.copy()));
	}
}
