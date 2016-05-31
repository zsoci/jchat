//
//  SoapXMLBuilder.h
//  BridgeIsland
//
//  Created by Zsolt Laky on 2012.01.08..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define SOAP_RESPONSE_HEADER_PATH   @"/soap:Envelope/soap:Body/*"
//#define SOAP_RESPONSE_HEADER_PATH   @"//*[local-name()='GetIPResponse']"
//#define GETIP_RESPONSE_NAME         @"SOAP-ENV:GetIPResponse"

//#define kXMLNameSpace @"xmlns=\"http://ws.lamardan.com/\""
//#define kXMLSoapHeader  @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n\
//<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n\
//xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"\n\
//xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n\
//\t<soap:Body>\n"
//#define kXMLSoapFooter @"\n\t</soap:Body>\n</soap:Envelope>\n"
//#define kXMLFORMAT(Function,Content) kXMLSoapHeader kXMLBody(Function,Content) kXMLSoapFooter
//#define kXMLBody(Function,Content) @"\t\t<"#Function@" "kXMLNameSpace@">\n\t\t\t"Content@"\n\t\t"kXMLAppMessage@"\n\t\t</"#Function@">"
//#define kXMLAppMessage @"<sAppMessage>%@</sAppMessage>"
//#define kSOAPBody(Function,Content,AppMessage) ("%@",[NSString stringWithFormat:kXMLFORMAT(Function,Content),AppMessage])
#define kXMLNameSpace @"xmlns=\"http://ws.lamardan.com/\""
#define kXMLSoapHeader  @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n\
<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n\
xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"\n\
xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n\
\t<soap:Body>\n"
#define kXMLSoapFooter @"\n\t</soap:Body>\n</soap:Envelope>\n"
#define kXMLFORMAT(Function) kXMLSoapHeader kXMLBody(Function) kXMLSoapFooter
#define kXMLBody(Function) @"\t\t<"#Function@" "kXMLNameSpace@">\n\t\t\t%@\n\t\t\t"kXMLAppMessage@"\n\t\t</"#Function@">"
#define kXMLAppMessage @"<sAppMessage>\n\t\t\t\t%@\n\t\t\t</sAppMessage>"
#define kSOAPBody(Function,Content,AppMessage) ("%@",[NSString stringWithFormat:kXMLFORMAT(Function),Content,[NSString stringWithUTF8String:[AppMessage UTF8String]]])

#define kXMLRegisterBody(EMail) [NSString stringWithFormat:@"<sEMail>%@</sEMail>",EMail]
#define kXMLSaveUserProfileBody(EMail,Avatar) [NSString stringWithFormat:@"<sEMail>%@</sEMail><sAvatar>%@</sAvatar>",EMail,Avatar]
#define kXMLFetchMessagesBody(MessageSerialNr) [NSString stringWithFormat:@"<nMsgSerial>%@</nMsgSerial>",[MessageSerialNr stringValue]]
@interface MSoapXMLBuilder : NSObject
//+ (NSString *) getIP;
//+ (NSString *) registerUser:(NSString *)pUserName password:(NSString *)pPassword device:(NSString *)pDeviceId email:(NSString *)pEmai pin:(NSString *)pPin;
//+ (NSString *) login:(NSString *)pMessage;
//+ (NSString *) get:(NSString *)pSerial;
//+ (NSString *) get:(NSArray *)pLobbiesWithSerials privateSerial:(NSString *) pPrivateSerial;
@end
