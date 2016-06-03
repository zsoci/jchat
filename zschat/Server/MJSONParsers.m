//
//  MJSONParsers.m
//  jchat
//
//  Created by Zsolt Laky on 5/31/16.
//  Copyright © 2016 Zsolt Laky. All rights reserved.
//

//#import <Foundation/Foundation.h>

#import "MJSONParsers.h"
#import "MMessage.h"
#import "MBase64.h"
#import "Common.h"
#import "MServer.h"
#import "MServerPrivate.h"
#import "UIKit/uikit.h"

@implementation MJSONParsers

+ (id) LoginResponse:(NSDictionary *)jsonData
{
    id retVal = nil;
    NSString * key;
    NSLog(@"JSONDATA in LoginResponse:%@", jsonData);
    for (key in jsonData)
    {
        NSLog(@"Key: %@, Value %@", key, [jsonData objectForKey: key]);
    }

    retVal = [NSString stringWithFormat:@"Login failed"];
    return [jsonData objectForKey:@"app_message"];
}

+ (id) RegisterResponse:(NSDictionary *)jsonData
{
    id retVal = nil;
    NSString * key;
    NSLog(@"JSONDATA in RegisterUserResponse:%@", jsonData);
    for (key in jsonData)
    {
        NSLog(@"Key: %@, Value %@", key, [jsonData objectForKey: key]);
    }
    
    retVal = [NSString stringWithFormat:@"Login failed"];
    return [jsonData objectForKey:@"app_message"];
}

+ (id) FetchMessageResponse:(NSDictionary *)jsonData;
{
    return [jsonData objectForKey:@"Messages"];
}


@end
