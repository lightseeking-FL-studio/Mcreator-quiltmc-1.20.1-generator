<#include "mcitems.ftl">
{
	final int _slotid = ${opt.toInt(input$slotid)};
	final ItemStack _setstack = ${mappedMCItemToItemStackCode(input$slotitem, 1)}.copy();
	_setstack.setCount(${opt.toInt(input$amount)});
	if (${input$entity} instanceof Container _container)
		_container.setItem(_slotid, _setstack);
}