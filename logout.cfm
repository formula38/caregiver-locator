<cfscript>
    structDelete(session, "user");
    location("index.cfm");
</cfscript>
