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

package ${package}.mixin;

import com.google.common.collect.Lists;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.item.crafting.RepairItemRecipe;
import net.minecraft.world.inventory.CraftingContainer;
import net.minecraft.core.RegistryAccess;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

import java.util.ArrayList;

@Mixin(RepairItemRecipe.class)
public abstract class RepairItemRecipeMixin {
	@Inject(method = "assemble(Lnet/minecraft/world/inventory/CraftingContainer;Lnet/minecraft/core/RegistryAccess;)Lnet/minecraft/world/item/ItemStack;", at = @At("HEAD"), cancellable = true)
	public void assemble(CraftingContainer craftingContainer, RegistryAccess registryAccess, CallbackInfoReturnable<ItemStack> cir) {
		ArrayList<ItemStack> list = Lists.newArrayList();
		for (int i = 0; i < craftingContainer.getContainerSize(); ++i) {
			ItemStack itemStack = craftingContainer.getItem(i);
			if (!itemStack.isEmpty()) {
				list.add(itemStack);
			}
		}
		if (list.isEmpty()) {
			return;
		}
		ItemStack itemStack3 = list.get(0);
		<#list items as item>
		<#if item.getModElement().getTypeString() == "item" || item.getModElement().getTypeString() == "tool">
			<#if item.stayInGridWhenCrafting!false>
				if (itemStack3.is((${JavaModName}Items.${item.getModElement().getRegistryNameUpper()}))) {
					cir.setReturnValue(ItemStack.EMPTY);
				}
			</#if>
		</#if>
		</#list>
	}
}

<#-- @formatter:on -->
