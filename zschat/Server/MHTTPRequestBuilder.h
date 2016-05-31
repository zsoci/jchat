//
//  ZLHTTPRequestBuilder.h
//  BridgeIsland
//
//  Created by Zsolt Laky on 2012.01.14..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHTTPRequestBuilder : NSObject
{
}

@property (nonatomic) NSString * host;
@property (nonatomic) NSInteger port;
@property (nonatomic) NSString * moduleName;
@property (nonatomic) NSString * requestedURLString;

//- (NSString *)host;
//- (NSInteger)port;
- (void) setConnetionToHost:(NSString *)pHost withPort:(NSInteger) pPort;
- (void) setHeaderFieldForKey:(NSString *)pField withValue:(NSString *)pValue;
- (NSString *) getHeaderFiledForKey:(NSString *)pField;
- (void) deleteHeaderFiledForKey:(NSString *)pField;
//- (NSURLRequest *) getIP:(NSString *)pPostData;
- (NSURLRequest *) createHTTPSoapRequest:(NSString *)pSoapFunction withData:(NSString *)pPostData;
- (NSURLRequest *) createHTTPSoapRequest:(NSString *)pSoapFunction withData:(NSString *)pPostData withTimeout:(NSTimeInterval) pTimeout;
@end
