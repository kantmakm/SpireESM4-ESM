<cfsavecontent variable="modulexml">
<module name="FeedReader" label="Feed Reader" menuOrder="0" securityitems="">
	<action name="editClientModule" onMenu="0" template="popup-onecol" formSubmit="saveclientmodule">
		<template name="title" title="label" file="clientmodulelabel.cfm"/>
		<template name="title" title="label" file="clientmodulebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="clientmoduleform.cfm"/>
	</action>
	
	<action name="Save Client Module"/>
	<action name="Delete Client Module"/>
    <action name="TestFeed"/>
</module>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>



