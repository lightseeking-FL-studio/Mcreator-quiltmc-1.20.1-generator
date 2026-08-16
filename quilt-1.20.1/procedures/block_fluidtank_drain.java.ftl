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
				for (StorageView<FluidVariant> _view : _fluidStorage.nonEmptyViews()) {
					_fluidStorage.extract(_view.getResource(), _amount, _transaction);
					break;
				}
				_transaction.commit();
			}
		}
	}
}
<#-- @formatter:on -->