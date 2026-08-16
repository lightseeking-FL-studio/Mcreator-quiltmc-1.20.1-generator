@Environment(EnvType.CLIENT)
public class @JavaModNameSounds {
	public static final SoundEvent EXAMPLE_SOUND = Registry.register(
		BuiltInRegistries.SOUND_EVENT, new ResourceLocation("@modid", "example_sound"),
		SoundEvent.createVariableRangeEvent(new ResourceLocation("@modid", "example_sound"))
	);

	public static void register() {
		// Sound events are registered via direct Registry.register
	}
}