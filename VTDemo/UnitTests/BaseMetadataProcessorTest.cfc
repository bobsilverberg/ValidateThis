<!---
	// **************************************** LICENSE INFO **************************************** \\
	
	Copyright 2010, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent extends="UnitTests.BaseTestCase" output="false">
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			baseMetadataProcessor = CreateObject("component","ValidateThis.core.BaseMetadataProcessor").init();
			makePublic(baseMetadataProcessor,"processPropertyRules");
			injectMethod(baseMetadataProcessor, this, "getVariables", "getVariables");
		</cfscript>
		<cfsavecontent variable="jsonMetadata">
			<cfinclude template="/VTDemo/AnnotationDemo/model/json/user.json" />
		</cfsavecontent>
	</cffunction>

	<cffunction name="getVariables" access="public" output="false" returntype="any" hint="Used to retrieve the ATRs for testing.">
		<cfreturn variables />
	</cffunction>

	<cffunction name="processPropertyRulesShouldPickupTypeAttribute" access="public" returntype="void">
		<cfscript>
			properties = [{name="theName",rules=[{type="required",params=[{name="min",value=5,type="expression"},{name="max",value=10,type="value"}]}]}];
			baseMetadataProcessor.processPropertyRules(properties);
			validations = baseMetadataProcessor.getVariables().validations;
			parameters = validations.contexts.___default[1].parameters;
			assertEquals(true,isStruct(parameters.min));
			assertEquals(5,parameters.min.value);
			assertEquals("expression",parameters.min.type);
			assertEquals(10,parameters.max.value);
			assertEquals("value",parameters.max.type);
			debug(validations);
		</cfscript>  
	</cffunction>

</cfcomponent>
