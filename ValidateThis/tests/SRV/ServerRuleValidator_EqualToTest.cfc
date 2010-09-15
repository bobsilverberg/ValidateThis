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
<cfcomponent extends="validatethis.tests.SRV.BaseForServerRuleValidatorTests" output="false">
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			super.setup();
			SRV = getSRV("equalTo");
		</cfscript>
	</cffunction>

	<cffunction name="configureValidationMock" access="private">
        <cfscript>
            //TODO: Need to mock getObjectType() but not sure what to set it to. SRV tests by default point to /fixture/models/cf9
			
           super.configureValidationMock();
            
           validation.getParameterValue("ComparePropertyName").returns("VerifyPassword");
           validation.getObjectValue("VerifyPassword").returns(otherObjectValue);

        </cfscript>
    </cffunction>

	<cffunction name="validateReturnsTrueWhenPropertiesAreEqual" access="public" returntype="void">
		<cfscript>
           validation.getParameterValue("ComparePropertyDesc","").returns("Verify The Password");
			objectValue = "12345";
			otherObjectValue = "12345";
            configureValidationMock();
			
			SRV.validate(validation);
			validation.verifyTimes(0).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseWhenPropertiesAreNotEqual" access="public" returntype="void">
		<cfscript>
           validation.getParameterValue("ComparePropertyDesc","").returns("Verify The Password");
			objectValue = "12345";
			otherObjectValue = "";
            configureValidationMock();
			
			SRV.validate(validation);
			validation.verifyTimes(1).setIsSuccess(false); 
		</cfscript>  
	</cffunction>

	<cffunction name="validateSetsFailureMessageFromDescParameterWhenADescParamaterIsProvided" access="public" returntype="void">
		<cfscript>
           validation.getParameterValue("ComparePropertyDesc","").returns("Verify The Password");
		   failureMessage = "The PropertyDesc must be the same as the Verify The Password.";
			objectValue = "12345";
			otherObjectValue = "";
            configureValidationMock();
			
			SRV.validate(validation);
			validation.verifyTimes(1).setIsSuccess(false); 
			validation.verifyTimes(1).setFailureMessage(failureMessage); 
		</cfscript>  
	</cffunction>

	<cffunction name="validateSetsFailureMessageWithCorrectDescFromMetadataWhenNoDescParamaterIsProvided" access="public" returntype="void">
		<cfscript>
			needsFacade = true;
           validation.getParameterValue("ComparePropertyDesc","").returns("");
		   failureMessage = "The PropertyDesc must be the same as the Verify Password.";
			objectValue = "12345";
			otherObjectValue = "";
            configureValidationMock();
			
			SRV.validate(validation);
			
			validation.verifyTimes(1).setIsSuccess(false); 
			validation.verifyTimes(1).setFailureMessage(failureMessage); 
		</cfscript>  
	</cffunction>

	<cffunction name="validateReturnsTrueForEmptyPropertyIfNotRequired" access="public" returntype="void" hint="This test is not applicable to this SRV">
	</cffunction>
	
	<cffunction name="validateReturnsFalseForEmptyPropertyIfRequired" access="public" returntype="void" hint="This test is not applicable to this SRV">
	</cffunction>
	
</cfcomponent>
