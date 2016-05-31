//
//  ZSMessages.h
//  brclient
//
//  Created by Zsolt Laky on 2014. 11. 11..
//  Copyright (c) 2014. Zsolt Laky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgGetIP : NSObject
@property (nonatomic,weak) NSString * hostIP;
@property (nonatomic,assign) NSInteger hostPort;
@property (nonatomic,assign) NSInteger wsResult;
@end
