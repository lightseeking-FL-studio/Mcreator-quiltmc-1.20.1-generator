<#include "mcelements.ftl">
<#-- @formatter:off -->
{
	BlockEntity _ent = world.getBlockEntity(${toBlockPos(input$x,input$y,input$z)});
	if (_ent != null) {
		final int _slotid = ${opt.toInt(input$slotid)};
		if (_ent instanceof Container _container)
			_container.setItem(_slotid, ItemStack.EMPTY);
	}
}
<#-- @formatter:on -->