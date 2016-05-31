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
#import "MXMLParsers.h"

//#import "ZSAppDelegate.h"
#import "SMXMLDocument.h"

NSString * const kGETIPREQUEST =  @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
"<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\">"
"<SOAP-ENV:Body>"
"<SOAP-ENV:GetIPResponse>"
"<GetIPResult>1</GetIPResult>"
"<sIP>193.6.149.29</sIP>"
"<nPort>80</nPort>"
"</SOAP-ENV:GetIPResponse>"
"</SOAP-ENV:Body>"
"</SOAP-ENV:Envelope>";



@implementation MWSWorker
@synthesize delegate;
@synthesize wsresult;

- (MWSWorker *) initMWSWorker:(NSURLRequest *)pRequest onDelegate:(id)pDelegate onThread:(NSThread *)pSenderThread onSelector:(SEL)pSenderSelector
{
//    ZSAppDelegate * app = [ZSAppDelegate shared];webServiceQueue
    delegate = pDelegate;
    [NSURLConnection sendAsynchronousRequest:pRequest queue:[[MServer getServer] webServiceQueue] completionHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
        id senddelegate = delegate;
        NSString * stt = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"MSWorker Got:%@",stt);
        NSLog(@"For delegate %@, selector %s",senddelegate,sel_getName(pSenderSelector));
        if (senddelegate) {
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    //        id      result;
            NSInteger responseStatusCode = [httpResponse statusCode];
            
            if (error)
            {
                NSLog(@"MSWorker 1:%@",error);
                [self setWsresult:error];
                [senddelegate performSelector:pSenderSelector onThread:pSenderThread withObject:self waitUntilDone:YES];
            }
            else if (responseStatusCode != 200)
            {
                NSLog(@"MSWorker 2");
                [self setWsresult:[MServer MError:@"Server error" withCode:e_Error withString:@"Service not implemented"]];
                [senddelegate performSelector:pSenderSelector onThread:pSenderThread withObject: self waitUntilDone:YES];
            }
            else
            {
                NSLog(@"MSWorker 3");
                
                SMXMLDocument *document = [SMXMLDocument documentWithData:responseData error:&error];
                //        NSLog(@"Document:\n %@", document);
                
                if (error) {
                    NSLog(@"MSWorker 4");

                    [self setWsresult:error];
                    [senddelegate performSelector:pSenderSelector onThread:pSenderThread withObject:self waitUntilDone:YES];
                }
                else {
                    NSLog(@"MSWorker 5");

                    SMXMLElement *body = [[((SMXMLDocument *)document) root] childNamed:@"Body"] ;
                    
                    for (SMXMLElement * node in [body children]) {
                        //            NSLog(@"%@",rootnode);
                        SEL selector = NSSelectorFromString([[node name] stringByAppendingString:@":"]);
                        if ([MXMLParsers respondsToSelector:selector])
                        {
                            //                [[[ZSAppDelegate shared] XMLParsers]  performSelector:selector withObject:[rootnode children] afterDelay:0.0 ];
                            NSLog(@"MSWorker 6");

                            IMP imp = [MXMLParsers methodForSelector:selector];
                            id (*func)(id, SEL, NSArray *) = (void *)imp;
                            [self setWsresult:func([[MServer getServer] JSONParsers], selector, [node children])];
                            [senddelegate performSelector:pSenderSelector onThread:pSenderThread withObject:self waitUntilDone:YES];
                        }
                        else
                        {
                            NSLog(@"MSWorker 7");

                            [self setWsresult:body];
                            [senddelegate performSelector:pSenderSelector onThread:pSenderThread withObject:self waitUntilDone:YES];
                        }
                    }
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
//
//- (void) main {
//    NSURLResponse * response;
//    NSError *       error = nil;
//    id      result;
//
//    NSData * urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
//
//    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
//    NSInteger responseStatusCode = [httpResponse statusCode];
//    
//    if (error || ( responseStatusCode != 200)) {
//        [delegate performSelector:senderSelector onThread:senderThread withObject:error waitUntilDone:NO];
//    }
//	else {
//        NSString * stt = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
//        NSLog(@"Got:%@",stt);
//        SMXMLDocument *document = [SMXMLDocument documentWithData:urlData error:&error];
//        SMXMLElement *body = [((SMXMLDocument *)document).root childNamed:@"Body"];
//        NSArray * nodes = [body children];
////        NSLog(@"Document:\n %@", document);
//        
//        if (error) {
//            [delegate performSelector:senderSelector onThread:senderThread withObject:error waitUntilDone:NO];
//        }
//        else {
//            SMXMLElement * rootnode = [nodes objectAtIndex:0];
////            NSLog(@"%@",rootnode);
//            
//            SEL selector = NSSelectorFromString([[rootnode name] stringByAppendingString:@":"]);
//            if ([ZSXMLParsers respondsToSelector:selector])
//            {
////                [[[ZSAppDelegate shared] XMLParsers]  performSelector:selector withObject:[rootnode children] afterDelay:0.0 ];
//                IMP imp = [ZSXMLParsers methodForSelector:selector];
//                id (*func)(id, SEL, NSArray *) = (void *)imp;
//                result = func([[ZSAppDelegate shared ] XMLParsers], selector, [rootnode children]);
//                [delegate performSelector:senderSelector onThread:senderThread withObject:result waitUntilDone:NO];
//            }
//            else [delegate performSelector:senderSelector onThread:senderThread withObject:nodes waitUntilDone:NO];
//        }
//    }
//}
@end
