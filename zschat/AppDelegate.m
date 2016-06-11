//
//  AppDelegate.m
//  zschat
//
//  Created by Zsolt Laky on 2014. 11. 30..
//  Copyright (c) 2014. Zsolt Laky. All rights reserved.
//

#import "AppDelegate.h"
#import "Common.h"
#import "MServer.h"
#import "ProgressHUD.h"
#import "utilities.h"

//#import "MXMLParsers.h"
//#import "SMXMLDocument.h"

@interface AppDelegate ()
{
    NSNumber *  messageNr;
    BOOL        getIsActive;
}

@end

@implementation AppDelegate
@synthesize profileView;
@synthesize debugView;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    messageNr = [MServer getUser][USER_MSGSERIAL];
    getIsActive = NO;
    NSLog(@"Launched");
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)getMessages:(NSString *)pMessage
{
    if (!getIsActive)
    {
        [MServer GetMessages:self onSelector:@selector(messagesReceived:)];
        debugOut(@"Get thrown\n");
        getIsActive = YES;
    }
}

- (void) messagesReceived:(id)aObject
{
    id anObject = [MServer getWSResult:aObject];

    getIsActive = NO;
    debugOut(@"Get closed\n");
    if ([anObject isKindOfClass:[NSError class]])
    {
        NSInteger errorCode = [(NSError *)anObject code];
        NSLog(@"Error:%@", anObject);
        NSLog(@"ErrorCode:%ld", (long)errorCode);
        if (errorCode == kCFURLErrorUserCancelledAuthentication)
        {
            // let us reauthenticate once
            NSLog(@"Reauthentication is needed");
            [MServer Login:@"" onDelegate:self onSelector:@selector(reLoginResponse:)];
        }
        else
        {
            [MServer Login:@"" onDelegate:self onSelector:@selector(reLoginResponse:)];
        }
    }
    else
    {
        NSLog(@"Got message response data:%@",anObject);
        debugOut(([NSString stringWithFormat:@"Got message:%@\n",anObject]));
        NSArray * nodes = anObject;
        
        for (NSDictionary * aMessage in nodes)
        {
            NSLog(@"aMessage:%@", aMessage);
            NSInteger msgNr = [[aMessage objectForKey:@"Serial"] integerValue];
            NSLog(@"msgNr:%ld", (long)msgNr);
 
            [MServer getUser][USER_MSGSERIAL] = [[NSNumber alloc] initWithInteger:msgNr];
            NSDictionary * msg = [aMessage objectForKey:@"Msg"];
            NSLog(@"Msg:%@", msg);
            NSString * command = [msg objectForKey:@"command"];
            if ([@"refresh_user_profile" isEqualToString:command])
            {
                [MServer Login:@"" onDelegate:self onSelector:@selector(reLoginResponse:)];
            }
//            [MServer getUser][USER_MSGSERIAL] = [[NSNumber alloc] initWithInteger:1];
            
        }
//        for (SMXMLElement * node in nodes)
//        {
//            if ([@"Message" ISNODENAME]) {
//                NSInteger msgNr = GET_NAMED_INTEGER_ATTRIBUTE(@"msgnr");
//                NSArray * messageBody = [node children];
//                for (SMXMLElement * child in messageBody)
//                {
//                    if ([@"bUpdateUserProfile" IS_NAMED_NODE(child)] && [@"true" isEqualToString:[child value]])
//                    {
//                        NSLog(@"Updating user profile by logging in again");
//                        [MServer Login:@"" onDelegate:self onSelector:@selector(getLoginResponse:)];
//                    }
//                    else NSLog(NODE_NOT_PROCESSED,[child name]);
//                }
//            }
//            else NSLog(NODE_NOT_PROCESSED,[node name]);
//        }

//        NSArray * nodes = anObject;
//        for (SMXMLElement * node in nodes)
//        {
//            if ([@"sNickName" ISNODENAME]) [MServer getUser][USER_NICKNAME] = [node value];
//            else NSLog(NODE_NOT_PROCESSED,[node name]);
//        }
//        [ProgressHUD showSuccess:[NSString stringWithFormat:@"Welcome back %@!", [MServer getUser][USER_NICKNAME]]];
//        [MServer saveUserdefaults];
//        [self dismissViewControllerAnimated:YES completion:Nil];
        //UserData * data = anObject;
        //        [[[[ZSAppDelegate shared] appGlobals] userData] setAvatar:[data avatar]];
        //        [[[[ZSAppDelegate shared] appGlobals] userData] setExpireTime:[data expireTime]];
        //        [(ZSRootViewController *)self.parentViewController swapViewController:self toController:@"MainMenuView" duration:VIEWTRANSITIONDURATION options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionTransitionFlipFromLeft completion:nil];
        //        [[[[ZSAppDelegate shared] appGlobals] rootWindow] runGet];
        [self getMessages:@""];
    }
}

- (void) reLoginResponse:(id)aObject
{
    id anObject = [MServer getWSResult:aObject];
    if ([anObject isKindOfClass:[NSError class]])
    { // GetLogin did not succeeded
        LoginUser(self.window.rootViewController);
    }
    else
    {
        NSLog(@"In reLoginResponse:%@", anObject);
        [MServer getUser][USER_NICKNAME] = [(NSDictionary *) anObject objectForKey:@"nick_name"];
        [MServer getUser][USER_AVATAR] = [(NSDictionary *) anObject objectForKey:@"avatar"];
        NSLog(@"Nick name:%@", [(NSDictionary *) anObject objectForKey:@"ninck_name"]);
        [MServer saveUserdefaults];
        [profileView viewDidAppear:NO];
        [self getMessages:@""];
    }
}

- (void) getLoginResponse:(id)aObject
{
    id anObject = [MServer getWSResult:aObject];
    if ([anObject isKindOfClass:[NSError class]])
    { // GetLogin did not succeeded
        [ProgressHUD dismiss];
        LoginUser(self.window.rootViewController);
    }
    else
    {
        [self reLoginResponse:aObject];
        [ProgressHUD showSuccess:[NSString stringWithFormat:@"Welcome %@!", [MServer getUser][USER_NICKNAME]]];
    }
}
@end
