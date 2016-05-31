//
//  MSServerPrivate.h
//  zschat
//
//  Created by Zsolt Laky on 2014. 12. 05..
//  Copyright (c) 2014. Zsolt Laky. All rights reserved.
//

#ifndef zschat_MSPrivate_h
#define zschat_MSPrivate_h

#import "MServer.h"
#import "MJSONParsers.h"
#import "MJSONRequestBuilder.h"

#define DEFAULTWSTIMEOUT            20.0
#define DEFAULTGETTIMEOUT           60.0

#define	kUSER_USERKEY				@"userobject"
#define kCONTENTTYPEHEADERFIELD     @"Content-Type"
#define kCONTENTTYPE                @"application/json"
#define kCACHECONTROLHEADERFIELD    @"Cache-Control"
#define kCACHECONTROL               @"no-cache"
#define kAUTHORISATIONHEADERFIELD   @"Authorization"
#define kCLIENTIDHEADERFIELD        @"Client-Id"
#define kCLIENTID                   @"clientid"
#define kAPPLICATIONNAMEHEADERFIELD @"Application-name"
#define kUNDEFINED                  @"undefined"
#define kMODULENAME                 @"MSModule"
#define kMSGSERIALHEADERFIELD       @"Message-number"
//#define kUSERAPPLOGINCOMMAND        @"Logincommand"
#define kUSERMD5PASSWORD            @"md5password"
#define kUSERAUTHORISATIONSTRING    @"authorisationstring"

@interface MServer ()
enum errorKeys {
    e_Error,
    e_ErrorWithObject
};

+ (id) MError:(NSString *)errormsg withCode:(NSInteger)code withString:(NSString *)errorString;
+ (id) MError:(NSString *)errormsg withCode:(NSInteger)code withObject:(NSObject *)errorObject;
@property (strong,nonatomic) NSOperationQueue * webServiceQueue;
@property (strong,nonatomic) MJSONParsers * JSONParsers;
@property (strong,nonatomic) MJSONRequestBuilder * JSONRequestBuilder;
@end

#endif
