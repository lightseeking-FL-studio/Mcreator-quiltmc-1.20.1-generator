<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2023, Pylo, opensource contributors
 # Copyright (C) 2026, htqkeku, Lightseeking(FL) Studio — onStarted dual path; isInstant skips applyEffectTick
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
<#include "mcitems.ftl">
<#include "procedures.java.ftl">

/*
 *    MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.potion;
import net.fabricmc.api.EnvType;
import net.fabricmc.api.Environment;
import net.minecraft.core.registries.BuiltInRegistries;

<@javacompress>
public class ${name}MobEffect extends MobEffect {

	public ${name}MobEffect() {
		super(MobEffectCategory.${data.mobEffectCategory}, ${data.color.getRGB()});
		<#list data.modifiers as modifier>
		<#if modifier.attribute?? && modifier.attribute?contains("STEP_HEIGHT")>
		this.addAttributeModifier(${JavaModName}Attributes.STEP_HEIGHT, "${w.getUUID(registryname + "_" + modifier?index)}", ${modifier.amount},
				AttributeModifier.Operation.${getAttributeOperation(modifier.operation)});
		<#elseif modifier.attribute?? && modifier.attribute?contains("SWIM_SPEED")>
		this.addAttributeModifier(${JavaModName}Attributes.SWIM_SPEED, "${w.getUUID(registryname + "_" + modifier?index)}", ${modifier.amount},
				AttributeModifier.Operation.${getAttributeOperation(modifier.operation)});
		<#elseif modifier.attribute?? && modifier.attribute?contains("NAMETAG_RENDER_DISTANCE")>
		this.addAttributeModifier(${JavaModName}Attributes.NAMETAG_RENDER_DISTANCE, "${w.getUUID(registryname + "_" + modifier?index)}", ${modifier.amount},
				AttributeModifier.Operation.${getAttributeOperation(modifier.operation)});
		<#elseif modifier.attribute?? && modifier.attribute?contains("ENTITY_GRAVITY")>
		this.addAttributeModifier(${JavaModName}Attributes.ENTITY_GRAVITY, "${w.getUUID(registryname + "_" + modifier?index)}", ${modifier.amount},
				AttributeModifier.Operation.${getAttributeOperation(modifier.operation)});
		<#elseif modifier.attribute?? && modifier.attribute?contains("BLOCK_REACH")>
		this.addAttributeModifier(${JavaModName}Attributes.BLOCK_REACH, "${w.getUUID(registryname + "_" + modifier?index)}", ${modifier.amount},
				AttributeModifier.Operation.${getAttributeOperation(modifier.operation)});
		<#elseif modifier.attribute?? && modifier.attribute?contains("ENTITY_REACH")>
		this.addAttributeModifier(${JavaModName}Attributes.ENTITY_REACH, "${w.getUUID(registryname + "_" + modifier?index)}", ${modifier.amount},
				AttributeModifier.Operation.${getAttributeOperation(modifier.operation)});
		<#else>
		this.addAttributeModifier(Attributes.MAX_HEALTH, "${w.getUUID(registryname + "_" + modifier?index)}", ${modifier.amount},
				AttributeModifier.Operation.${getAttributeOperation(modifier.operation)});
		</#if>
		</#list>
	}

	<#if data.isInstant>
	@Override public boolean isInstantenous() {
		return true;
	}
	</#if>

	<#if data.isCuredbyHoney>
	// Note: getCurativeItems is not available in 1.20.1 - honey cure is not supported
	</#if>



	<#if hasProcedure(data.onStarted) || (data.onAddedSound?has_content && data.onAddedSound.getMappedValue()?has_content)>
	@Override public void addAttributeModifiers(LivingEntity entity, AttributeMap attributeMap, int amplifier) {
		super.addAttributeModifiers(entity, attributeMap, amplifier);
		if (entity.level().isClientSide() == false) {
			<@startedContext/>
		}
	}
	</#if>

	<#if (hasProcedure(data.onStarted) || (data.onAddedSound?has_content && data.onAddedSound.getMappedValue()?has_content)) && data.isInstant>
	@Override public void applyInstantenousEffect(Entity source, Entity indirectSource, LivingEntity entity, int amplifier, double health) {
		if (entity.level().isClientSide() == false) {
			<@startedContext/>
		}
	}
	</#if>

	<#if hasProcedure(data.onActiveTick) && !data.isInstant>
	@Override public void applyEffectTick(LivingEntity entity, int amplifier) {
		<@procedureCode data.onActiveTick, {
			"x": "entity.getX()",
			"y": "entity.getY()",
			"z": "entity.getZ()",
			"world": "entity.level()",
			"entity": "entity",
			"amplifier": "amplifier"
		}/>
	}
	</#if>



	<#if hasProcedure(data.onExpired)>
		@Override public void removeAttributeModifiers(LivingEntity entity, AttributeMap attributeMap, int amplifier) {
			super.removeAttributeModifiers(entity, attributeMap, amplifier);
			<@procedureCode data.onExpired, {
				"x": "entity.getX()",
				"y": "entity.getY()",
				"z": "entity.getZ()",
				"world": "entity.level()",
				"entity": "entity",
				"amplifier": "amplifier"
			}/>
		}
	</#if>

	@Override public boolean isDurationEffectTick(int duration, int amplifier) {
		<#if hasProcedure(data.activeTickCondition)>
			return <@procedureOBJToConditionCode data.activeTickCondition/>;
		<#else>
			return true;
		</#if>
	}

	
}
</@javacompress>
<#-- @formatter:on -->

<#function getAttributeOperation operation>
	<#if operation == "ADD_VALUE">
		<#return "ADDITION">
	<#elseif operation == "ADD_MULTIPLIED_BASE">
		<#return "MULTIPLY_BASE">
	<#else>
		<#return "MULTIPLY_TOTAL">
	</#if>
</#function>

<#macro startedContext>
<#if data.onAddedSound?has_content && data.onAddedSound.getMappedValue()?has_content>
    entity.level().playSound(null, entity.getX(), entity.getY(), entity.getZ(), BuiltInRegistries.SOUND_EVENT.get(new ResourceLocation("${data.onAddedSound}")), entity.getSoundSource(), 1.0F, 1.0F);
</#if>
<#if hasProcedure(data.onStarted)>
    <@procedureCode data.onStarted, {
        "x": "entity.getX()",
        "y": "entity.getY()",
        "z": "entity.getZ()",
        "world": "entity.level()",
        "entity": "entity",
        "amplifier": "amplifier"
    }/>
</#if>
</#macro>