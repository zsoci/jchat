//
//  LoginViewController.m
//  zschat
//
//  Created by Zsolt Laky on 2014. 11. 30..
//  Copyright (c) 2014. Zsolt Laky. All rights reserved.
//

#import "LoginViewController.h"
#import "AppLoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Loginviewcontroller loaded");
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)actionFacebook:(id)sender {
}
- (IBAction)actionRegister:(id)sender {
}
- (IBAction)actionLogin:(id)sender {
//    LoginView *loginView = [[LoginView alloc] init];
//    [self.navigationController pushViewController:loginView animated:YES];
}

- (void)swapViewController:(NSString *)toControllerName
{
    UIViewController * newController = [self.storyboard instantiateViewControllerWithIdentifier:toControllerName];
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController pushViewController:newController animated:YES];
}

@end
