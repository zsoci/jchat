//
//  ZLXMLParsers.m
//  BridgeIsland
//
//  Created by Zsolt Laky on 2012.01.28..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MXMLParsers.h"
#import "SMXMLDocument.h"
#import "MMessage.h"
#import "MBase64.h"
#import "Common.h"
#import "MServer.h"
#import "MServerPrivate.h"
#import "UIKit/uikit.h"

@implementation MXMLParsers

+ (id) GetIPResponse:(NSArray *)nodes
{
    MsgGetIP * retVal = [[MsgGetIP alloc] init];
    for (SMXMLElement * node in nodes)
    {
        SETSTRNODEVALUE(@"sIP", retVal setHostIP)
        SETINTNODEVALUE(@"nPort", retVal setHostPort)
        SETINTNODEVALUE(@"GetIPResult", retVal setWsResult)
        NSLog(NODE_NOT_PROCESSED,[node name]);
    }
    return retVal;
}

+ (id) LoginResponse:(NSArray *)nodes
{
    id retVal = nil;
    NSArray * appMessage;
    NSString * responseResult;
    NSString * sText = @"Service is not implemented yet";
    
    for (SMXMLElement * node in nodes)
    {
        if ([@"sCode" ISNODENAME]) responseResult = [node value];
        else if ([@"sAppResponse" ISNODENAME]) appMessage = [node children];
        else if ([@"sText" ISNODENAME]) sText = [node value];
        else if ([@"sEMail" ISNODENAME]) [MServer getUser][USER_EMAIL] = [node value];
        else if ([@"sNationality" ISNODENAME]) [MServer getUser][USER_NATIONALITY] = [node value];
        else if ([@"sAvatar" ISNODENAME])
        {
            if ([node value])
                [MServer getUser][USER_AVATAR] = [node value];
        }
        else if ([@"nClientId" ISNODENAME])
        {
            [MServer getUser][kCLIENTID] = [node value];
            [[[MServer getServer  ]HTTPRequestBuilder] setHeaderFieldForKey:kCLIENTIDHEADERFIELD withValue:[node value]];
        }
        else NSLog(NODE_NOT_PROCESSED,[node name]);
    }
    if ([@"eLI_LoginOk" isEqualToString:responseResult])
    {
        retVal = appMessage;
        [MServer getUser][USER_ONLINE] = @"YES";
    }
    else
    {
        [MServer getUser][USER_ONLINE] = @"NO";
        if ([@"eLI_LoginUnsucc" isEqualToString:responseResult]) retVal = [MServer MError:@"Login Failed" withCode:e_Error withString:@"Invalid User name or password"];
        else retVal = [MServer MError:@"Login failed" withCode:e_Error withString:sText];
    }
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:[MServer getUser] forKey:kUSER_USERKEY];
    return retVal;
}

+ (id) RegisterUserResponse:(NSArray *)nodes;
{
    id retVal = nil;
    //    UserData * pUserData = [[UserData alloc] init];
    NSArray * appMessage;
    NSString * responseResult;
    NSString * sText = @"General error ";
    //
    for (SMXMLElement * node in nodes)
    {
        if ([@"sCode" ISNODENAME]) responseResult = [node value];
        else if ([@"sAppResponse" ISNODENAME]) appMessage = [node children];
        else if ([@"sText" ISNODENAME]) sText = [node value];
        else if ([@"sEMail" ISNODENAME]) [MServer getUser][USER_EMAIL] = [node value];
        else if ([@"sNationality" ISNODENAME]) [MServer getUser][USER_NATIONALITY] = [node value];
        else if ([@"sAvatar" ISNODENAME])
        {
            if ([node value])
                [MServer getUser][USER_AVATAR] = [node value];
        }
        else if ([@"nClientId" ISNODENAME]) {
            [MServer getUser][kCLIENTID] = [node value];
            [[[MServer getServer  ]HTTPRequestBuilder] setHeaderFieldForKey:kCLIENTIDHEADERFIELD withValue:[node value]];
        }
        else NSLog(NODE_NOT_PROCESSED,[node name]);
    }
    if ([@"eRU_UserRegOK" isEqualToString:responseResult])
    {
        retVal = appMessage;
        [MServer getUser][USER_ONLINE] = @"YES";
    }
    else
    {
        [MServer getUser][USER_ONLINE] = @"NO";
        if ([@"eRU_UserIDReserved" isEqualToString:responseResult])
            retVal = [MServer MError:@"Registration Failed" withCode:e_Error withString:@"User name already exists"];
        else retVal = [MServer MError:@"Registration failed" withCode:e_Error withString:sText];
    }
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:[MServer getUser] forKey:kUSER_USERKEY];
    return retVal;
}
+ (id) FetchMessagesResponse:(NSArray *)nodes;
{
    id retVal = nil;
    //    UserData * pUserData = [[UserData alloc] init];
    NSArray * appMessage;
    NSString * responseResult;
    NSString * sText = @"General error ";
    //
    for (SMXMLElement * node in nodes)
    {
        if ([@"sCode" ISNODENAME]) responseResult = [node value];
        else if ([@"sAppResponse" ISNODENAME]) appMessage = [node children];
        else if ([@"sText" ISNODENAME]) sText = [node value];
        else NSLog(NODE_NOT_PROCESSED,[node name]);
    }
    if ([@"e_OK" isEqualToString:responseResult])
    {
        retVal = appMessage;
    }
    else
    {
        retVal = [MServer MError:@"Error" withCode:e_Error withString:sText];
    }
//    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
//    [defaults setObject:[MServer getUser] forKey:kUSER_USERKEY];
    return retVal;
}

//+ (void) fillUserProfileFromXMLNode:(NSXMLNode *)pNode toData:(UserData *)pUserData
//{
//    NSArray * nodes = [pNode children];
//    NSInteger i;
//    
//    [pUserData setAvatarChanged:NO];
//    [pUserData setAvatar:nil];
//    [pUserData setAvatarEmpty:YES];
//    
//    for (i=0; i<[nodes count]; i++)
//    {
//        NSXMLNode * node = [ nodes objectAtIndex:i];
//        
//        SETSTRNODEVALUEE(@"sUsername", pUserData setUserName)
//        if ([@"sAvatar" ISNODENAME])
//        {
//            [pUserData setAvatar:[[[NSImage alloc] initWithData:[ZLBase64 decode:[node stringValue]]] autorelease]];
//            [pUserData setAvatarEmpty:(nil == [pUserData avatar])];
//            NSLog(@"Avatar %f:%f",pUserData.avatar.size.width,pUserData.avatar.size.height);
//        }    
//        else
//        SETSTRNODEVALUEE(@"sNationality", pUserData setNationality)
//        SETINTNODEVALUEE(@"nBI", pUserData setRatingBI)
//        SETINTNODEVALUEE(@"nMP", pUserData setRatingMP)
//        SETINTNODEVALUEE(@"nIMP", pUserData setRatingIMP)
//        SETSTRNODEVALUEE(@"sEMail", pUserData setEMail)
//        SETSTRNODEVALUEE(@"sQuote",  pUserData setQuote)
//        SETSTRNODEVALUEE(@"sPlayerRate", pUserData setOwnRating)
//        SETBOOLNODEVALUEE(@"nRobotHumanSwapEnabled", pUserData setRobotHumanSwap)
//        SETBOOLNODEVALUEE(@"nOnlineNotificationEnabled",pUserData setOnlineNotification)
//        if ([@"sBiddingSystem" ISNODENAME])
//        {
//            NSArray * bidNodes = [node children];
//            NSInteger j;
//            
//            for (j=0; j<[bidNodes count] ; j++)
//            {
//                NSXMLElement * node = [bidNodes objectAtIndex:j];
//                
//                if ([@"sBidSys" ISNODENAME])
//                {
//                    NSString * sysName = [[node attributeForName:@"type"] stringValue];
//                    
//                    if ([@"eBS_SAYC" isEqualToString:sysName]) [pUserData setBidSysSAYC:[[node stringValue] boolValue]]; else
//                    if ([@"eBS_21" isEqualToString:sysName]) [pUserData setBidSys21:[[node stringValue] boolValue]]; else
//                    if ([@"eBS_Precision" isEqualToString:sysName]) [pUserData setBidSysPrecision:[[node stringValue] boolValue]]; else
//                    if ([@"eBS_Acol" isEqualToString:sysName]) [pUserData setBidSysAcol:[[node stringValue] boolValue]]; else
//                    NSLog(NODE_NOT_PROCESSED,[node name]);
//                }
//                else NSLog(NODE_NOT_PROCESSED,[node name]);
//            }
//        }
//        else NSLog(NODE_NOT_PROCESSED,[node name]);
//    }
//    [pUserData setMySelf:[[pUserData userName] isEqualToString:[[pUserData credentials] userName]]];
//    if ([@"zsoci" isEqualToString:[pUserData userName]]) {
//        [pUserData setSysAdmin:YES];
//    }
//    else [pUserData setSysAdmin:NO];
//}

//+ (bool) userProfileResponseXML:(NSObject *)pDoc toData:(UserData *)pUserData
//{
//    NSArray *   nodes = [ZLCommon getXMLNodesFromDoc:(NSXMLDocument*)pDoc forKey:@"GetUserProfileResponse"];
//    
//    NSString *  responseResult;
//    bool        retVal = NO;
//    int i;
//
//    for (i = 0; i < [nodes count]; i++)
//    {
//        NSXMLNode * node = [nodes objectAtIndex:i];
//        if ([@"sCode" ISNODENAME]) responseResult = [node stringValue]; else
//        if ([@"sProfile" ISNODENAME]) [self fillUserProfileFromXMLNode:node toData:pUserData]; else
//        NODENOTPROCESSED
//    }
//    if ([@"eGUP_Ok" isEqualToString:responseResult]) retVal = YES;
//    return retVal;
//}
@end
