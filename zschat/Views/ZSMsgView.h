//
//  ZSMsgViewController.h
//  brclient
//
//  Created by Zsolt Laky on 2014. 11. 05..
//  Copyright (c) 2014. Zsolt Laky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZSMsgView : UIAlertView
{
    id  targetDelegate;
    SEL targetSelector;
}
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate onSelector:(SEL) selector cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION NS_EXTENSION_UNAVAILABLE_IOS("Use UIAlertController instead.");

@end
