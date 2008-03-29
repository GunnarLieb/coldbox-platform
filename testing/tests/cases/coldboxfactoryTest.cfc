<!-----------------------------------------------------------------------
********************************************************************************
Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldboxframework.com | www.luismajano.com | www.ortussolutions.com
********************************************************************************

Author     :	Luis Majano
Date        :	9/3/2007
Description :
	Request service Test
----------------------------------------------------------------------->
<cfcomponent name="requestserviceTest" extends="coldbox.system.extras.baseTest" output="false">

	<cffunction name="setUp" returntype="void" access="private" output="false">
		<cfscript>
		//Setup ColdBox Mappings For this Test
		setAppMapping("/coldbox");
		setConfigMapping(ExpandPath(instance.AppMapping & "/config/coldbox.xml.cfm"));
		//Call the super setup method to setup the app.
		super.setup();
		//place controller in app scope for this.
		application.cbController = getController();
		</cfscript>
	</cffunction>
	
	<cffunction name="testFactoryCreations" access="public" returntype="void" output="false">
		<cfscript>
		var factory = CreateObject("component","coldbox.system.extras.ColdboxFactory");
		var obj = "";
		
		//Create objects
		obj = factory.getConfigBean();
		AssertComponent(obj,"config bean");
		
		obj = factory.getColdbox();
		AssertSameComponent(getController(), obj, "Controller");
		
		obj = factory.getColdboxOCM();
		AssertSameComponent(getController().getColdBoxOCM(), obj, "OCM");
		
		obj = factory.getPlugin("logger");
		AssertSameComponent(getController().getPlugin("logger"), obj, "Logger Plugin");
		
		AssertComponent(factory.getInterceptor("coldbox.system.interceptors.ses"), "Interceptor");
		
		obj = factory.getPlugin("date",true);
		AssertTrue(structKeyExists(obj,"getToday"), "Date Plugin");
		
		obj = factory.getDatasource("mysite");
		AssertTrue( isStruct(obj.getMemento()), "Datasource");
		
		obj = factory.getMailSettings();
		AssertTrue( isStruct(obj.getMemento()), "Mail Settings");
		</cfscript>
	</cffunction>
	
	<!--- tearDown --->
	<cffunction name="tearDown" output="false" access="public" returntype="void" hint="">
		<cfscript>
		structDelete(application,"cbController");
		</cfscript>
	</cffunction>
	
</cfcomponent>