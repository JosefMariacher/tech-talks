<!--
*************************************************
DoCaptureReceipt.cfm

This page takes necessary parameter from doCapture.cfm page
and pssing into doHttppost function which takes request value
as Struct Object it will call cfhttp tag to perform DoCapture.This
page will show the response value coming from the Server. If
any error occurs, the page will redirect to APIError.cfm to
show exact error details

*************************************************
-->
<cfscript>
	StructClear(Session);
		
	// create our objects to call methods on
	caller = createObject("CallerService");
	display = createObject("DisplayService");
	trans = createObject("Transaction");

	try {
		
		data = StructNew();
		data.method = "DOCapture";
	
		requestData = trans.setVoidData(form,request,data);
		
		//writeDump(requestData);
		//abort;
		
		response = caller.doHttppost(requestData);
		
		responseStruct = StructNew();
		responseStruct = caller.getNVPResponse(#URLDecode(response)#);
		Session.resStruct = responseStruct;
		if (not StructKeyExists(responseStruct, "PARENTTRANSACTIONID"))
		{
			responseStruct.PARENTTRANSACTIONID = "";
		}
	}

	catch(any e) 
	{
		writeOutput("Error: " & e.message);
		writeDump(session.resStruct);
		abort;
	}
</cfscript>

<head>
    <title>PayPal CF SDK - DoCapture API</title>
    <link href="sdk.css" rel="stylesheet" type="text/css" />
</head>
<body>

<cfif responseStruct.Ack is "Success">
	<h1>Do Capture</h1>
	<b>Authorization captured!</b><br><br>
     <cfscript>
       	 	writeOutput(display.displayText(responseStruct));
     </cfscript>
</cfif>

<cfif responseStruct.Ack is "Failure">
    <center> 
    <b>Error!</b>
    <br>
    <cfscript>
        writeOutput(display.displayText(responseStruct));
    </cfscript>
</cfif>

<a class="home" id="CallsLink" href="index.html">Home</a>
</body>
</html>