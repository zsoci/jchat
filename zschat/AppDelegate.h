//
//  AppDelegate.h
//  zschat
//
//  Created by Zsolt Laky on 2014. 11. 30..
//  Copyright (c) 2014. Zsolt Laky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileViewController.h"
#import "DebugViewController.h"
#define myAppDelegate (AppDelegate *)[[UIApplication sharedApplication] delegate]
#define debugOut(str) [[myAppDelegate debugView] append:(str)]

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ProfileViewController * profileView;
@property (strong, nonatomic) DebugViewController * debugView;

- (void)getMessages:(NSString *)pMessage;
- (void) getLoginResponse:(id)aObject;

@end

