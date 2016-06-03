//
//  ZLGlobals.m
//  BridgeIsland
//
//  Created by Zsolt Laky on 2012.01.14..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MServer.h"
#import "MServerPrivate.h"
#import "MJSONRequestBuilder.h"
#import "MJSONParsers.h"
#import "MWSWorker.h"

#import "MBase64.h"
#import "ZSMsgView.h"
#import "utilities.h"

@interface MServer (PrivateMethods)
@end

static MServer * mserver = nil;
//static NSMutableDictionary * muser = nil;

@implementation MServer
@synthesize JSONRequestBuilder;
@synthesize webServiceQueue;
@synthesize user;
@synthesize JSONParsers;

NSString *const MServerErrorDomain = @"MultiServerErrorDomain";

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
            [[mserver JSONRequestBuilder] setHeaderFieldForKey:kCONTENTTYPEHEADERFIELD withValue:kCONTENTTYPE];
            [[mserver JSONRequestBuilder] setHeaderFieldForKey:kCACHECONTROLHEADERFIELD withValue:kCACHECONTROL];
            [[mserver JSONRequestBuilder] setHeaderFieldForKey:kCLIENTIDHEADERFIELD withValue:mserver.user[kCLIENTID] ];
            [[mserver JSONRequestBuilder] setHeaderFieldForKey:kAPPLICATIONNAMEHEADERFIELD withValue:kUNDEFINED];
            [[mserver JSONRequestBuilder] setHeaderFieldForKey:kMSGSERIALHEADERFIELD withValue:@"0"];
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
    }
}

+ (id) GetMessages:(id)pId onSelector:(SEL)pSelector;
{
    return [self GetMessages:[self getUser][USER_MSGSERIAL] onDelegate:pId onSelector:pSelector];
}

+ (id) GetMessages:(NSNumber *)messageNr onDelegate:(id)pId onSelector:(SEL)pSelector;
{
    NSString * URL = [NSString stringWithFormat:@"/v1/message/get?serial=%@", messageNr];
    return [self Request:URL method:kGET withData:@"" onDelegate:pId onSelector:pSelector withTimeOut:DEFAULTGETTIMEOUT jsonParserClass:[[MServer getServer] JSONParsers] jsonParserFunc:@"FetchMessageResponse"];
}

+ (void) setup:(NSString *)pHost withPort:(NSInteger) pPort withApp:(NSString *)application
{
    [MServer getUser][USER_DEFAULTSERVERIP] = pHost;
    [MServer getUser][USER_DEFAULTSERVERPORT] = [NSNumber numberWithInteger:pPort];
    [[mserver JSONRequestBuilder] setConnetionToHost:pHost withPort:pPort];
    [[mserver JSONRequestBuilder] setHeaderFieldForKey:kAPPLICATIONNAMEHEADERFIELD withValue:application];
    [[mserver JSONRequestBuilder] setHeaderFieldForKey:kAUTHORISATIONHEADERFIELD withValue:[MServer getUser][kUSERAUTHORISATIONSTRING]];
    [[mserver JSONRequestBuilder] setHeaderFieldForKey:kCONTENTTYPEHEADERFIELD withValue:kCONTENTTYPE];
    [[mserver JSONRequestBuilder] setHeaderFieldForKey:kCACHECONTROLHEADERFIELD withValue:kCACHECONTROL];
    [[mserver JSONRequestBuilder] setHeaderFieldForKey:kCLIENTIDHEADERFIELD withValue:[MServer getUser][kCLIENTID]];
    [[mserver JSONRequestBuilder] setHeaderFieldForKey:kMSGSERIALHEADERFIELD withValue:@"0"];
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
    [[mserver JSONRequestBuilder] setHeaderFieldForKey:kAUTHORISATIONHEADERFIELD withValue:muser[kUSERAUTHORISATIONSTRING]];
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
    [webServiceQueue setMaxConcurrentOperationCount:2];
    [MBase64 initialize];
    [mserver setJSONRequestBuilder:[[MJSONRequestBuilder alloc] init]];
    [[mserver JSONRequestBuilder] setModuleName:kMODULENAME];
    [mserver setJSONParsers:[[MJSONParsers alloc] init]];
	return mserver;
}

+ (id) Login:(NSString *)pMessage onDelegate:(id)pId onSelector:(SEL)pSelector
{
    return [self Login:pMessage onDelegate:pId onSelector:pSelector withTimeout:DEFAULTWSTIMEOUT];
}

+ (id) Login:(NSString *)pMessage onDelegate:(id)pId onSelector:(SEL)pSelector withTimeout:(NSTimeInterval)pTimeout
{
    return [self Request: @"/v1/auth/priv/login"
                  method: kPOST
                withData: kLoginBody(([MServer getUser][USER_USERNAME]),
                                     ([MServer getUser][USER_PASSWORD]),
                                     pMessage)
              onDelegate: pId
              onSelector: pSelector
             withTimeOut: pTimeout
         jsonParserClass: [[MServer getServer] JSONParsers]
          jsonParserFunc: @"LoginResponse"];
}

+ (id) SaveUserProfile:(NSString *)pMessage onDelegate:(id)pId onSelector:(SEL)pSelector
{
    return [self SaveUserProfile:pMessage onDelegate:pId onSelector:pSelector withTimeout:DEFAULTWSTIMEOUT];
}

+ (id) SaveUserProfile:(NSString *)pMessage onDelegate:(id)pId onSelector:(SEL)pSelector withTimeout:(NSTimeInterval)pTimeout
{
    NSLog(@"AVATAR:%@",[MServer getUser][USER_AVATAR]);
    return [self Request:@"/v1/members/saveprofile"
                  method:kPOST
                withData:kSaveUserProfileBody(pMessage)
              onDelegate:pId
              onSelector:pSelector
             withTimeOut:pTimeout
            jsonParserClass:nil
          jsonParserFunc:@""];
}

+ (id) Register:(NSString *)pMessage onDelegate:(id)pId onSelector:(SEL)pSelector
{
   [MServer getUser][kCLIENTID] = @"0";
   [[mserver JSONRequestBuilder] setHeaderFieldForKey:kCLIENTIDHEADERFIELD withValue:[MServer getUser][kCLIENTID]];
   return [self Register:pMessage onDelegate:pId onSelector:pSelector withTimeout:DEFAULTWSTIMEOUT];
}

+ (id) Register:(NSString *)pMessage onDelegate:(id)pId onSelector:(SEL)pSelector withTimeout:(NSTimeInterval)pTimeout
{
    return [self Request: @"/v1/auth/priv/register"
                  method: kPOST
                withData: kRegisterBody(([MServer getUser][USER_USERNAME]),
                                        ([MServer getUser][USER_PASSWORD]),
                                        ([MServer getUser][USER_EMAIL]),
                                        pMessage)
              onDelegate: pId
              onSelector: pSelector
             withTimeOut: pTimeout
         jsonParserClass: [[MServer getServer] JSONParsers]
          jsonParserFunc: @"RegisterResponse"];}

+ (id) Request:(NSString *)pPath method:(NSString *)pMethod withData:(NSString *)pMessage onDelegate:(id)pId onSelector:(SEL)pSelector
{
    return [self Request:pPath method:pMethod withData:pMessage onDelegate:pId onSelector:pSelector withTimeOut:DEFAULTWSTIMEOUT jsonParserClass:nil jsonParserFunc:nil];
}

+ (id) Request:(NSString *)pPath method:(NSString *)pMethod withData:(NSString *)pMessage onDelegate:(id)pId onSelector:(SEL)pSelector withTimeOut:(NSTimeInterval)pTimeout jsonParserClass:(id)iJsonParserClass jsonParserFunc:(NSString *)pJsonParserFunc
{
    NSURLRequest *request = [[mserver JSONRequestBuilder] createJSONRequest:pPath method:pMethod withData:pMessage withTimeout:pTimeout];
    MWSWorker * worker = [[MWSWorker alloc] initMWSWorker:request onDelegate:pId onThread:[NSThread currentThread] onSelector:pSelector jsonParserFunc:pJsonParserFunc];
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
