global class SharePointOnlineWebserviceCallout{

@future (callout=true)

Public static Void GetAuthentication(string AccountTitle)

{

string body = '';

string formattedCookie = '';

string output = '';

string cookie = '';

string token = '';

string username = 'account@sharepoint.com';

string password = 'Password';

string host = 'https://webbdecay.sharepoint.com';

string tokenRequestXml ='<s:Envelope ' +

                        'xmlns:s=\'http://www.w3.org/2003/05/soap-envelope\' ' +

                        'xmlns:a=\'http://www.w3.org/2005/08/addressing\' ' +

                        'xmlns:u=\'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd\'> ' +

                        '<s:Header>' +

                            '<a:Action s:mustUnderstand=\'1\'>http://schemas.xmlsoap.org/ws/2005/02/trust/RST/Issue</a:Action>' +

                            '<a:ReplyTo> ' +

                                '<a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address> ' +

                            '</a:ReplyTo>' +

                            '<a:To s:mustUnderstand=\'1\'>https://login.microsoftonline.com/extSTS.srf</a:To> ' +

                            '<o:Security ' +

                                's:mustUnderstand=\'1\' ' +

                                'xmlns:o=\'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd\'> ' +

                                '<o:UsernameToken> ' +

                                    '<o:Username>' + username + '</o:Username>' +

                                    '<o:Password>' + password + '</o:Password>' +

                                '</o:UsernameToken>' +

                            '</o:Security>' +

                        '</s:Header>' +

                        '<s:Body>' +

                            '<t:RequestSecurityToken xmlns:t=\'http://schemas.xmlsoap.org/ws/2005/02/trust\'> ' +

                                '<wsp:AppliesTo xmlns:wsp=\'http://schemas.xmlsoap.org/ws/2004/09/policy\'> ' +

                                    '<a:EndpointReference> ' +

                                       ' <a:Address>' + host + '</a:Address> ' +

                                    '</a:EndpointReference> ' +

                                '</wsp:AppliesTo> ' +

                               ' <t:KeyType>http://schemas.xmlsoap.org/ws/2005/05/identity/NoProofKey</t:KeyType> ' +

                                '<t:RequestType>http://schemas.xmlsoap.org/ws/2005/02/trust/Issue</t:RequestType> ' +

                               ' <t:TokenType>urn:oasis:names:tc:SAML:1.0:assertion</t:TokenType> ' +

                            '</t:RequestSecurityToken> ' +

                       ' </s:Body> ' +

                    '</s:Envelope>';
HttpRequest reqBinaryToken = new HttpRequest();

reqBinaryToken.setEndpoint('https://login.microsoftonline.com/extSTS.srf');

reqBinaryToken.setMethod('POST');

reqBinaryToken.setbody(tokenRequestXml);

reqBinaryToken.setHeader('Content-Length',String.valueof(tokenRequestXml.length()));

reqBinaryToken.setTimeout(60000);


HttpResponse responseBinaryToken = new HttpResponse();

Http httpBinaryToken = new Http();

responseBinaryToken = httpBinaryToken.send(reqBinaryToken);

string xmlContent = responseBinaryToken.getBody();

Dom.Document doc = responseBinaryToken.getBodyDocument();

Dom.XMLNode address = doc.getRootElement();

//XmlStreamReader reader = new XmlStreamReader(responseBinaryToken.getBody());

string outxmlstring = String.valueof(doc.getRootElement().getName());//gives you root element Name


XmlStreamReader reader = new XmlStreamReader(responseBinaryToken.getBody());

while(reader.hasNext()) {

if (reader.getEventType() == XmlTag.START_ELEMENT && reader.getLocalName()== 'BinarySecurityToken') {

reader.next();

    if(reader.hasNext()){

    if(reader.getEventType() == XmlTag.CHARACTERS){

token = reader.getText();

token += '&p=';

    }

    }

}

reader.next();

}


HttpRequest requestCookie = new HttpRequest();

requestCookie.setEndpoint('https://yourdoamin.sharepointonline.com/_forms/default.aspx?wa=wsignin1.0');

requestCookie.setHeader('Content-Type', 'application/x-www-form-urlencoded');

requestCookie.setHeader('User-Agent','Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0)');

requestCookie.setMethod('POST');

requestCookie.setBody(token);

requestCookie.setHeader('Content-Length',String.valueof(token.length()));


HttpResponse responseCookie = new HttpResponse();

Http httpCookie = new Http();

responseCookie = httpCookie.send(requestCookie);

string location = responseCookie.getHeader('Location');


if(responseCookie.getStatus() == 'MovedPermanently'){

HttpRequest reqMovedPermanently = new HttpRequest();

reqMovedPermanently.setHeader('Content-Type', 'application/x-www-form-urlencoded');

reqMovedPermanently.setMethod('POST');

reqMovedPermanently.setEndpoint('https://yourdoamin.sharepointonline.com/_forms/default.aspx?wa=wsignin1.0');

reqMovedPermanently.setBody(token);

reqMovedPermanently.setHeader('Content-Length',String.valueof(token.length()));

reqMovedPermanently.setHeader('Location', location);

reqMovedPermanently.setHeader('User-Agent','Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0)');

HttpResponse responseMovedPermanently = new HttpResponse();

Http httpMovedPermanently = new Http();

responseMovedPermanently = httpMovedPermanently.send(reqMovedPermanently);

cookie = responseMovedPermanently.getHeader('Set-Cookie');

}

else

{

cookie = responseCookie.getHeader('Set-Cookie');

}


HttpRequest requestDigest = new HttpRequest();

requestDigest.setEndpoint('https://yourdoamin.sharepointonline.com/_api/contextinfo');

requestDigest.setMethod('POST');

requestDigest.setBody(body);

requestDigest.setHeader('Content-Length',String.valueof(body.length()));

requestDigest.setHeader('Accept','application/json;odata=verbose');

requestDigest.setHeader('Content-Type','application/json;odata=verbose');

requestDigest.setHeader('Cookie',cookie);


Http httpRequestDigest = new Http();

HttpResponse responseRequestDigest = new HttpResponse();

responseRequestDigest = httpRequestDigest.send(requestDigest);

string requestDigestValue = responseRequestDigest.toString();

string xmlContentRequestDigest = responseRequestDigest.getBody();


Integer index1 = xmlContentRequestDigest.indexOf('"FormDigestValue":"');


Integer index2 = '"FormDigestValue":"'.length();


string contentRequestDigest = xmlContentRequestDigest.Substring(index1 + index2);


string requestDigestXml = contentRequestDigest.split('\"')[0];


HttpRequest reqWrite = new HttpRequest();

HttpResponse resWrite = new HttpResponse();

Http httpWrite = new Http();

reqWrite.setEndpoint('https://yourdoamin.sharepointonline.com/_api/web/lists/GetByTitle(\'AccountTest\')/items');

reqWrite.setMethod('POST');

reqWrite.setCompressed(false);

reqWrite.setHeader('Accept', 'application/json;odata=verbose');

reqWrite.setHeader('Content-Type', 'application/json;odata=verbose');

reqWrite.setHeader('X-RequestDigest',requestDigestXml);

reqWrite.setHeader('Cookie', cookie);

string writebody = '{ \'__metadata\': { \'type\': \'SP.Data.AccountTestListItem\' },\'Title\': \''+ AccountTitle +'\' }';

reqWrite.setBody(writebody);

reqWrite.setHeader('Content-Length', string.ValueOf(writebody.length()));

try

{

resWrite = httpWrite.send(reqWrite);

}

catch(System.CalloutException e)

{

System.debug('Callout error: '+ e);

}

}

}