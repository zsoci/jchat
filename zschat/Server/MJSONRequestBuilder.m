//
//  MJSONRequestBuilder.m
//  jchat
//
//  Created by Zsolt Laky on 5/31/16.
//  Copyright © 2016 Zsolt Laky. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MJSONRequestBuilder.h"
#import "MServer.h"

@interface MJSONRequestBuilder (PrivateMethods)


//- (void) setURL;
//- (NSMutableURLRequest *) createHTTPRequestWithBaseHeader:(NSString *)pSoapAction withData:(NSString *)pPostData;
//- (NSMutableURLRequest *) createHTTPRequestWithHeader:(NSString *)pSoapAction withData:(NSString *)pPostData;
@end

@implementation MJSONRequestBuilder

NSString * moduleName;
NSString * requestedURLString;
NSMutableDictionary * headerFields;

@synthesize moduleName;
@synthesize requestedURLString;
@synthesize host;
@synthesize port;

#define kREQUESTEDURLFORMAT         @"http://%@:%tu"

-(MJSONRequestBuilder *)init
{
    if (![super init]) return nil;
    headerFields = [[NSMutableDictionary alloc] init];
    
    return self;
}


- (void) setHeaderFieldForKey:(NSString *)pField withValue:(NSString *)pValue
{
    [headerFields setValue:pValue forKey:pField];
}
- (NSString *) getHeaderFiledForKey:(NSString *)pField
{
    return [headerFields valueForKey:pField];
}
- (void) deleteHeaderFiledForKey:(NSString *)pField
{
    [headerFields removeObjectForKey:pField];
}

- (NSInteger)port
{
    return port;
}

- (void) setURLString
{
    self.requestedURLString = [NSString stringWithFormat:kREQUESTEDURLFORMAT, host, port];
}

- (void) setConnetionToHost:(NSString *)pHost withPort:(NSInteger) pPort
{
    host = pHost;
    port = pPort;
    [self setURLString];
}

- (void)dealloc
{
    self.host = nil;
    self.requestedURLString=nil;
}

- (NSMutableURLRequest *) createRequest:(NSString *)pPath method:(NSString *)pMethod withData:(NSString *)pPostData
{
    NSData * postData = [pPostData dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.requestedURLString, pPath]]];
    [request setHTTPMethod:pMethod];
    
    for (id key in headerFields)
    {
        [request setValue:headerFields[key] forHTTPHeaderField:key];
    }
    [request setHTTPBody:postData];
    NSLog(@"Request:%@", request);
    return request;
}

- (NSURLRequest *) createJSONRequest:(NSString *)pPath method:(NSString *)pMethod withData:(NSString *)pPostData
{
    NSMutableURLRequest *req = [self createRequest:pPath method:pMethod withData:pPostData];
    [req setTimeoutInterval:5.0];
    return req;
}

- (NSURLRequest *) createJSONRequest:(NSString *)pPath method:(NSString *)pMethod withData:(NSString *)pPostData withTimeout:(NSTimeInterval) timeout
{
    NSMutableURLRequest * req = [self createRequest:pPath method:pMethod withData:pPostData];
    [req setTimeoutInterval:timeout];
    return req;
}

@end
