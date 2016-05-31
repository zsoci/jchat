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
//    NSString *username = fieldLoginName.text;
//    NSString *password = fieldPassword.text;
//    //    NSString *nickname = fieldNickName.text;
//    
//    if ((username.length != 0) && (password.length != 0))
//    {
//        [ProgressHUD show:@"Signing in..." Interaction:NO];
//        [MServer setupUser:username password:password];
//        //        [MServer getUser][USER_NICKNAME] = nickname;
    if (!getIsActive)
    {
//        [MServer GetMessages:pMessage messageNr:messageNr onDelegate:self onSelector:@selector(messagesReceived:)];
        debugOut(@"Get thrown\n");
        getIsActive = YES;
    }
//Login:@"" onDelegate:self onSelector:@selector(getLoginResponse:)];
//        //        [MServer Request:@"Login" withData:<#(NSString *)#> onDelegate:<#(id)#> onSelector:<#(SEL)#>logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error)
//        //         {
//        //             if (user != nil)
//        //             {
//        //                 ParsePushUserAssign();
//        //                 [ProgressHUD showSuccess:[NSString stringWithFormat:@"Welcome back %@!", user[PF_USER_FULLNAME]]];
//        //                 [self dismissViewControllerAnimated:YES completion:nil];
//        //             }
//        //             else [ProgressHUD showError:error.userInfo[@"error"]];
//        //         }];
//    }
//    else [ProgressHUD showError:@"Please enter both username and password."];
//    
}

- (void) messagesReceived:(id)aObject
{
    id anObject = [MServer getWSResult:aObject];

    getIsActive = NO;
    debugOut(@"Get closed\n");
    if ([anObject isKindOfClass:[NSError class]])
    {
        debugOut(([NSString stringWithFormat:@"Got error message response data:%@\n",anObject]));
//        [ProgressHUD dismiss];
//        ZSMsgView *alert = [[ZSMsgView alloc] initWithTitle:[[(NSError *)anObject userInfo] valueForKey:NSLocalizedDescriptionKey]
//                                                    message:[[(NSError *)anObject userInfo] valueForKey:NSLocalizedFailureReasonErrorKey]
//                                                   delegate:self
//                                                 onSelector:@selector(msgBoxLoginResponse:)
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:@"Register",nil];
// //       [alert show];
//        sl
//        sleep(5000);
        [self performSelector:@selector(getMessages:) withObject:(id)(@"") afterDelay:1.0];
    }
    else
    {
        //        [ProgressHUD showSuccess:[NSString stringWithFormat:@"Welcome back %@!", [MServer getUser][USER_NICKNAME]]];
        NSLog(@"Got message response data:%@",anObject);
        debugOut(([NSString stringWithFormat:@"Got message:%@\n",anObject]));
//        NSArray * nodes = anObject;
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

- (void) getLoginResponse:(id)aObject
{
    id anObject = [MServer getWSResult:aObject];
    if ([anObject isKindOfClass:[NSError class]])
    { // GetLogin did not succeeded
        [ProgressHUD dismiss];
//        ZSMsgView *alert = [[ZSMsgView alloc] initWithTitle:[[(NSError *)anObject userInfo] valueForKey:NSLocalizedDescriptionKey]
//                                                    message:[[(NSError *)anObject userInfo] valueForKey:NSLocalizedFailureReasonErrorKey]
//                                                   delegate:self
//                                                 onSelector:@selector(msgBoxLoginResponse:)
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:@"Register",nil];
//        [alert show];
    }
    else
    {
        //        [ProgressHUD showSuccess:[NSString stringWithFormat:@"Welcome back %@!", [MServer getUser][USER_NICKNAME]]];
        NSLog(@"Got relogin response data:%@",anObject);
        [profileView viewDidAppear:NO];
//        NSArray * nodes = anObject;
//        for (SMXMLElement * node in nodes)
//        {
//            if ([@"sNickName" ISNODENAME]) [MServer getUser][USER_NICKNAME] = [node value];
//            else NSLog(NODE_NOT_PROCESSED,[node name]);
//        }
//        [ProgressHUD showSuccess:[NSString stringWithFormat:@"Welcome back %@!", [MServer getUser][USER_NICKNAME]]];
//        [MServer saveUserdefaults];
//        [self dismissViewControllerAnimated:YES completion:Nil];
//        [myAppDelegate getMessages:@""];
        
        //UserData * data = anObject;
        //        [[[[ZSAppDelegate shared] appGlobals] userData] setAvatar:[data avatar]];
        //        [[[[ZSAppDelegate shared] appGlobals] userData] setExpireTime:[data expireTime]];
        //        [(ZSRootViewController *)self.parentViewController swapViewController:self toController:@"MainMenuView" duration:VIEWTRANSITIONDURATION options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionTransitionFlipFromLeft completion:nil];
        //        [[[[ZSAppDelegate shared] appGlobals] rootWindow] runGet];
    }
    [self getMessages:@""];
    
}

@end
