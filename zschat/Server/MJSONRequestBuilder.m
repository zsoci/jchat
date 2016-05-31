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


#define kPOSTMETHOD                 @"POST"
#define kCONTENTLENGTH              @"Content-Length"
#define kSOAPACTIONHEADERFIELD      @"SOAPAction"
//#define kXGAMECLIENTHEADERFIELD     @"X-Game-Client"
#define kREQUESTEDURLFORMAT         @"http://%@:%tu/%@"
#define kSOAPACTIONFORMAT           @"http://%@/%@"
//#define kGETACTION                  @"Get"
//#define kXGAMECLIENT                @"BridgeIsland SOFTIC iPad/1.4"

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
    self.requestedURLString = [NSString stringWithFormat:kREQUESTEDURLFORMAT, host, port, moduleName];
}

- (void) setConnetionToHost:(NSString *)pHost withPort:(NSInteger) pPort
{
    host = pHost;
    port = pPort;
    [self setURLString];
}

- (void)dealloc
{
    //    self.credentials=nil;
    self.host = nil;
    self.requestedURLString=nil;
}

- (NSMutableURLRequest *) createRequest:(NSString *)pPath method:(NSString *)pMethod withData:(NSString *)pPostData
{
    NSData * postData = [pPostData dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
//    NSString * postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //    NSMutableDictionary * user = [MServer user];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.requestedURLString, pPath]]];
    [request setHTTPMethod:pMethod];
//    [request setValue:postLength forHTTPHeaderField:kCONTENTLENGTH];
    
    for (id key in headerFields)
    {
        [request setValue:headerFields[key] forHTTPHeaderField:key];
    }
    [request setHTTPBody:postData];
//    [request setValue:[NSString stringWithFormat:kSOAPACTIONFORMAT, host, pFunction] forHTTPHeaderField:kSOAPACTIONHEADERFIELD];
    NSLog(@"Request:%@", request);
    return request;
}

//- (NSMutableURLRequest *) createHTTPRequestWithHeader:(NSString *)pSoapAction withData:(NSString *)pPostData
//{
//    NSMutableURLRequest * request = [self createHTTPRequestWithBaseHeader:pSoapAction withData:pPostData];
//   return request;
//}

//- (NSURLRequest *) getIP:(NSString *)pPostData
//{
//    // no need for BCGModule.asmx in the header for getIP
//    NSMutableURLRequest * returnURL;
//
//    self.requestedURLString = [NSString stringWithFormat:@"http://%@:%tu", host, port];
//
//    returnURL = [self createHTTPRequestWithBaseHeader:@"Get" withData:pPostData];
//    [returnURL setTimeoutInterval:10.0];
////    [self setConnetionToHost:self.host withPort:self.port];
//
//    return returnURL;
//}

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
