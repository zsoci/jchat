//
//  ZLGlobals.m
//  BridgeIsland
//
//  Created by Zsolt Laky on 2012.01.14..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MServer.h"
#import "MServerPrivate.h"
#import "MHTTPRequestBuilder.h"
#import "MSoapXMLBuilder.h"
#import "MXMLParsers.h"
#import "MWSWorker.h"
//#import "MSoapXMLBuilder.h"

#import "MBase64.h"
#import "ZSMsgView.h"
#import "utilities.h"

@interface MServer (PrivateMethods)
@end

static MServer * mserver = nil;
//static NSMutableDictionary * muser = nil;

@implementation MServer
@synthesize HTTPRequestBuilder;
@synthesize webServiceQueue;
@synthesize user;
@synthesize XMLParsers;

NSString *const MServerErrorDomain = @"MultiServerErrorDomain";

//MSSoapXMLBuilder * soapXMLBuilder;
//+(NSOperationQueue *) webServiceQueue
//{
//    return webServiceQueue;
//}

//+ (void) waitForOperationsToFinish
//{
//    [[[MServer getServer] webServiceQueue] waitUntilAllOperationsAreFinished];
//}

+(NSMutableDictionary *)getUser
{
    return [[MServer getServer] user];
}

+(NSMutableDictionary *)getAppUserData
{
    return [[MServer getServer] user][USER_APPUSERDATA];
}

+(MServer *) getServer
{
    if (!mserver)
    {
        mserver = [[MServer alloc] init];
//        mserver.user = [[NSMutableDictionary alloc] init];
        NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];

        mserver.user = [[NSMutableDictionary alloc] initWithDictionary:[defaults objectForKey:kUSER_USERKEY]];
        if (!mserver.user) {
           mserver.user = [[NSMutableDictionary alloc] init];
 //           mserver.user[kUSERAPPLOGINCOMMAND] = @"";
            mserver.user[USER_APPUSERDATA] = [[NSMutableDictionary alloc] init];
            [[mserver HTTPRequestBuilder] setHeaderFieldForKey:kCONTENTTYPEHEADERFIELD withValue:kCONTENTTYPE];
            [[mserver HTTPRequestBuilder] setHeaderFieldForKey:kCACHECONTROLHEADERFIELD withValue:kCACHECONTROL];
            [[mserver HTTPRequestBuilder] setHeaderFieldForKey:kCLIENTIDHEADERFIELD withValue:mserver.user[kCLIENTID] ];
            [[mserver HTTPRequestBuilder] setHeaderFieldForKey:kAPPLICATIONNAMEHEADERFIELD withValue:kUNDEFINED];
            [[mserver HTTPRequestBuilder] setHeaderFieldForKey:kMSGSERIALHEADERFIELD withValue:@"0"];
        }
    }
    return mserver;
}
+ (id) getWSResult:(id)anObject
{
    return [anObject wsresult];
}

+ (void) saveUserdefaults
{
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:[MServer getUser] forKey:kUSER_USERKEY];
}

+ (void) getLoginResponse:(id)aObject
{
    id anObject = [aObject wsresult];
    if ([anObject isKindOfClass:[NSError class]])
    { // Login did not succeeded
        [MServer getUser][USER_ONLINE] = @"NO";
        NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:[MServer getUser] forKey:kUSER_USERKEY];
    }
    else
    {
//        UserData * data = anObject;
//        [[[[ZSAppDelegate shared] appGlobals] userData] setAvatar:[data avatar]];
//        [[[[ZSAppDelegate shared] appGlobals] userData] setExpireTime:[data expireTime]];
//        [(ZSRootViewController *)self.parentViewController swapViewController:self toController:@"MainMenuView" duration:VIEWTRANSITIONDURATION options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionTransitionFlipFromLeft completion:nil];
//        [[[[ZSAppDelegate shared] appGlobals] rootWindow] runGet];
    }
    
}

+ (id) GetMessages:(NSString *)pMessage messageNr:(NSNumber *)messageNr onDelegate:(id)pId onSelector:(SEL)pSelector;
{
    return [self Request:@"FetchMessages" withData:kSOAPBody(FetchMessages,kXMLFetchMessagesBody(messageNr),pMessage) onDelegate:pId onSelector:pSelector withTimeOut:DEFAULTGETTIMEOUT];
}
//return [self Request:@"Login" withData:kSOAPBody(Login, @"", pMessage) onDelegate:pId onSelector:pSelector withTimeOut:pTimeout];

+ (void) setup:(NSString *)pHost withPort:(NSInteger) pPort withApp:(NSString *)application
{
    [MServer getUser][USER_DEFAULTSERVERIP] = pHost;
    [MServer getUser][USER_DEFAULTSERVERPORT] = [NSNumber numberWithInteger:pPort];
    [[mserver HTTPRequestBuilder] setConnetionToHost:pHost withPort:pPort];
    [[mserver HTTPRequestBuilder] setHeaderFieldForKey:kAPPLICATIONNAMEHEADERFIELD withValue:application];
    [[mserver HTTPRequestBuilder] setHeaderFieldForKey:kAUTHORISATIONHEADERFIELD withValue:[MServer getUser][kUSERAUTHORISATIONSTRING]];
    [[mserver HTTPRequestBuilder] setHeaderFieldForKey:kCONTENTTYPEHEADERFIELD withValue:kCONTENTTYPE];
    [[mserver HTTPRequestBuilder] setHeaderFieldForKey:kCACHECONTROLHEADERFIELD withValue:kCACHECONTROL];
    [[mserver HTTPRequestBuilder] setHeaderFieldForKey:kCLIENTIDHEADERFIELD withValue:[MServer getUser][kCLIENTID]];
    [[mserver HTTPRequestBuilder] setHeaderFieldForKey:kMSGSERIALHEADERFIELD withValue:@"0"];
    if ([MServer getUser][USER_MSGSERIAL] == nil) [MServer getUser][USER_MSGSERIAL] = [[NSNumber alloc] initWithLongLong:0];
}

+ (void) setupUserMail:(NSString *)userMail
{
    [MServer getUser][USER_EMAIL] = userMail;
}

+ (void) setupUser:(NSString *)pUserName password:(NSString *)pPassword
{
    NSMutableDictionary * muser = [MServer getUser];
    muser[USER_USERNAME] = pUserName;
    muser[USER_PASSWORD] = pPassword;
    muser[kUSERMD5PASSWORD] = MD5StringOfString(pPassword);
    muser[kUSERAUTHORISATIONSTRING] = [MBase64 encodeStr:[NSString stringWithFormat:@"%@:%@",pUserName,muser[kUSERMD5PASSWORD]]];
    [[mserver HTTPRequestBuilder] setHeaderFieldForKey:kAUTHORISATIONHEADERFIELD withValue:muser[kUSERAUTHORISATIONSTRING]];
    [mserver setUser:muser];
}

-(MServer *)init
{
    if (mserver) {
        return mserver;
    }
    if (![super init]) return nil;
    mserver = self;
    mserver.webServiceQueue = [[NSOperationQueue alloc] init];
//    [mserver setWebServiceQueue:[[NSOperationQueue alloc] init]];
    [webServiceQueue setMaxConcurrentOperationCount:2];
    [MBase64 initialize];
    [mserver setHTTPRequestBuilder:[[MHTTPRequestBuilder alloc] init]];
    [[mserver HTTPRequestBuilder] setModuleName:kMODULENAME];
//    [[mserver HTTPRequestBuilder] setConnetionToHost:DEFAULTHOST withPort:DEFAULTPORT];
    [mserver setXMLParsers:[[MXMLParsers alloc] init]];
	return mserver;
}

+ (id) Login:(NSString *)pMessage onDelegate:(id)pId onSelector:(SEL)pSelector
{
    return [self Login:pMessage onDelegate:pId onSelector:pSelector withTimeout:DEFAULTWSTIMEOUT];
}

+ (id) Login:(NSString *)pMessage onDelegate:(id)pId onSelector:(SEL)pSelector withTimeout:(NSTimeInterval)pTimeout
{
    return [self Request:@"Login" withData:kSOAPBody(Login, @"", pMessage) onDelegate:pId onSelector:pSelector withTimeOut:pTimeout];
}

+ (id) SaveUserProfile:(NSString *)pMessage onDelegate:(id)pId onSelector:(SEL)pSelector
{
    return [self SaveUserProfile:pMessage onDelegate:pId onSelector:pSelector withTimeout:DEFAULTWSTIMEOUT];
}

+ (id) SaveUserProfile:(NSString *)pMessage onDelegate:(id)pId onSelector:(SEL)pSelector withTimeout:(NSTimeInterval)pTimeout
{
    NSLog(@"AVATAR:%@",[MServer getUser][USER_AVATAR]);
    return [self Request:@"SaveUserProfile" withData:kSOAPBody(SaveUserProfile,
                                                               kXMLSaveUserProfileBody(([MServer getUser][USER_EMAIL]),
                                                                                       ([MServer getUser][USER_AVATAR])),
                                                               pMessage) onDelegate:pId onSelector:pSelector withTimeOut:pTimeout];
}

+ (id) Register:(NSString *)pMessage onDelegate:(id)pId onSelector:(SEL)pSelector
{
   [MServer getUser][kCLIENTID] = @"0";
   [[mserver HTTPRequestBuilder] setHeaderFieldForKey:kCLIENTIDHEADERFIELD withValue:[MServer getUser][kCLIENTID]];
   return [self Register:pMessage onDelegate:pId onSelector:pSelector withTimeout:DEFAULTWSTIMEOUT];
}

+ (id) Register:(NSString *)pMessage onDelegate:(id)pId onSelector:(SEL)pSelector withTimeout:(NSTimeInterval)pTimeout
{
    return [self Request:@"Register" withData:kSOAPBody(Register, kXMLRegisterBody(([MServer getUser][USER_EMAIL])), pMessage) onDelegate:pId onSelector:pSelector withTimeOut:pTimeout];
}

+ (id) Request:(NSString *)pSoapFunction withData:(NSString *)pMessage onDelegate:(id)pId onSelector:(SEL)pSelector
{
    return [self Request:pSoapFunction withData:pMessage onDelegate:pId onSelector:pSelector withTimeOut:DEFAULTWSTIMEOUT];
}

+ (id) Request:(NSString *)pSoapFunction withData:(NSString *)pMessage onDelegate:(id)pId onSelector:(SEL)pSelector withTimeOut:(NSTimeInterval)pTimeout
{
    NSURLRequest *request = [[mserver HTTPRequestBuilder] createHTTPSoapRequest:pSoapFunction withData:pMessage withTimeout:pTimeout];
    NSLog(@"Soap body to be sent:%@",pMessage);
    MWSWorker * worker = [[MWSWorker alloc] initMWSWorker:request onDelegate:pId onThread:[NSThread currentThread] onSelector:pSelector];
    return worker;
}

+ (id) MError:(NSString *)errormsg withCode:(NSInteger)code withString:(NSString *)errorString
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:errormsg forKey:NSLocalizedDescriptionKey];
    [userInfo setObject:errorString forKey:NSLocalizedFailureReasonErrorKey];
    return [NSError errorWithDomain:MServerErrorDomain code:code userInfo:userInfo];
    
}

+ (id) MError:(NSString *)errormsg withCode:(NSInteger) code withObject:(NSObject *)errorObject
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:errorObject forKey:NSUnderlyingErrorKey];
    [userInfo setObject:errormsg forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:MServerErrorDomain code:code userInfo:userInfo];
}


@end