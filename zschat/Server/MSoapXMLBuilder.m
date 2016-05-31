//
//  SoapXMLBuilder.m
//  BridgeIsland
//
//  Created by Zsolt Laky on 2012.01.08..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSoapXMLBuilder.h"
//#import "ZSCommon.h"
//#import "ZSBase64.h"

@implementation MSoapXMLBuilder

//#define SOAP_RESPONSE_HEADER_FORMAT   @"//*[local-name()='%@']"


//NSString * const kXMLFORMAT = @"%@%@%@";


//NSString * const kXMLGetIP = @"<GetIP xmlns=\"http://ws.lamardan.com/\"/>\n";

//NSString * const kXMLRegisterUser = @"<RegisterUser xmlns=\"http://ws.lamardan.com/\">"
//                                        "<sUserName>%@</sUserName>"
//                                        "<sPwd>%@</sPwd>"
//                                        "<sDeviceID type=\"eDIT_RobotID\">%@</sDeviceID>"
//                                        "<sEMailAddress>%@</sEMailAddress>"
//                                        "<sPinCode>%@</sPinCode>"
//                                    "</RegisterUser>"
//
//;
//NSString * const kXMLLogin = @"<Login xmlns=\"http://ws.lamardan.com/\">\n"
//                              "</Login>\n";

NSString * const kXMLGetUserProfile = @"<GetUserProfile xmlns=\"http://ws.lamardan.com/\">\n"
                                        "<sReqName>%@</sReqName>"
                                        "</GetUserProfile>";
NSString * const kXMLSetUserProfile = @"<SetUserProfile xmlns=\"http://ws.lamardan.com/\">\n"
                                        "<sProfile>\n"
                                        "<sQuote>%@</sQuote>\n"
                                        "<sNationality>%@</sNationality>\n"
                                        "<sEMail>%@</sEMail>"
                                        "<nRobotHumanSwapEnabled>%@</nRobotHumanSwapEnabled>\n"
                                        "<nOnlineNotificationEnabled>%@</nOnlineNotificationEnabled>\n"
                                        "<sPlayerRate>%@</sPlayerRate>\n"
                                        "<sAvatar %@>%@</sAvatar>\n"
                                        "<sBiddingSystem>\n"
                                            "<sBidSys type=\"eBS_SAYC\">%@</sBidSys>\n"
                                            "<sBidSys type=\"eBS_21\">%@</sBidSys>\n"
                                            "<sBidSys type=\"eBS_Precision\">%@</sBidSys>\n"
                                            "<sBidSys type=\"eBS_Acol\">%@</sBidSys>\n"
                                        "</sBiddingSystem>\n"
                                        "</sProfile>\n"
                                        "</SetUserProfile>\n";

NSString * const kXMLGet = 		@"<Get xmlns=\"http://ws.lamardan.com/\">\n"
                                    @"%@" // lobbies in the format of @"<sLobby lastserial=\"%s\">%s</sLobby>\n"
                                    @"<sPrivate lastserial=\"%@\" />\n"
                                @"</Get>\n";

NSString * const kXMLGetLobbbyLine = @"<sLobby lastserial=\"%@\">%@</sLobby>\n";



/*

SOAP IN:
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
<soap:Body>
<SetUserProfileResponse xmlns="http://ws.lamardan.com/">
<sCode>eSUP_Ok</sCode>
</SetUserProfileResponse>
</soap:Body>
</soap:Envelope>
*/


//+ (NSString *) getIP
//{
//    return [NSString stringWithFormat:kXMLFORMAT, kXMLSoapHeader, kXMLGetIP, kXMLSoapFooter];
//}
//
//+ (NSString *) registerUser:(NSString *)pUserName password:(NSString *)pPassword device:(NSString *)pDeviceId email:(NSString *)pEmailAddress pin:(NSString *)pPin
//{
//    return [NSString stringWithFormat:kXMLFORMAT, kXMLSoapHeader,
//            [NSString stringWithFormat:kXMLRegisterUser,
//             pUserName,pPassword,pDeviceId,pEmailAddress,pPin],
//            kXMLSoapFooter];
//}
//
+ (NSString *) login:(NSString *)pMessage
{
    return kSOAPBody(Login, @"", pMessage);
//    return [NSString stringWithFormat:kXMLFORMAT, kXMLSoapHeader,kXMLLogin,kFORMATTEDSOAPFOOTER];
}

//+ (NSString *) getUserProfile:(NSString *)pUserName
//{
//    return [NSString stringWithFormat:kXMLFORMAT, kXMLSoapHeader,[NSString stringWithFormat:kXMLGetUserProfile, pUserName],kXMLSoapFooter];
//}

//+ (NSString *) setUserProfile:(UserData *)pUserData
//{
//    return [NSString stringWithFormat:kXMLFORMAT, kXMLSoapHeader,
//            [NSString stringWithFormat:kXMLSetUserProfile,
//             [pUserData quote],[pUserData nationality],[pUserData eMail],
//             [ZSCommon boolToString:[pUserData robotHumanSwap]],
//             [ZSCommon boolToString:[pUserData onlineNotification]],
//             [pUserData ownRating],
////             ([pUserData avatarEmpty] ? @"delete=\"true\"" : [NSString stringWithFormat:@"filename = \"%@.png\"",[[pUserData credentials] userName]]),
////             ([pUserData avatarEmpty] ? @"" : [ZLBase64 encode:[[UIBitmapImageRep imageRepWithData:[[pUserData avatar] TIFFRepresentation]] representationUsingType:NSPNGFileType properties:nil]]),
//             [ZSCommon boolToString:[pUserData bidSysSAYC]],
//             [ZSCommon boolToString:[pUserData bidSys21]],
//             [ZSCommon boolToString:[pUserData bidSysPrecision]],
//             [ZSCommon boolToString:[pUserData bidSysAcol]]
//             ],
//            kXMLSoapFooter];
//}

// pLobbiesWithSerials is an array of array of two strings. Lobby id and related last serial

//+ (NSString *) get:(NSArray *)pLobbiesWithSerials privateSerial:(NSString *) pPrivateSerial
//{
//    NSString * lobbyList = @"";
//    
//    for ( NSArray * lobby in pLobbiesWithSerials )
//    {
//        lobbyList = [lobbyList stringByAppendingString:[NSString stringWithFormat:kXMLGetLobbbyLine,[lobby objectAtIndex:1],[lobby objectAtIndex:1]]];
//    }
//    
//    return [NSString stringWithFormat:kXMLFORMAT, kXMLSoapHeader,
//            [NSString stringWithFormat:kXMLGet,lobbyList,pPrivateSerial ],
//            kXMLSoapFooter];
//}


@end
