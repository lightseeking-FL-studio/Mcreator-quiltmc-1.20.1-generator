<#include "mcitems.ftl">
{
	ItemStack _isc = ${mappedMCItemToItemStackCode(input$item, 1)};
	final ItemStack _setstack = ${mappedMCItemToItemStackCode(input$slotitem, 1)}.copy();
	final int _sltid = ${opt.toInt(input$slotid)};
	_setstack.setCount(${opt.toInt(input$amount)});
	if (_isc.getItem() instanceof Container _container)
		_container.setItem(_sltid, _setstack);
}