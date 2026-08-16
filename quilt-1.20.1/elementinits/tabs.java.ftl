public class @JavaModNameTabs {
    public static final CreativeModeTab EXAMPLE_TAB = CreativeModeTab.builder()
            .title(Component.translatable("itemGroup.@modid.example_tab"))
            .icon(() -> new ItemStack(Items.DIAMOND))
            .displayItems((params, output) -> {
                // Add items to tab
            })
            .build();

    public static void register() {
        Registry.register(Registry.CREATIVE_MODE_TAB, new ResourceLocation("@modid", "example_tab"), EXAMPLE_TAB);
    }
}
