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

- (id) initMWSWorker:(NSURLRequest *)pRequest onDelegate:(id)pDelegate onThread:(NSThread *)pSenderThread onSelector:(SEL)pSenderSelector;
@end
