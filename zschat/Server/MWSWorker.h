//
//  WSWorker.h
//  BridgeIsland
//
//  Created by Zsolt Laky on 2012.01.14..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWSWorker : NSObject

@property (atomic,strong) id delegate;
@property (nonatomic,strong) id wsresult;
@property (atomic, strong) id jsonParserClass;
@property (atomic, strong) id jsonParserSelector;

- (id) initMWSWorker:(NSURLRequest *)pRequest onDelegate:(id)pDelegate onThread:(NSThread *)pSenderThread onSelector:(SEL)pSenderSelector jsonParserFunc:(NSString *)pParserName;
@end
