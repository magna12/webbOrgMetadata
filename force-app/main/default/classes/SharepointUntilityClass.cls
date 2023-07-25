public class SharepointUntilityClass {
    public static void getToken(){
        response respInstance= new response();
        String clientId = 'ec7976b3-01a0-48bb-9f24-331a7b1a4ada'; 
        String clientSecret = '61BmVo@8A_.[scdJ9oC79V=tA3TUHlL:';
        String tenantId = 'fd43123f-8bdf-4e43-ad8d-22ca104063f6';
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        //https://login.microsoftonline.com/< tenant Id>/oauth2/token
        req.setEndpoint('https://login.microsoftonline.com/'+EncodingUtil.urlEncode(tenantId, 'UTF-8').replaceAll('\\+', '%20')+'/oauth2/token'); 
        String body = 'grant_type=client_credentials'+
            '&client_id=' + EncodingUtil.urlEncode(clientId, 'UTF-8') +
            '&client_secret='+ EncodingUtil.urlEncode(clientSecret, 'UTF-8') +
            '&resource=https://graph.microsoft.com';                              
        req.setBody(body);
        HttpResponse res = h.send(req);
        System.debug('1'+req);
        System.debug('2'+body);
        System.debug('Response Body: ' + res.getBody());
        respInstance=(response)System.JSON.deserialize(res.getBody(), response.class);
        System.debug('Token'+respInstance.access_token);
        getFiles(respInstance.access_token);
    }
    public class response{
        public  string access_token {get;set;}
    }
    @future(callout=true)
    public static void getFiles(String Token){
	Attachment a=new Attachment();
        a=[SELECT Id, Body, BodyLength, ContentType, CreatedById, CreatedDate, IsDeleted, Description, Name, LastModifiedById, LastModifiedDate, OwnerId, ParentId, IsPrivate, SystemModstamp FROM Attachment where ID =: '00P7F00000116YUUAY'];
        String access_token= Token;
        String driveID = 'b!BqXme_GsBkKT3Lu6_CyraK7jJZ4TacVBv_7JjaZvXLxjaFuzDYgpSI4InpuNbPdJ';
        String folderName = 'Salesforce document';
        String fileName = a.name;
		        String boundary = 'foo_bar_baz';

        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('PUT');
        req.setHeader('Authorization', 'Bearer '+ access_token);
        req.setHeader('Content-Length', String.valueOf(a.BodyLength));
        req.setHeader('content-type', 'multipart/mixed; boundary="' + boundary + '"');
		                req.setHeader('Accept', 'application/json');


        String endPoint = 'https://graph.microsoft.com/v1.0/drives/' + 
            EncodingUtil.urlEncode(driveID, 'UTF-8').replaceAll('\\+', '%20') +
            '/root:/'+EncodingUtil.urlEncode(folderName, 'UTF-8').replaceAll('\\+', '%20')+'/'+
            EncodingUtil.urlEncode(fileName, 'UTF-8').replaceAll('\\+', '%20')+':/content';
        req.setEndpoint(endPoint);
        req.setBodyAsBlob(a.body);
        HttpResponse res = h.send(req);
        System.debug('Response Body: ' + res.getBody());
        //Get your drive id from the response and store it somewhere.
    }
}