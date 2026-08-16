<#include "mcelements.ftl">
<#-- @formatter:off -->
{
	BlockEntity _ent = world.getBlockEntity(${toBlockPos(input$x,input$y,input$z)});
	int _amount = ${opt.toInt(input$amount)};
	// Energy extraction is not available on Fabric/Quilt without a standard energy API
}
<#-- @formatter:on -->