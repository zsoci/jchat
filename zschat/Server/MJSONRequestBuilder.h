//
//  MJSONRequestBuilder.h
//  jchat
//
//  Created by Zsolt Laky on 5/31/16.
//  Copyright © 2016 Zsolt Laky. All rights reserved.
//

#ifndef MJSONRequestBuilder_h
#define MJSONRequestBuilder_h

#import <Foundation/Foundation.h>

#define kPOST @"POST"
#define kGET @"GET"
#define kPUT @"PUT"

@interface MJSONRequestBuilder : NSObject
{
}

@property (nonatomic) NSString * host;
@property (nonatomic) NSInteger port;
@property (nonatomic) NSString * moduleName;
@property (nonatomic) NSString * requestedURLString;

- (void) setConnetionToHost:(NSString *)pHost withPort:(NSInteger) pPort;
- (void) setHeaderFieldForKey:(NSString *)pField withValue:(NSString *)pValue;
- (NSString *) getHeaderFiledForKey:(NSString *)pField;
- (void) deleteHeaderFiledForKey:(NSString *)pField;
- (NSURLRequest *) createJSONRequest:(NSString *)pPath method:(NSString *)pMethod withData:(NSString *)pPostData;
- (NSURLRequest *) createJSONRequest:(NSString *)pPath method:(NSString *)pMethod withData:(NSString *)pPostData withTimeout:(NSTimeInterval) pTimeout;
@end


#endif /* MJSONRequestBuilder_h */
