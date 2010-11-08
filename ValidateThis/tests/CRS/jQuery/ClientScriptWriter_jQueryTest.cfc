<!---
	// **************************************** LICENSE INFO **************************************** \\
	
	Copyright 2008, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
--->
<cfcomponent extends="validatethis.tests.BaseTestCase" output="false">
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			ValidateThisConfig = getVTConfig();
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			ScriptWriter = validationFactory.getBean("ClientValidator").getScriptWriter("jQuery");
			validation = validationFactory.getBean("Validation");
			createValStruct();
		</cfscript>
	</cffunction>
	
	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>

	<cffunction name="createValStruct" access="private" returntype="void">
		<cfscript>
			valStruct = StructNew();
			valStruct.ValType = "";
			valStruct.ClientFieldName = "FirstName";
			valStruct.PropertyName = "FirstName";
			valStruct.PropertyDesc = "First Name";
			valStruct.Parameters = StructNew(); 
			valStruct.Condition = StructNew(); 
			valStruct.formName = "frmMain"; 
		</cfscript>  
	</cffunction>
	
	<cffunction name="generateScriptHeaderShouldReturnCorrectScript" access="public" returntype="void">
		<cfscript>
			script = ScriptWriter.generateScriptHeader("formName");
			assertTrue(Trim(Script) CONTAINS "jQuery(document).ready(function() {");
			assertTrue(Trim(Script) CONTAINS "$form_formName = jQuery(""##formName"");");
			assertTrue(Trim(Script) CONTAINS "$form_formName.validate()");
		</cfscript>  
	</cffunction>

	<cffunction name="generateScriptHeaderShouldReturnSafeJSForUnsafeFormName" access="public" returntype="void">
		<cfscript>
			script = ScriptWriter.generateScriptHeader("form-Name2");
			assertTrue(Trim(Script) CONTAINS "jQuery(document).ready(function() {");
			assertTrue(Trim(Script) CONTAINS "$form_formName2 = jQuery(""##form-Name2"");");
			assertTrue(Trim(Script) CONTAINS "$form_formName2.validate()");
		</cfscript>  
	</cffunction>

	<cffunction name="generateScriptFooterShouldReturnCorrectScript" access="public" returntype="void">
		<cfscript>
			script = ScriptWriter.generateScriptFooter();
			assertEquals(Trim(Script),"});</script>");
		</cfscript>  
	</cffunction>

	<cffunction name="CustomValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "custom";
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { }",script);
			valStruct.Parameters.remoteURL = {value="aURL",type="value"}; 
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules(""add"",{""remote"":""aURL"",messages:{""remote"":""the first name custom validation failed.""}});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="CustomValidationGeneratesCorrectScriptWithProblematicFormName" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "custom";
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frm-Main2");
			assertEquals("if ($form_frmMain2.find("":input[name='firstname']"").length) { }",script);
			valStruct.Parameters.remoteURL = {value="aURL",type="value"}; 
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frm-Main2");
			assertEquals("if ($form_frmMain2.find("":input[name='firstname']"").length) { $form_frmMain2.find("":input[name='firstname']"").rules(""add"",{""remote"":""aURL"",messages:{""remote"":""the first name custom validation failed.""}});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="DateValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "date";
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules('add',{date: true});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="DateValidationGeneratesCorrectScriptWithProblematicFormName" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "date";
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frm-Main2");
			assertEquals("if ($form_frmMain2.find("":input[name='firstname']"").length) { $form_frmMain2.find("":input[name='firstname']"").rules('add',{date: true});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="EmailValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "email";
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules('add',{email: true});}",Script);
		</cfscript>  
	</cffunction>

	<cffunction name="IntegerValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "integer";
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules('add',{digits: true});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="NumericValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "numeric";
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules('add',{number: true});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="RegexValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "regex";
			valStruct.Parameters.Regex = {value="^(Dr|Prof|Mr|Mrs|Ms|Miss)(\.)?$",type="value"};
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertTrue(Script eq "if ($form_frmMain.find("":input[name='FirstName']"").length) { $form_frmMain.find("":input[name='FirstName']"").rules(""add"",{regex:/^(Dr|Prof|Mr|Mrs|Ms|Miss)(\.)?$/,messages:{regex:""The First Name does not match the specified pattern.""}});}");
		</cfscript>  
	</cffunction>
	
	<cffunction name="RegexValidationWithOverriddenPrefixGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "regex";
			valStruct.Parameters.Regex = {value="^(Dr|Prof|Mr|Mrs|Ms|Miss)(\.)?$",type="value"};
			ValidateThisConfig.defaultFailureMessagePrefix = "";
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			ScriptWriter = validationFactory.getBean("ClientValidator").getScriptWriter("jQuery");
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
            assertTrue(Script eq "if ($form_frmMain.find("":input[name='FirstName']"").length) { $form_frmMain.find("":input[name='FirstName']"").rules(""add"",{regex:/^(Dr|Prof|Mr|Mrs|Ms|Miss)(\.)?$/,messages:{regex:""First Name does not match the specified pattern.""}});}");		</cfscript>  
	</cffunction>
	
	<cffunction name="SimpleRequiredValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "required";
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules(""add"", { required : true, messages: {required: ""the first name is required.""} });}",script);
			
		</cfscript>  
	</cffunction>

	<cffunction name="DependentPropertyRequiredValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "required";
			valStruct.Parameters.DependentPropertyName = {value="LastName",type="value"};
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules(""add"", { required : function(element) { return $("":input[name='lastname']"").getvalue().length > 0; }, messages: {required: ""the first name is required if you specify a value for the lastname.""} });}",script);

		</cfscript>  
	</cffunction>
	
	<cffunction name="DependentPropertyRequiredValidationGeneratesCorrectScriptWithProblematicFormName" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "required";
			valStruct.Parameters.DependentPropertyName = {value="LastName",type="value"};
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frm-Main2");
			
			assertEquals("if ($form_frmmain2.find("":input[name='firstname']"").length) { $form_frmmain2.find("":input[name='firstname']"").rules(""add"", { required : function(element) { return $("":input[name='lastname']"").getvalue().length > 0; }, messages: {required: ""the first name is required if you specify a value for the lastname.""} });}",script);

		</cfscript>  
	</cffunction>
	
	<cffunction name="DependentValueRequiredValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "required";
			valStruct.Parameters.DependentPropertyName = {value="LastName",type="value"};
			valStruct.Parameters.DependentPropertyValue = {value="Silverberg",type="value"};
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules(""add"", { required : function(element) { return $("":input[name='lastname']"").getvalue() == 'silverberg'; }, messages: {required: ""the first name is required based on what you entered for the lastname.""} });}",script);

		</cfscript>  
	</cffunction>
	
	<cffunction name="DependentValueRequiredValidationGeneratesCorrectScriptWithProblematicFormName" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "required";
			valStruct.Parameters.DependentPropertyName = {value="LastName",type="value"};
			valStruct.Parameters.DependentPropertyValue = {value="Silverberg",type="value"};
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frm-Main2");

			assertEquals("if ($form_frmmain2.find("":input[name='firstname']"").length) { $form_frmmain2.find("":input[name='firstname']"").rules(""add"", { required : function(element) { return $("":input[name='lastname']"").getvalue() == 'silverberg'; }, messages: {required: ""the first name is required based on what you entered for the lastname.""} });}",script);

		</cfscript>  
	</cffunction>
	
	<cffunction name="DependentFieldRequiredValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "required";
			valStruct.Parameters.DependentPropertyName = {value="LastName",type="value"};
			valStruct.Parameters.DependentFieldName = {value="User[LastName]",type="value"};
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules(""add"", { required : function(element) { return $("":input[name='user[lastname]']"").getvalue().length > 0; }, messages: {required: ""the first name is required if you specify a value for the lastname.""} });}",script);
			
		</cfscript>  
	</cffunction>
	
	<cffunction name="DependentFieldRequiredValidationGeneratesCorrectScriptWithProblematicFormName" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "required";
			valStruct.Parameters.DependentPropertyName = {value="LastName",type="value"};
			valStruct.Parameters.DependentFieldName = {value="User[LastName]",type="value"};
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frm-Main2");
			
			assertEquals("if ($form_frmmain2.find("":input[name='firstname']"").length) { $form_frmmain2.find("":input[name='firstname']"").rules(""add"", { required : function(element) { return $("":input[name='user[lastname]']"").getvalue().length > 0; }, messages: {required: ""the first name is required if you specify a value for the lastname.""} });}",script);
			
		</cfscript>  
	</cffunction>
	
	<cffunction name="MinLengthValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			theLength = 5;
			valStruct.ValType = "minlength";
			valStruct.Parameters.minlength = {value=theLength,type="value"};
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules('add',{minlength: 5});}",script);
			
		</cfscript>  
	</cffunction>

	<cffunction name="MaxLengthValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			theLength = 5;
			valStruct.ValType = "maxlength";
			valStruct.Parameters.maxlength = {value=theLength,type="value"};
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules('add',{maxlength: 5});}",script);
			
		</cfscript>  
	</cffunction>

	<cffunction name="RangeLengthValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			minLength = 5;
			maxLength = 10;
			valStruct.ValType = "rangelength";
			valStruct.Parameters.minLength = {value=minLength,type="value"};
			valStruct.Parameters.maxlength = {value=maxlength,type="value"};
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules('add',{rangelength: [5,10]});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="MinValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			theVal = 5;
			valStruct.ValType = "min";
			valStruct.Parameters.min = {value=theVal,type="value"};
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules('add',{min: 5});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="MaxValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			theVal = 5;
			valStruct.ValType = "max";
			valStruct.Parameters.max = {value=theVal,type="value"};
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules('add',{max: 5});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="RangeValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			min = 5;
			max = 10;
			valStruct.ValType = "range";
			valStruct.Parameters.min = {value=min,type="value"};
			valStruct.Parameters.max = {value=max,type="value"};
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules('add',{range: [5,10]});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="EqualToValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			ComparePropertyName = "LastName";
			ComparePropertyDesc = "Last Name";
			valStruct.ValType = "EqualTo";
			valStruct.Parameters.ComparePropertyName = {value=ComparePropertyName,type="value"};
			valStruct.Parameters.ComparePropertyDesc = {value=ComparePropertyDesc,type="value"};
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertTrue(Script contains "$form_frmMain.find("":input[name='FirstName']"").rules(""add"",{equalto:"":input[name='LastName']"",messages:{equalto:'The First Name must be the same as the Last Name.'}});");
		</cfscript>
	</cffunction>

	<cffunction name="EqualToValidationGeneratesCorrectScriptWithProblematicFormName" access="public" returntype="void">
		<cfscript>
			ComparePropertyName = "LastName";
			ComparePropertyDesc = "Last Name";
			valStruct.ValType = "EqualTo";
			valStruct.Parameters.ComparePropertyName = {value=ComparePropertyName,type="value"};
			valStruct.Parameters.ComparePropertyDesc = {value=ComparePropertyDesc,type="value"};
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frm-Main2");
			assertTrue(Script contains "$form_frmMain2.find("":input[name='FirstName']"").rules(""add"",{equalto:"":input[name='LastName']"",messages:{equalto:'The First Name must be the same as the Last Name.'}});", Script);
		</cfscript>
	</cffunction>

	<cffunction name="EqualToValidationGeneratesCorrectScriptWithOverriddenPrefix" access="public" returntype="void">
		<cfscript>
			ComparePropertyName = "LastName";
			ComparePropertyDesc = "Last Name";
			valStruct.ValType = "EqualTo";
			valStruct.Parameters.ComparePropertyName = {value=ComparePropertyName,type="value"};
			valStruct.Parameters.ComparePropertyDesc = {value=ComparePropertyDesc,type="value"};
			ValidateThisConfig.defaultFailureMessagePrefix = "";
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			ScriptWriter = validationFactory.getBean("ClientValidator").getScriptWriter("jQuery");
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frm-Main2");
			assertTrue(Script contains "$form_frmMain2.find("":input[name='FirstName']"").rules(""add"",{equalto:"":input[name='LastName']"",messages:{equalto:'First Name must be the same as Last Name.'}});", script );
		</cfscript>
	</cffunction>

	<cffunction name="BooleanValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "boolean";
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules('add',{boolean: true});}",Script);
			
		</cfscript>  
	</cffunction>

	<cffunction name="noHTMLValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			/* not implemented yet
			valStruct.ValType = "noHTML";
			validation.load(valStruct);
			script = ScriptWriter.generateValidationScript(validation,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules('add',{email: true});}",Script);
			*/
		</cfscript>  
	</cffunction>

</cfcomponent>