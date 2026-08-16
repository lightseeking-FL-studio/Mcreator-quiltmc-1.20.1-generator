<#-- @formatter:off -->
package ${package}.event;

import net.fabricmc.fabric.api.event.Event;
import net.fabricmc.fabric.api.event.EventFactory;
import net.minecraft.core.BlockPos;
import net.minecraft.world.level.LevelAccessor;

public class WorldEvents {

	public static final Event<VillageSiege> VILLAGE_SIEGE = EventFactory.createArrayBacked(VillageSiege.class, (callbacks) -> (world, pos) -> {
		for (VillageSiege event : callbacks) {
			event.onVillageSiege(world, pos);
		}
	});

	@FunctionalInterface
	public interface VillageSiege {
		void onVillageSiege(LevelAccessor world, BlockPos pos);
	}
}
<#-- @formatter:on -->