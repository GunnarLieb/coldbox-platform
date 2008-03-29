<!-----------------------------------------------------------------------
********************************************************************************
Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldboxframework.com | www.luismajano.com | www.ortussolutions.com
********************************************************************************

Author     :	Luis Majano
Date        :	9/3/2007
Description :
	securityTest
----------------------------------------------------------------------->
<cfcomponent name="securityTest" extends="coldbox.system.extras.baseTest" output="false">

	<cffunction name="setUp" returntype="void" access="private" output="false">
		<cfscript>
		var mypath = getDirectoryFromPath(getMetaData(this).path);
		var slash = createObject("java","java.lang.System").getProperty("file.separator");
		
		//Setup ColdBox Mappings For this Test
		setAppMapping("/coldbox");
		setConfigMapping("#mypath#resources#slash#security_cbox_xml.xml");
		
		//Call the super setup method to setup the app.
		super.setup();
		</cfscript>
	</cffunction>
	
	<cffunction name="testDefaultLoad" access="public" returntype="void" output="false">
		<!--- Now test some events --->
		<cfscript>
			var event = "";
			
			//First Test : white list on rule 1
			url.event = 'user.login';
			setupRequest();			
			//Now intercept
			announceinterception('preProcess');
			//get Context
			event = getRequestContext();
			//Assert Relocation, first test should be blank.
			assertEqualsString( "", event.getValue("setnextevent",""), "Whitelist event." );
			
			event.clearCollection();
			//Test 2: user.profile, not logged in, so secure it
			url.event = 'user.profile';
			setupRequest();			
			//Now intercept
			announceinterception('preProcess');
			//get Context
			event = getRequestContext();
			//Assert Relocation, first test should be blank.
			assertTrue( len(event.getValue("setnextevent","")), "Secured event. #event.getValue("setnextevent","")#" );
		</cfscript>
		<cfreturn>
	</cffunction>	
	
	<cffunction name="testLoggedInUser" access="public" returntype="void" output="false">
		<!--- Now test some events --->
		<cfscript>
			var mypath = getDirectoryFromPath(getMetaData(this).path);
			var slash = createObject("java","java.lang.System").getProperty("file.separator");
			
			//Setup ColdBox Mappings For this Test
			setAppMapping("/coldbox");
			setConfigMapping("#mypath#resources#slash#security_cbox_xml.xml");
			
			//resetup
			getController().getService("loader").setupCalls(getConfigMapping(),getAppMapping());
		</cfscript>
		<!--- Login a user --->
		<cflogout>
		<cflogin>
			<cfloginUser name="Luis" password="luis" roles="admin">
		</cflogin>
		
		<cfscript>
		url.event = 'admin.user.list';
		setupRequest();			
		//Now intercept
		announceinterception('preProcess');
		//get Context
		event = getRequestContext();
		//Assert Relocation, first test should be blank.
		assertEqualsString( "", event.getValue("setnextevent",""), "User is in role, no redirection." );
		</cfscript>
		<!--- logout again. --->
		<cflogout>
		<cfreturn>
	</cffunction>
	
	
	
	<cffunction name="testDBLoad" access="public" returntype="void" output="false">
		<cfscript>
		var mypath = getDirectoryFromPath(getMetaData(this).path);
		var slash = createObject("java","java.lang.System").getProperty("file.separator");
		
		//Setup ColdBox Mappings For this Test
		setAppMapping("/coldbox");
		setConfigMapping("#mypath#resources#slash#security_cbox_db.xml");
		
		//resetup
		getController().getService("loader").setupCalls(getConfigMapping(),getAppMapping());
	
		</cfscript>
	</cffunction>
	
	<cffunction name="testIOCLoad" access="public" returntype="void" output="false">
		<cfscript>
		var mypath = getDirectoryFromPath(getMetaData(this).path);
		var slash = createObject("java","java.lang.System").getProperty("file.separator");
		
		//Setup ColdBox Mappings For this Test
		setAppMapping("/coldbox");
		setConfigMapping("#mypath#resources#slash#security_cbox_ioc.xml");
		
		//resetup
		getController().getService("loader").setupCalls(getConfigMapping(),getAppMapping());
				
		</cfscript>
	</cffunction>
	
	<cffunction name="testOCMLoad" access="public" returntype="void" output="false">
		<cfscript>
		var mypath = getDirectoryFromPath(getMetaData(this).path);
		var slash = createObject("java","java.lang.System").getProperty("file.separator");
		
		//Setup ColdBox Mappings For this Test
		setAppMapping("/coldbox");
		setConfigMapping("#mypath#resources#slash#security_cbox_ocm.xml");
		
		//resetup
		getController().getService("loader").setupCalls(getConfigMapping(),getAppMapping());
		
		/* Place rules on OCM */
		getController().getColdboxOCM().set('qSecurityRules', getRules(),0);
		
		//intercept
		announceInterception('preProcess');
				
		</cfscript>
	</cffunction>
	
	<cffunction name="testRegisterValidator" access="public" returntype="void" output="false">
		<cfscript>
		var validator = CreateObject("component","applications.coldbox.testing.testmodel.security");
		var event = getRequestContext();
		AssertComponent(validator);
		
		/* Register */
		getInterceptor('coldbox.system.interceptors.security').registerValidator(validator);
		
		/* Test */
		event.setValue('event','admin.list');
		getInterceptor('coldbox.system.interceptors.security').preProcess(event,structnew());
				
		</cfscript>
	</cffunction>
	
	<cffunction name="testCreatedValidator" access="public" returntype="void" output="false">
		<cfscript>
		var mypath = getDirectoryFromPath(getMetaData(this).path);
		var slash = createObject("java","java.lang.System").getProperty("file.separator");
		var event = getRequestContext();
		
		//Setup ColdBox Mappings For this Test
		setAppMapping("/coldbox");
		setConfigMapping("#mypath#resources#slash#security_cbox_ioc.xml");
		
		//resetup
		getController().getService("loader").setupCalls(getConfigMapping(),getAppMapping());
		
		/* Test */
		event.setValue('event','admin.list');
		getInterceptor('coldbox.system.interceptors.security').preProcess(event,structnew());
		</cfscript>
	</cffunction>
	
	
	<cffunction name="getInterceptor" returntype="any" access="private" output="false">
		<cfargument name="interceptor">
		<cfscript>
			var cacheKey = getController().getInterceptorService().INTERCEPTOR_CACHEKEY_PREFIX;
			
			cachekey = cachekey & arguments.interceptor;
			
			if( getController().getColdBoxOCM().lookup(cacheKey) ){
				return getController().getColdBoxOCM().get(cachekey);
			}
			else
				throw("Invalid interceptor");
		</cfscript>
	</cffunction>
	
	<cffunction name="getRules" access="private" returntype="query" hint="" output="false" >
		<cfscript>
			var qRules = querynew("rule_id,securelist,whitelist,roles,permissions,redirect");
			
			QueryAddRow(qRules,1);
			QuerySetcell(qrules,"rule_id",createUUID());
			QuerySetcell(qrules,"securelist","^user\..*, ^admin");
			QuerySetcell(qrules,"whitelist","user.login,user.logout,^main.*");
			QuerySetcell(qrules,"roles","admin");	
			QuerySetcell(qrules,"permissions","WRITE");		
			QuerySetcell(qrules,"redirect","user.login");
						
			return qRules;
		</cfscript>	
	</cffunction>
	
</cfcomponent>