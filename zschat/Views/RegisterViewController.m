//
//  RegisterViewController.m
//  zschat
//
//  Created by Zsolt Laky on 2014. 12. 09..
//  Copyright (c) 2014. Zsolt Laky. All rights reserved.
//
#import "MServer.h"
//#import "MXMLParsers.h"
#import "Common.h"
//#import "SMXMLDocument.h"
#import "RegisterViewController.h"
#import "ProgressHUD.h"
#import "ZSMsgView.h"
#import "AppDelegate.h"

@interface RegisterViewController()

@property (strong, nonatomic) IBOutlet UITableViewCell *cellName;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellPassword;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellEmail;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellButton;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellNickName;

@property (strong, nonatomic) IBOutlet UITextField *fieldName;
@property (strong, nonatomic) IBOutlet UITextField *fieldPassword;
@property (strong, nonatomic) IBOutlet UITextField *fieldEmail;
@property (strong, nonatomic) IBOutlet UITextField *fieldNickName;

@end
//-------------------------------------------------------------------------------------------------------------------------------------------------

@implementation RegisterViewController

@synthesize cellName, cellPassword, cellEmail, cellButton, cellNickName;
@synthesize fieldName, fieldPassword, fieldEmail,fieldNickName;

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    self.title = @"Register";
    //---------------------------------------------------------------------------------------------------------------------------------------------
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)]];

    self.tableView.separatorInset = UIEdgeInsetsZero;
    [fieldName setText:[MServer getUser][USER_USERNAME]];
    [fieldPassword setText:[MServer getUser][USER_PASSWORD]];
    [fieldNickName setText:[MServer getUser][USER_NICKNAME]];
    [fieldEmail setText:[MServer getUser][USER_EMAIL]];
}

-(void)viewDidAppear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidAppear:animated];
    [fieldName becomeFirstResponder];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)dismissKeyboard
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [self.view endEditing:YES];
}

#pragma mark - User actions

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (IBAction)actionRegister:(id)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    NSString *name		= fieldName.text;
    NSString *password	= fieldPassword.text;
    NSString *email		= fieldEmail.text;
    NSString *nick      = fieldNickName.text;
    
    if ((name.length != 0) && (password.length != 0) && (email.length != 0) && (nick.length != 0))
    {
        [ProgressHUD show:@"Please wait..." Interaction:YES];
        [MServer setupUser:name password:password];
        [MServer setupUserMail:email];
        [MServer Register:[NSString stringWithFormat:@"{\"nick_name\":\"%@\"}",[NSString stringWithUTF8String:[nick UTF8String]]] onDelegate:self onSelector:@selector(getRegisterResponse:)];
    }
    else [ProgressHUD showError:@"Please fill all values!"];
}

- (void) getRegisterResponse:(id)aObject
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
                                          otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSLog(@"Got registerresponse:%@",anObject);
        [MServer Login:@"" onDelegate:myAppDelegate onSelector:@selector(getLoginResponse:)];
        [MServer saveUserdefaults];
        [myAppDelegate getMessages:@""];
    }
    
}
- (void) msgBoxLoginResponse:(NSNumber*) index
{
//    if (1 == [index integerValue]) {
        // vegyuk ki a rootviewcontrolleret
//        NSMutableArray *viewController = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
//        LoginViewController * rootController = [viewController objectAtIndex:0];
//        [rootController swapViewController:@"RegisterView"];
        //        [viewController replaceObjectAtIndex:1 withObject:newController];
        //        [self.navigationController setViewControllers:viewController];
//    };
}

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
    return 5;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    if (indexPath.row == 0) return cellName;
    if (indexPath.row == 1) return cellPassword;
    if (indexPath.row == 2) return cellNickName;
    if (indexPath.row == 3) return cellEmail;
    if (indexPath.row == 4) return cellButton;
    return nil;
}

#pragma mark - UITextField delegate

//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
//{
//    if (textField == fieldName)
//    {
//        [fieldPassword becomeFirstResponder];
//    }
//    if (textField == fieldPassword)
//    {
//        [fieldNickName becomeFirstResponder];
//    }
//    if (textField == fieldNickName)
//    {
//        [fieldEmail becomeFirstResponder];
//    }
//    if (textField == fieldEmail)
//    {
//        [self actionRegister:nil];
//    }
//    return YES;
//}
//
//-------------------------------------------------------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    if (textField == fieldName)
    {
        [fieldPassword becomeFirstResponder];
    }
    if (textField == fieldPassword)
    {
        [fieldNickName becomeFirstResponder];
    }
    if (textField == fieldNickName)
    {
        [fieldEmail becomeFirstResponder];
    }
    if (textField == fieldEmail)
    {
        [self actionRegister:nil];
    }
    return YES;
}

@end
