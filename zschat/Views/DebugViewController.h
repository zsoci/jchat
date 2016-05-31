//
//  DebugViewController.h
//  zschat
//
//  Created by Zsolt Laky on 2015. 05. 02..
//  Copyright (c) 2015. Zsolt Laky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DebugViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextView *textView;
- (IBAction)clearButton:(id)sender;
- (void)append:(NSString *) lineToAppend;
@end
