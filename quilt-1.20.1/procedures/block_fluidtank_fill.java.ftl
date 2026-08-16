<#include "mcelements.ftl">
<#include "mcitems.ftl">
<#-- @formatter:off -->
{
	BlockEntity _ent = world.getBlockEntity(${toBlockPos(input$x,input$y,input$z)});
	int _amount = ${opt.toInt(input$amount)};
	if (_ent != null) {
		Storage<FluidVariant> _fluidStorage = FluidStorage.SIDED.find(world, ${toBlockPos(input$x,input$y,input$z)}, ${input$direction});
		if (_fluidStorage != null) {
			try (Transaction _transaction = Transaction.openOuter()) {
				_fluidStorage.insert(FluidVariant.of(${generator.map(field$fluid, "fluids")}), _amount, _transaction);
				_transaction.commit();
			}
		}
	}
}
<#-- @formatter:on -->