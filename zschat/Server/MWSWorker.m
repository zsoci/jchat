//
//  WSWorker.m
//  BridgeIsland
//
//  Created by Zsolt Laky on 2012.01.14..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "MWSWorker.h"
#import "MServer.h"
#import "MServerPrivate.h"
#import "MJSONParsers.h"

@implementation MWSWorker
@synthesize delegate;
@synthesize wsresult;
@synthesize jsonParserClass;
@synthesize jsonParserSelector;

- (MWSWorker *) initMWSWorker:(NSURLRequest *)pRequest onDelegate:(id)pDelegate onThread:(NSThread *)pSenderThread onSelector:(SEL)pSenderSelector jsonParserFunc:(NSString *)pParserName
{
    delegate = pDelegate;
    [NSURLConnection sendAsynchronousRequest:pRequest queue:[[MServer getServer] webServiceQueue] completionHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
        id senddelegate = delegate;
        NSString * stt = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"MSWorker Got:%@",stt);
        NSLog(@"For delegate %@, selector %s",senddelegate,sel_getName(pSenderSelector));
        if (senddelegate) {
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            NSInteger responseStatusCode = [httpResponse statusCode];
            
            if (error)
            {
                NSLog(@"MSWorker 1. responseStatusCode = %ld. Error:%@", (long)responseStatusCode, error);
                [self setWsresult:error];
                [senddelegate performSelector:pSenderSelector onThread:pSenderThread withObject:self waitUntilDone:YES];
            }
            else if (responseStatusCode != 200)
            {
                NSLog(@"MSWorker 2:%ld", (long)responseStatusCode);
                [self setWsresult:[MServer MError:@"Server error" withCode:e_Error withString:[NSString stringWithFormat:@"%ld", (long)responseStatusCode]]];
                [senddelegate performSelector:pSenderSelector onThread:pSenderThread withObject: self waitUntilDone:YES];
            }
            else
            {
                NSLog(@"MSWorker 3");
                if (error) {
                    NSLog(@"MSWorker 4");

                    [self setWsresult:error];
                    [senddelegate performSelector:pSenderSelector onThread:pSenderThread withObject:self waitUntilDone:YES];
                }
                else {
                    NSDictionary * jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
                    SEL selector = NSSelectorFromString([pParserName stringByAppendingString:@":"]);
                    if ([MJSONParsers respondsToSelector:selector])
                    {
                        NSLog(@"MSWorker 6. Data:%@", jsonData);
                        
                        IMP imp = [MJSONParsers methodForSelector:selector];
                        id (*func)(id, SEL, NSDictionary *) = (void *)imp;
                        [self setWsresult:func([[MServer getServer] JSONParsers], selector, jsonData)];
                    }
                    else
                    {
                        [self setWsresult:jsonData];
                    }
                    [senddelegate performSelector:pSenderSelector onThread:pSenderThread withObject:self waitUntilDone:YES];
                }
            }
        }
        else
        {
            NSLog(@"Web Service response discarded");
        }
        senddelegate = nil;
        delegate = nil;
    }];
    return self;
}
@end
