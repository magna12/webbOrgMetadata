public class SharePointAPIUtility {
public static String getToken() {
String token;
if(!Test.isRunningTest()) {
token = SharePointAPIUtility.SharePointAPIGet('https://webbdecay.sharepoint.com/Api/Values/GetAuthToken','shadow@webbDecay.onmicrosoft.com','debesh@3171');
}
system.debug('token>>> '+token);
if(token != null) {
return EncodingUtil.urlEncode(token.replaceAll('"',''), 'UTF-8');
}
return null;
}
public static String SharePointAPIGet(String endpointUrl,String username, String password) {
try {
HttpRequest httpRequestObject = new HttpRequest();
httpRequestObject.setEndPoint(endpointUrl);
httpRequestObject.setmethod('GET');
Blob headerValue = Blob.valueOf(username + ':' + password);
String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
httpRequestObject.setHeader('Authorization', authorizationHeader);
httpRequestObject.setTimeout(120000);
system.debug('httpRequestObject>> '+httpRequestObject);

Http http = new Http();
HttpResponse httpResponse ;

if(!test.isRunningTest())
httpResponse = http.send(httpRequestObject);
if(httpResponse != null && httpResponse.getStatus() == 'OK' && httpResponse.getStatusCode() == 200) {
system.debug('httpResponse.getBody();>>>>'+httpResponse.getBody()+'httpResponse.getBody();>>>>');
return httpResponse.getBody();
}
else if(httpResponse != null) {
return 'SharePoint Server Error: Status '+ httpResponse.getStatus()+' Status Code '+ httpResponse.getStatusCode() +' Body '+httpResponse.getBody();
}
} catch(CalloutException ce) {
throw ce;
} catch(Exception ex) {
throw ex;
}
return null;
}

}