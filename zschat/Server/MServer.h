//
//  ZLGlobals.h
//  BridgeIsland
//
//  Created by Zsolt Laky on 2012.01.14..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define GLOBALSPEEDFACTOR           1.0
#define VIEWTRANSITIONDURATION      (GLOBALSPEEDFACTOR * 0.5)

#define USER_MSGSERIAL                      @"MessageNr"
//#define		USER_CLASS_NAME					@"_User"				//	Class name
#define		USER_USERNAME					@"username"				//	String
#define		USER_PASSWORD					@"password"				//	String
//#define     USER_MD5PASSWORD                @"md5password"
//#define     USER_AUTHORISATIONSTRING        @"authorisationstring"
//#define     USER_APPLICATION                @"application"
//#define     USER_CLIENTID                   @"clientid"
#define     USER_DEFAULTSERVERIP            @"defaultserverip"
#define     USER_DEFAULTSERVERPORT          @"defaultserverport"
//#define     USER_SERVERIP                   @"serverip"
//#define     USER_SERVERPORT                 @"serverport"
#define		USER_EMAIL						@"email"				//	String
//#define		USER_EMAILCOPY					@"emailCopy"			//	String
#define     USER_NICKNAME                   @"nickname"
//#define		USER_FULLNAME					@"fullname"				//	String
//#define		USER_FULLNAME_LOWER				@"fullname_lower"		//	String
//#define		USER_FACEBOOKID					@"facebookId"			//	String
#define		USER_AVATAR                     @"avatar"				//	File
//#define		USER_THUMBNAIL					@"thumbnail"			//	File
#define     USER_ONLINE                     @"online"
#define     USER_NATIONALITY                @"nationality"
//#define     USER_APPLOGINMESSAGE            @"loginmessage"
#define     USER_APPUSERDATA                @"appuserdata"

#import <Foundation/Foundation.h>

@interface MServer : NSObject {}
+ (MServer *)getServer;
+ (NSMutableDictionary *)getUser;
+ (NSMutableDictionary *)getAppUserData;
//+ (void) waitForOperationsToFinish;
+ (void) saveUserdefaults;
+ (id) getWSResult:(id)anObject;
+ (void) setup:(NSString *)pHost withPort:(NSInteger) pPort withApp:(NSString *)application;
+ (void) setupUser:(NSString *)userName password:(NSString *)password;
+ (void) setupUserMail:(NSString*)userMail;
//+ (id) GetMessages:(NSString *)pMessage messageNr:(NSNumber *)messageNr onDelegate:(id)pId onSelector:(SEL)pSelector;
+ (id) Login:(NSString *)pMessage onDelegate:(id)pId onSelector:(SEL)pSelector;
+ (id) Login:(NSString *)pMessage onDelegate:(id)pId onSelector:(SEL)pSelector withTimeout:(NSTimeInterval)pTimeout;
//+ (id) SaveUserProfile:(NSString *)pMessage onDelegate:(id)pId onSelector:(SEL)pSelector;
//+ (id) SaveUserProfile:(NSString *)pMessage onDelegate:(id)pId onSelector:(SEL)pSelector withTimeout:(NSTimeInterval)pTimeout;
+ (id) Register:(NSString *)pMessage onDelegate:(id)pId onSelector:(SEL)pSelector;
+ (id) Register:(NSString *)pMessage onDelegate:(id)pId onSelector:(SEL)pSelector withTimeout:(NSTimeInterval)pTimeout;
+ (id) Request:(NSString *)pPath method:(NSString *)pMethod withData:(NSString *)pMessage onDelegate:(id)pId onSelector:(SEL)pSelector;
+ (id) Request:(NSString *)pPath method:(NSString *)pMethod withData:(NSString *)pMessage onDelegate:(id)pId onSelector:(SEL)pSelector withTimeOut:(NSTimeInterval)pTimeout jsonParserClass:(id)iJsonParserClass jsonParserFunc:(NSString *)pJsonParserFunc;
//+ (idMWSWorker *) launchHTTPRequest:(NSString *)pRequest withData:(NSString *)pData onDelegate:(id)pId onSelector:(SEL)pSelector withTimeout:(NSTimeInterval)pTimeout;
@property (strong,nonatomic) NSMutableDictionary * user;
@end
