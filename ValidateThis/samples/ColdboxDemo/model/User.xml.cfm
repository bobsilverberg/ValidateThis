<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="http://www.validatethis.org/validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<conditions>
		<condition name="MustLikeSomething" 
			serverTest="getLikeCheese() EQ 0 AND getLikeChocolate() EQ 0"
			clientTest="$(&quot;[name='LikeCheese']&quot;).getValue() == 0 &amp;&amp; $(&quot;[name='LikeChocolate']&quot;).getValue() == 0;" />
	</conditions>
	<contexts>
		<context name="Register" formName="frmMain" />
		<context name="Profile" formName="frmMain" />
	</contexts>
	<objectProperties>
		<property name="UserName" desc="Email Address">
			<rule type="required" contexts="*" />
			<rule type="email" contexts="*" failureMessage="Hey, buddy, you call that an Email Address?" />
		</property>
		<property name="Nickname">
			<rule type="custom" failureMessage="That Nickname is already taken.  Please try a different Nickname."> <!-- Specifying no context is the same as specifying a context of "*" -->
				<param name="methodname" value="CheckDupNickname" />
				<param name="remoteURL" value="ColdBoxProxy.cfc?method=CheckDupNickname&amp;returnformat=plain" />
			</rule>
		</property>
		<property name="UserPass" desc="Password">
			<rule type="required" contexts="*" />
			<rule type="rangelength" contexts="*">
				<param name="minlength" value="5" />
				<param name="maxlength" value="10" />
			</rule>
		</property>
		<property name="VerifyPassword">
			<rule type="required" contexts="*" />
			<rule type="equalTo" contexts="*">
				<param name="ComparePropertyName" value="UserPass" />
			</rule>
		</property>
		<property name="UserGroup" clientfieldname="UserGroupId">
			<rule type="required" contexts="*" />
		</property>
		<property name="Salutation">
			<rule type="required" contexts="Profile" />
			<rule type="regex" contexts="*"
				failureMessage="Only Dr, Prof, Mr, Mrs, Ms, or Miss (with or without a period) are allowed.">
				<param name="Regex" value="^(Dr|Prof|Mr|Mrs|Ms|Miss)(\.)?$" />
			</rule>
		</property>
		<property name="FirstName">
			<rule type="required" contexts="Profile" />
		</property>
		<property name="LastName">
			<rule type="required" contexts="Profile" />
			<rule type="required" contexts="Register">
				<param name="DependentPropertyName" value="FirstName" />
			</rule>
		</property>
		<property name="LikeOther" desc="What do you like?">
			<rule type="required" contexts="*" condition="MustLikeSomething"
				failureMessage="If you don't like Cheese and you don't like Chocolate, you must like something!">
			</rule>
		</property>
		<property name="HowMuch" desc="How much money would you like?">
			<rule type="required" contexts="*" />
			<rule type="numeric" contexts="*" />
		</property>
		<property name="CommunicationMethod" desc="Communication Method">
			<rule type="required" contexts="*"
				failureMessage="If you are allowing communication, you must choose a communication method.">
				<param name="DependentPropertyName" value="AllowCommunication" />
				<param name="DependentPropertyValue" value="1" />
			</rule>
		</property>
	</objectProperties>
</validateThis>
