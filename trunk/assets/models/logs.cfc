<cfcomponent name="logobserver">
	
	<cffunction name="init">
		<cfargument name="requestObject">
		<cfargument name="userObject">
		<cfset variables.requestObject = arguments.requestObject>	
		<cfset variables.userObject = arguments.userObject>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getRecentHistory">
		<cfargument name="days" type="numeric" default="10">
	
		<cfset var add = "">
		
		<cfquery name="add" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT description, fname + ' ' + lname fullname, actiondate 
			FROM assets_log
			INNER JOIN users ON userid = users.id
			WHERE actiondate > <cfqueryparam value="#(now() - arguments.days)#" cfsqltype="cf_sql_date">
			ORDER BY actiondate DESC
		</cfquery>
		
		<cfreturn add>
	</cffunction>
	
	<cffunction name="getItemHistory">
		<cfargument name="id" required="true">
	
		<cfset var add = "">
		
		<cfquery name="add" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT description, fname + ' ' + lname fullname, actiondate 
			FROM assets_log
			INNER JOIN users ON userid = users.id
			WHERE assetid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
			ORDER BY actiondate DESC
		</cfquery>
		
		<cfreturn add>
	</cffunction>
		
	<cffunction name="event">
		<cfargument name="eventname">
		<cfargument name="modelRef">
		
		<cfset var lcl = structNew()>
		
		<cfswitch expression="#arguments.eventname#">
			<cfcase value="save assets">
				<cfset saveAsset(modelRef)>
			</cfcase>
			<cfcase value="delete assets">
				<cfset deleteAsset(modelRef)>
			</cfcase>
		</cfswitch>
		
	</cffunction>
	
	<cffunction name="saveAsset">
		<cfargument name="modelRef" required="true">
		<cfset var d = "">
		<cfset var ag = createObject("component", "assets.models.assetgroups").init(requestObject, userObject)>
		<cfset ag.load(modelRef.getAssetGroupId())>
		
		<cfif modelRef.getSaveMode() EQ "insert">
			<cfset d = 'Added asset "#modelRef.getName()#" to group "#ag.getName()#".'>
		<cfelse>
			<cfset d = 'Updated asset "#modelRef.getName()#" in "#ag.getName()#".'>
		</cfif>
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							assetid = modelRef.getId(),
							description = d)>
	</cffunction>
	
	<cffunction name="deleteAsset">
		<cfargument name="modelRef" required="true">
		<cfset var ag = createObject("component", "assets.models.assetgroups").init(requestObject, userObject)>
		<cfset ag.load(modelRef.getAssetGroupId())>
		
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							assetid = modelRef.getId(),
							description = 'Deleted event "#modelRef.getName()#" from "#ag.getName()#".')>
	</cffunction>
	<!--- <cffunction name="addMethod">
		<cfargument name="pageref" required="true">
		
		<cfset var assetsgroup = createObject('component','assets.models.assetgroups').init(variables.requestObject,variables.userObject).getAssetGroup(arguments.pageRef.getField('assetgroupid'))>
		<cfset tempAssetGroupName = iif((assetsgroup.Item.recordcount),'assetsgroup.Item.name[1]',DE(""))>

		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							assetid = arguments.pageRef.getField('id'),
							description = 'Added "#arguments.pageRef.getField('name')#" to group "#tempAssetGroupName#".')>
	</cffunction>
	
	<cffunction name="editMethod">
		<cfargument name="pageref" required="true">
		
		<cfset var assetsgroup = createObject('component','assets.models.assetgroups').init(variables.requestObject,variables.userObject).getAssetGroup(arguments.pageRef.getField('assetgroupid'))>
		<cfset tempAssetGroupName = iif((assetsgroup.Item.recordcount),'assetsgroup.Item.name[1]',DE(""))>
		
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							assetid = arguments.pageRef.getField('id'),
							description = 'Updated "#arguments.pageRef.getField('name')#" in "#tempAssetGroupName#".')>
	</cffunction>
	
	<cffunction name="deleteMethod">
		<cfargument name="pageref" required="true">
		
		<cfset var assetsgroup = createObject('component','assets.models.assetgroups').init(variables.requestObject,variables.userObject).getById(arguments.pageRef.getAssetgroupid())>
		<cfset tempAssetGroupName = assetsgroup.name>
		
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							assetid = arguments.pageRef.getid(),
							description = 'Deleted "#arguments.pageRef.getName()#" from "#tempAssetGroupName#".')>
	</cffunction> --->
	
	<cffunction name="insertLog" access="private">
		<cfargument name="userid">
		<cfargument name="assetid">
		<cfargument name="description">
		
		<cfset var add = "">
		
		<cfquery name="add" datasource="#variables.requestObject.getVar('dsn')#">
			INSERT INTO assets_log (
				id,
				assetid,
				userid,
				description,
				actiondate
			) VALUES (
				<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.assetid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
			)
		</cfquery>
	</cffunction>

</cfcomponent>