<!--- <cfset lcl.imisgroups = getDataItem('imisgroups')> --->
<cfset lcl.memberTypes = getDataItem('memberTypes')>
<cfset lcl.form = createWidget("formcreator")>
<cfset lcl.block = getDataItem('block')>

<cfset lcl.form.startform()>

<cfif lcl.membertypes.recordcount>

	If Member Types are selected, only associated users will be able to see this page.  
	
	<cfset lcl.form.addformitem('memberType', '', false, 'hidden', lcl.info.memberTypes)>
	
	<cfset lcl.config = structnew()>
	
	<cfset lcl.config.options = lcl.memberTypes>
	<cfset lcl.config.valueskey = 'name'>
	<cfset lcl.config.labelskey = 'name'>
	<cfset lcl.config.addblank = true>
	<cfset lcl.config.blanktext = "No Restriction">
	<cfset lcl.form.addformitem('memberType', 'Restrictions', true, 'listmanager', lcl.block.memberTypes, lcl.config)>
<cfelse>
	Not Applicable.
	<cfset lcl.form.addformitem('memberType', '', true, 'hidden', "default")>
</cfif>

<cfset lcl.form.endform()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>