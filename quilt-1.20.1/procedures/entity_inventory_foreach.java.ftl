{
	if (${input$entity} instanceof Container _container) {
		for(int _idx = 0; _idx < _container.getContainerSize(); _idx++) {
			ItemStack itemstackiterator = _container.getItem(_idx).copy();
			${statement$foreach}
		}
	}
}