//
//  AppLoginViewController.m
//  zschat
//
//  Created by Zsolt Laky on 2014. 11. 30..
//  Copyright (c) 2014. Zsolt Laky. All rights reserved.
//
#import "MServer.h"
//#import "MWSWorker.h"
#import "AppLoginViewController.h"
#import "ProgressHUD.h"
#import "ZSMsgView.h"
#import "LoginViewController.h"
//#import "SMXMLDocument.h"
#import "MJSONParsers.h"
#import "Common.h"
#import "AppDelegate.h"

@interface AppLoginViewController ()
@property (strong, nonatomic) IBOutlet UITableViewCell *cellLoginName;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellPassword;
//@property (strong, nonatomic) IBOutlet UITableViewCell *cellNickName;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellLoginButton;
@property (strong, nonatomic) IBOutlet UITextField *fieldLoginName;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellServerIP;
@property (strong, nonatomic) IBOutlet UITextField *fieldPassword;
//@property (strong, nonatomic) IBOutlet UITextField *fieldNickName;
@property (strong, nonatomic) IBOutlet UITextField *fieldServerIP;

@end

@implementation AppLoginViewController
@synthesize cellLoginName, cellPassword, cellLoginButton,cellServerIP;
@synthesize fieldLoginName, fieldPassword,fieldServerIP; //, fieldNickName;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Login";
    //---------------------------------------------------------------------------------------------------------------------------------------------
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)]];
    
    self.tableView.separatorInset = UIEdgeInsetsZero;
    [fieldLoginName setText:[MServer getUser][USER_USERNAME]];
    [fieldPassword setText:[MServer getUser][USER_PASSWORD]];
    [fieldServerIP setText:[MServer getUser][USER_DEFAULTSERVERIP]];
//    [fieldNickName setText:[MServer getUser][USER_NICKNAME]];
//    [fieldEmail setText:[MServer getUser][USER_EMAIL]];
    self.tableView.separatorInset = UIEdgeInsetsZero;
}

- (void)viewDidAppear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidAppear:animated];
    [fieldLoginName becomeFirstResponder];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)dismissKeyboard
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionLogin:(id)sender
{
    NSString *username = fieldLoginName.text;
    NSString *password = fieldPassword.text;
//    NSString *nickname = fieldNickName.text;
    
    if ((username.length != 0) && (password.length != 0))
    {
        [ProgressHUD show:@"Signing in..." Interaction:NO];
        [MServer setupUser:username password:password];
//        [MServer getUser][USER_NICKNAME] = nickname;
        [MServer Login:@"" onDelegate:self onSelector:@selector(getLoginResponse:)];
//        [MServer Request:@"Login" withData:<#(NSString *)#> onDelegate:<#(id)#> onSelector:<#(SEL)#>logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error)
//         {
//             if (user != nil)
//             {
//                 ParsePushUserAssign();
//                 [ProgressHUD showSuccess:[NSString stringWithFormat:@"Welcome back %@!", user[PF_USER_FULLNAME]]];
//                 [self dismissViewControllerAnimated:YES completion:nil];
//             }
//             else [ProgressHUD showError:error.userInfo[@"error"]];
//         }];
    }
    else [ProgressHUD showError:@"Please enter both username and password."];

}
- (void) msgBoxLoginResponse:(NSNumber*) index
{

    if (1 == [index integerValue]) {
// vegyuk ki a rootviewcontrolleret
        NSMutableArray *viewController = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
        LoginViewController * rootController = [viewController objectAtIndex:0];
        [rootController swapViewController:@"RegisterView"];
//        [viewController replaceObjectAtIndex:1 withObject:newController];
//        [self.navigationController setViewControllers:viewController];
    };
}

- (void) getLoginResponse:(id)aObject
{
    id anObject = [MServer getWSResult:aObject];
    if ([anObject isKindOfClass:[NSError class]])
    { // GetLogin did not succeeded
        [ProgressHUD dismiss];
        ZSMsgView *alert = [[ZSMsgView alloc] initWithTitle:[[(NSError *)anObject userInfo] valueForKey:NSLocalizedDescriptionKey]
                                                    message:[[(NSError *)anObject userInfo] valueForKey:NSLocalizedFailureReasonErrorKey]
                                                   delegate:self
                                                 onSelector:@selector(msgBoxLoginResponse:)
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:@"Register",nil];
        [alert show];
    }
    else
    {
//        [ProgressHUD showSuccess:[NSString stringWithFormat:@"Welcome back %@!", [MServer getUser][USER_NICKNAME]]];
        debugOut(([NSString stringWithFormat:@"Got login response data in apploginviewcontroller.m:%@",anObject]));
//        NSArray * nodes = anObject;
//        for (SMXMLElement * node in nodes)
//        {
//            if ([@"sNickName" ISNODENAME]) [MServer getUser][USER_NICKNAME] = [node value];
//            else NSLog(NODE_NOT_PROCESSED,[node name]);
//        }
        [ProgressHUD showSuccess:[NSString stringWithFormat:@"Welcome back %@!", [MServer getUser][USER_NICKNAME]]];
        [MServer saveUserdefaults];
        [self dismissViewControllerAnimated:YES completion:Nil];
        [myAppDelegate getMessages:@""];

        //UserData * data = anObject;
//        [[[[ZSAppDelegate shared] appGlobals] userData] setAvatar:[data avatar]];
//        [[[[ZSAppDelegate shared] appGlobals] userData] setExpireTime:[data expireTime]];
//        [(ZSRootViewController *)self.parentViewController swapViewController:self toController:@"MainMenuView" duration:VIEWTRANSITIONDURATION options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionTransitionFlipFromLeft completion:nil];
//        [[[[ZSAppDelegate shared] appGlobals] rootWindow] runGet];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Table view data source

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    return 1;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    return 3;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    if (indexPath.row == 0) return cellLoginName;
    if (indexPath.row == 1) return cellPassword;
    if (indexPath.row == 2) return cellLoginButton;
    return nil;
}

#pragma mark - UITextField delegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    if (textField == fieldLoginName)
    {
        [fieldPassword becomeFirstResponder];
    }
    if (textField == fieldPassword)
    {
        [self actionLogin:nil];
    }
    return YES;
}

@end
