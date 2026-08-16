public class @JavaModName implements ModInitializer {
    public static final String MOD_ID = "@modid";
    public static final Logger LOG = LoggerFactory.getLogger(MOD_ID);

    @Override
    public void onInitialize() {
        LOG.info("@modname initializing...");
        
        // Register mod elements
        @JavaModNameTabs.register();
        @JavaModNameBlocks.register();
        @JavaModNameItems.register();
        @JavaModNameEntities.register();
        @JavaModNameFeatures.register();
        
        // Register event callbacks
        ServerLivingEntityEvents.ALLOW_DAMAGE.register(@JavaModNameEvents::onLivingDamage);
        ServerPlayerEvents.PLAYER_CLONE.register(@JavaModNameEvents::onPlayerClone);
    }
}
