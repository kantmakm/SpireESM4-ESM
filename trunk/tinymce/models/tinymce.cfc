<cfcomponent name="model" output="false" extends="resources.abstractModel">

	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfargument name="userobj" required="true">
		<cfset variables.request = arguments.request>
		<cfset variables.userobj = arguments.userobj>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getJSPageList" output="false">
		<cfargument name="sitepages" required="true">
	
		<cfset var jslist = "">

		<cfsavecontent variable="jslist">
			<cfoutput>
			var tinyMCELinkList = new Array(
			<cfloop query="sitepages">
				["#replace(pagename,'"','', 'ALL')#", "#urlpath#"]#iif((sitepages.recordcount neq sitepages.currentrow),DE(","),DE(""))#
			</cfloop>
			);
			</cfoutput>
		</cfsavecontent>

		<cfreturn jslist/>
	</cffunction>
	
	<cffunction name="getJSImageList" output="false">
		<cfargument name="siteimages" required="true">
	
		<cfset var temp = "">
		<cfset var jslistA = arraynew(1)>
		<cfset var jslistB = "">
			
		<cfoutput query="siteimages" group="assetGroup_Name">
			<cfset temp = '{ groupname:"#assetgroup_name#", items:['>
			<cfset jslistB = arraynew(1)>
			<cfoutput>
				<cfset arrayappend(jslistB, '["#name#", "/assets/viewImage/?id=#id#"]')>
			</cfoutput>
			<cfset temp = temp & arraytolist(jslistB,",") & ']}'>
			<cfset arrayappend(jslistA, temp)>
		</cfoutput>
		
		<cfreturn "var tinyMCEImageList = [" & arraytolist(jslistA, ",") & "]"/>
	</cffunction>
	
</cfcomponent>