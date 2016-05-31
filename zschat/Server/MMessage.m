//
//  ZSMessages.m
//  brclient
//
//  Created by Zsolt Laky on 2014. 11. 11..
//  Copyright (c) 2014. Zsolt Laky. All rights reserved.
//

#import "MMessage.h"

@implementation MsgGetIP
@synthesize hostIP;
@synthesize hostPort;
@synthesize wsResult;

-(id)init {
    if (self = [super init]) {
        [self setWsResult:1];
    }
    return self;
}
@end


