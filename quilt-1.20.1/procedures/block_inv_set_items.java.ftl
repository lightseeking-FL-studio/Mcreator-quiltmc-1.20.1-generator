<#include "mcelements.ftl">
<#include "mcitems.ftl">
<#-- @formatter:off -->
{
	BlockEntity _ent = world.getBlockEntity(${toBlockPos(input$x,input$y,input$z)});
	if (_ent != null) {
		final int _slotid = ${opt.toInt(input$slotid)};
		final ItemStack _setstack = ${mappedMCItemToItemStackCode(input$item, 1)}.copy();
		_setstack.setCount(${opt.toInt(input$amount)});
		if (_ent instanceof Container _container)
			_container.setItem(_slotid, _setstack);
	}
}
<#-- @formatter:on -->