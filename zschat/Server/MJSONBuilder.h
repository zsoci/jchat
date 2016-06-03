//
//  MJSONBuilder.h
//  jchat
//
//  Created by Zsolt Laky on 5/31/16.
//  Copyright © 2016 Zsolt Laky. All rights reserved.
//

#ifndef MJSONBuilder_h
#define MJSONBuilder_h

#import <Foundation/Foundation.h>

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

#define kXMLSaveUserProfileBody(EMail,Avatar) [NSString stringWithFormat:@"<sEMail>%@</sEMail><sAvatar>%@</sAvatar>",EMail,Avatar]
#define kLoginBody(UserName, Password, AppMessage) ("%@", [NSString stringWithFormat:@"{\"user_token\":\"%@\", \"password\":\"%@\", \"app_msg\":\"%@\"}", UserName, Password, AppMessage])
#define kRegisterBody(UserName, Password, Email, AppMessage) ("%@", [NSString stringWithFormat:@"{\"user_token\":\"%@\", \"password\":\"%@\", \"email\":\"%@\", \"app_msg\":%@}", UserName, Password, Email, AppMessage])
#define kCommandBody(Command, AppMessage) ("%@", [NSString stringWithFormat:@"{\"command\":\"%@\", \"password\":\"%@\", \"email\":\"%@\", \"app_msg\":\"%@\"}", UserName, Password, Email, AppMessage])
#define kSaveUserProfileBody(AppMessage) ("%@", [NSString stringWithFormat:@"{\"command\":\"save_user_profile\", \"app_msg\":%@}", AppMessage])
@interface MJSONBuilder : NSObject
@end

#endif /* MJSONBuilder_h */
