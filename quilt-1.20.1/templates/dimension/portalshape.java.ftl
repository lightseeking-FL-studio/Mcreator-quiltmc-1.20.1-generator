<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2023, Pylo, opensource contributors
 #
 # This program is free software: you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <https://www.gnu.org/licenses/>.
 #
 # Additional permission for code generator templates (*.ftl files)
 #
 # As a special exception, you may create a larger work that contains part or
 # all of the MCreator code generator templates (*.ftl files) and distribute
 # that work under terms of your choice, so long as that work isn't itself a
 # template for code generation. Alternatively, if you modify or redistribute
 # the template itself, you may (at your option) remove this special exception,
 # which will cause the template and the resulting code generator output files
 # to be licensed under the GNU General Public License without this special
 # exception.
-->

<#-- @formatter:off -->
<#include "../mcitems.ftl">

package ${package}.world.teleporter;

import java.util.Optional;
import java.util.function.Predicate;
import org.jetbrains.annotations.Nullable;
import net.minecraft.BlockUtil;
import net.minecraft.core.BlockPos;
import net.minecraft.core.Direction;
import net.minecraft.server.level.ServerLevel;
import net.minecraft.tags.BlockTags;
import net.minecraft.util.Mth;
import net.minecraft.world.entity.Entity;
import net.minecraft.world.entity.EntityDimensions;
import net.minecraft.world.level.BlockGetter;
import net.minecraft.world.level.LevelAccessor;
import net.minecraft.world.level.block.Blocks;
import net.minecraft.world.level.block.NetherPortalBlock;
import net.minecraft.world.level.block.state.BlockBehaviour;
import net.minecraft.world.level.block.state.BlockState;
import net.minecraft.world.level.block.state.properties.BlockStateProperties;
import net.minecraft.world.level.portal.PortalInfo;
import net.minecraft.world.phys.AABB;
import net.minecraft.world.phys.Vec3;
import net.minecraft.world.phys.shapes.Shapes;
import net.minecraft.world.phys.shapes.VoxelShape;

public class ${name}PortalShape {
    private static final int MIN_WIDTH = 2;
    public static final int MAX_WIDTH = 21;
    private static final int MIN_HEIGHT = 3;
    public static final int MAX_HEIGHT = 21;
    private static final BlockBehaviour.StatePredicate FRAME = (pState, pLevel, pPos) -> pState.is(${mappedBlockToBlock(data.portalFrame)});
    private static final float SAFE_TRAVEL_MAX_ENTITY_XY = 4.0f;
    private static final double SAFE_TRAVEL_MAX_VERTICAL_DELTA = 1.0;
    private final LevelAccessor level;
    private final Direction.Axis axis;
    private final Direction rightDir;
    private int numPortalBlocks;
    @Nullable
    private BlockPos bottomLeft;
    private int height;
    private final int width;

    public static Optional<${name}PortalShape> findEmptyPortalShape(LevelAccessor pLevel, BlockPos pPos, Direction.Axis pAxis) {
        return ${name}PortalShape.findPortalShape(pLevel, pPos, p_77727_ -> p_77727_.isValid() && p_77727_.numPortalBlocks == 0, pAxis);
    }

    public static Optional<${name}PortalShape> findPortalShape(LevelAccessor pLevel, BlockPos pPos, Predicate<${name}PortalShape> pPredicate, Direction.Axis pAxis) {
        Optional<${name}PortalShape> $$4 = Optional.of(new ${name}PortalShape(pLevel, pPos, pAxis)).filter(pPredicate);
        if ($$4.isPresent()) {
            return $$4;
        }
        Direction.Axis $$5 = pAxis == Direction.Axis.X ? Direction.Axis.Z : Direction.Axis.X;
        return Optional.of(new ${name}PortalShape(pLevel, pPos, $$5)).filter(pPredicate);
    }

    public ${name}PortalShape(LevelAccessor pLevel, BlockPos pPos, Direction.Axis pAxis) {
        this.level = pLevel;
        this.axis = pAxis;
        this.rightDir = pAxis == Direction.Axis.X ? Direction.WEST : Direction.SOUTH;
        this.bottomLeft = this.calculateBottomLeft(pPos);
        if (this.bottomLeft == null) {
            this.bottomLeft = pPos;
            this.width = 1;
            this.height = 1;
        } else {
            this.width = this.calculateWidth();
            if (this.width > 0) {
                this.height = this.calculateHeight();
            }
        }
    }

    @Nullable
    private BlockPos calculateBottomLeft(BlockPos pPos) {
        int $$1 = Math.max(this.level.getMinBuildHeight(), pPos.getY() - 21);
        while (pPos.getY() > $$1 && ${name}PortalShape.isEmpty(this.level.getBlockState(pPos.below()))) {
            pPos = pPos.below();
        }
        Direction $$2 = this.rightDir.getOpposite();
        int $$3 = this.getDistanceUntilEdgeAboveFrame(pPos, $$2) - 1;
        if ($$3 < 0) {
            return null;
        }
        return pPos.relative($$2, $$3);
    }

    private int calculateWidth() {
        int $$0 = this.getDistanceUntilEdgeAboveFrame(this.bottomLeft, this.rightDir);
        if ($$0 < 2 || $$0 > 21) {
            return 0;
        }
        return $$0;
    }

    private int getDistanceUntilEdgeAboveFrame(BlockPos pPos, Direction pDirection) {
        BlockPos.MutableBlockPos $$2 = new BlockPos.MutableBlockPos();
        for (int $$3 = 0; $$3 <= 21; ++$$3) {
            $$2.set(pPos).move(pDirection, $$3);
            BlockState $$4 = this.level.getBlockState($$2);
            if (!${name}PortalShape.isEmpty($$4)) {
                if (!FRAME.test($$4, this.level, $$2)) break;
                return $$3;
            }
            BlockState $$5 = this.level.getBlockState($$2.move(Direction.DOWN));
            if (!FRAME.test($$5, this.level, $$2)) break;
        }
        return 0;
    }

    private int calculateHeight() {
        BlockPos.MutableBlockPos $$0 = new BlockPos.MutableBlockPos();
        int $$1 = this.getDistanceUntilTop($$0);
        if ($$1 < 3 || $$1 > 21 || !this.hasTopFrame($$0, $$1)) {
            return 0;
        }
        return $$1;
    }

    private boolean hasTopFrame(BlockPos.MutableBlockPos pPos, int pDistanceToEdge) {
        for (int $$2 = 0; $$2 < this.width; ++$$2) {
            BlockPos.MutableBlockPos $$3 = pPos.set(this.bottomLeft).move(Direction.UP, pDistanceToEdge).move(this.rightDir, $$2);
            if (FRAME.test(this.level.getBlockState($$3), this.level, $$3)) continue;
            return false;
        }
        return true;
    }

    private int getDistanceUntilTop(BlockPos.MutableBlockPos pPos) {
        for (int $$1 = 0; $$1 < 21; ++$$1) {
            pPos.set(this.bottomLeft).move(Direction.UP, $$1).move(this.rightDir, -1);
            if (!FRAME.test(this.level.getBlockState(pPos), this.level, pPos)) {
                return $$1;
            }
            pPos.set(this.bottomLeft).move(Direction.UP, $$1).move(this.rightDir, this.width);
            if (!FRAME.test(this.level.getBlockState(pPos), this.level, pPos)) {
                return $$1;
            }
            for (int $$2 = 0; $$2 < this.width; ++$$2) {
                pPos.set(this.bottomLeft).move(Direction.UP, $$1).move(this.rightDir, $$2);
                BlockState $$3 = this.level.getBlockState(pPos);
                if (!${name}PortalShape.isEmpty($$3)) {
                    return $$1;
                }
                if (!$$3.is(${JavaModName}Blocks.${REGISTRYNAME}_PORTAL)) continue;
                ++this.numPortalBlocks;
            }
        }
        return 21;
    }

    private static boolean isEmpty(BlockState p_77718_) {
        return p_77718_.isAir() || p_77718_.getBlock() == ${JavaModName}Blocks.${REGISTRYNAME}_PORTAL;
    }

    public boolean isValid() {
        return this.bottomLeft != null && this.width >= 2 && this.width <= 21 && this.height >= 3 && this.height <= 21;
    }

    public void createPortalBlocks() {
        BlockState $$0 = ${JavaModName}Blocks.${REGISTRYNAME}_PORTAL.defaultBlockState().setValue(NetherPortalBlock.AXIS, this.axis);
        BlockPos.betweenClosed(this.bottomLeft, this.bottomLeft.relative(Direction.UP, this.height - 1).relative(this.rightDir, this.width - 1)).forEach(p_77725_ -> {
            this.level.setBlock(p_77725_, $$0, 18);
        });
    }

    public boolean isComplete() {
        return this.isValid() && this.numPortalBlocks == this.width * this.height;
    }

    public static Vec3 getRelativePosition(BlockUtil.FoundRectangle p_77739_, Direction.Axis p_77740_, Vec3 p_77741_, EntityDimensions p_77742_) {
        double $$4 = (double)p_77739_.axis1Size - (double)p_77742_.width;
        double $$5 = (double)p_77739_.axis2Size - (double)p_77742_.height;
        BlockPos $$6 = p_77739_.minCorner;
        double $$9;
        double $$12;
        if ($$4 > 0.0) {
            float $$7 = (float)$$6.get(p_77740_) + p_77742_.width / 2.0f;
            double $$8 = Mth.inverseLerp(Mth.clamp(p_77741_.get(p_77740_) - (double)$$7, 0.0, $$4), 0.0, 1.0);
            $$9 = $$8;
        } else {
            $$9 = 0.5;
        }
        if ($$5 > 0.0) {
            Direction.Axis $$10 = Direction.Axis.Y;
            double $$11 = Mth.inverseLerp(Mth.clamp(p_77741_.get($$10) - (double)$$6.get($$10), 0.0, $$5), 0.0, 1.0);
            $$12 = $$11;
        } else {
            $$12 = 0.0;
        }
        Direction.Axis $$13 = p_77740_ == Direction.Axis.X ? Direction.Axis.Z : Direction.Axis.X;
        double $$14 = p_77741_.get($$13) - ((double)$$6.get($$13) + 0.5);
        return new Vec3($$9, $$12, $$14);
    }

    public static PortalInfo createPortalInfo(ServerLevel p_259301_, BlockUtil.FoundRectangle p_259931_, Direction.Axis p_259901_, Vec3 p_259630_, Entity p_259166_, Vec3 p_260043_, float p_259853_, float p_259667_) {
        BlockPos $$8 = p_259931_.minCorner;
        BlockState $$9 = p_259301_.getBlockState($$8);
        Direction.Axis $$10 = $$9.getOptionalValue(BlockStateProperties.HORIZONTAL_AXIS).orElse(Direction.Axis.X);
        double $$11 = p_259931_.axis1Size;
        double $$12 = p_259931_.axis2Size;
        EntityDimensions $$13 = p_259166_.getDimensions(p_259166_.getPose());
        int $$14 = p_259901_ == $$10 ? 0 : 90;
        Vec3 $$15 = p_259901_ == $$10 ? p_260043_ : new Vec3(p_260043_.x, p_260043_.y, -p_260043_.z);
        double $$16 = (double)$$13.width / 2.0 + ($$11 - (double)$$13.width) * p_259630_.x();
        double $$17 = ($$12 - (double)$$13.height) * p_259630_.y();
        double $$18 = 0.5 + p_259630_.z();
        boolean $$19 = $$10 == Direction.Axis.X;
        Vec3 $$20 = new Vec3((double)$$8.getX() + ($$19 ? $$16 : $$18), (double)$$8.getY() + $$17, (double)$$8.getZ() + ($$19 ? $$18 : $$16));
        Vec3 $$21 = ${name}PortalShape.findCollisionFreePosition($$20, p_259301_, p_259166_, $$13);
        return new PortalInfo($$21, $$15, p_259853_ + (float)$$14, p_259667_);
    }

    private static Vec3 findCollisionFreePosition(Vec3 p_260315_, ServerLevel p_259704_, Entity p_259626_, EntityDimensions p_259816_) {
        if (p_259816_.width > 4.0f || p_259816_.height > 4.0f) {
            return p_260315_;
        }
        double $$4 = (double)p_259816_.height / 2.0;
        Vec3 $$5 = p_260315_.add(0.0, $$4, 0.0);
        VoxelShape $$6 = Shapes.create(AABB.ofSize($$5, (double)p_259816_.width, 0.0, (double)p_259816_.width).expandTowards(0.0, 1.0, 0.0).inflate(1.0E-6));
        Optional<Vec3> $$7 = p_259704_.findFreePosition(p_259626_, $$6, $$5, (double)p_259816_.width, (double)p_259816_.height, (double)p_259816_.width);
        Optional<Vec3> $$8 = $$7.map(p_259019_ -> p_259019_.subtract(0.0, $$4, 0.0));
        return $$8.orElse(p_260315_);
    }
}

<#-- @formatter:on -->
