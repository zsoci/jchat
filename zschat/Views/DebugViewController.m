//
//  DebugViewController.m
//  zschat
//
//  Created by Zsolt Laky on 2015. 05. 02..
//  Copyright (c) 2015. Zsolt Laky. All rights reserved.
//

#import "DebugViewController.h"
#import "AppDelegate.h"

@interface DebugViewController ()

@end

@implementation DebugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.textView.textContainer.lineBreakMode = NSLineBreakByWordWrapping;
    NSLog(@"ChatRoomsViewController loaded");
    [myAppDelegate setDebugView:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clearButton:(id)sender {
    [self.textView setText:@""];
}

- (void)append:(NSString *) lineToAppend
{
    [self.textView setText:[[self.textView text] stringByAppendingString:lineToAppend]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
