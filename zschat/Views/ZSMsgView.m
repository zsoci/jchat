//
//  ZSMsgViewController.m
//  brclient
//
//  Created by Zsolt Laky on 2014. 11. 05..
//  Copyright (c) 2014. Zsolt Laky. All rights reserved.
//

#import "ZSMsgView.h"

@interface ZSMsgView ()

@end

@implementation ZSMsgView
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate onSelector:(SEL) selector cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION NS_EXTENSION_UNAVAILABLE_IOS("Use UIAlertController instead.")
{
    targetDelegate = delegate;
    targetSelector = selector;
    
    return [self initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [targetDelegate performSelector:targetSelector onThread:[NSThread currentThread] withObject:[NSNumber numberWithInteger:buttonIndex] waitUntilDone:NO];

//    [targetDelegate performSelector:targetSelector withObject:nil];
}

@end
