//
//  ZLBase64.h
//  BridgeIsland
//
//  Created by Zsolt Laky on 2012.01.08..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBase64 : NSObject
+ (NSString*) encodeStr:(NSString *)inputStr;
+ (NSData*) decode:(NSString*) string;
+ (NSString*) encode:(NSData*) rawBytes;
@end
