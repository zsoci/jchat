//
//  ProfileViewController.m
//  zschat
//
//  Created by Zsolt Laky on 2015. 02. 06..
//  Copyright (c) 2015. Zsolt Laky. All rights reserved.
//

#import "ProfileViewController.h"
#import "camera.h"
#import "utilities.h"
#import "MServer.h"
#import "MBase64.h"
#import "ProgressHUD.h"
#import "ZSMsgView.h"
//#import "SMXMLDocument.h"
#import "AppDelegate.h"

@interface ProfileViewController ()
- (IBAction)SaveProfile:(id)sender;

- (IBAction)takePressed:(id)sender;

@property (strong, nonatomic) IBOutlet UITableViewCell *cellSaveButton;
@property (strong, nonatomic) IBOutlet UIImageView *avatar;
- (IBAction)imagePressed:(id)sender;
- (IBAction)actionLogout:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *viewHeader;

@end

@implementation ProfileViewController

@synthesize avatar;
@synthesize cellSaveButton;
@synthesize viewHeader;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)]];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    self.tableView.tableHeaderView = viewHeader;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    avatar.layer.cornerRadius = avatar.frame.size.width / 2;
    avatar.layer.masksToBounds = YES;
    [myAppDelegate setProfileView:self];
//    avatarButton.layer.cornerRadius = avatarButton.frame.size.width / 2;
//    avatarButton.clipsToBounds = YES;
//    avatarButton.layer.masksToBounds = YES;
    

}
- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"ProfileViewController appeared");
    if ([MServer getUser][USER_AVATAR])
        [avatar setImage:[[UIImage alloc] initWithData:[MBase64 decode:[MServer getUser][USER_AVATAR]]]];
    //    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    //    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
//        ParsePushUserResign();
//        PostNotification(NOTIFICATION_USER_LOGGED_OUT);
        
//        imageUser.image = [UIImage imageNamed:@"blank_profile"];
//        fieldName.text = @"";
        
 //       LoginUser(self);
    }
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (IBAction)actionPhoto:(id)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    ShouldStartPhotoLibrary(self, YES);
}

- (void)dismissKeyboard
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [self.view endEditing:YES];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (IBAction)actionSave:(id)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [self dismissKeyboard];
    
//    if ([fieldName.text isEqualToString:@""] == NO)
//    {
//        [ProgressHUD show:@"Please wait..."];
//        
//        PFUser *user = [PFUser currentUser];
//        user[PF_USER_FULLNAME] = fieldName.text;
//        user[PF_USER_FULLNAME_LOWER] = [fieldName.text lowercaseString];
//        
//        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
//         {
//             if (error == nil)
//             {
//                 [ProgressHUD showSuccess:@"Saved."];
//             }
//             else [ProgressHUD showError:@"Network error."];
//         }];
//    }
//    else [ProgressHUD showError:@"Name field must be set."];
}

#pragma mark - UIImagePickerControllerDelegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    UIImage *image = info[UIImagePickerControllerEditedImage];

    if (image.size.width > 140) image = imageByScalingAndCroppingForSize(image, CGSizeMake(140, 140));
//    PFFile *filePicture = [PFFile fileWithName:@"picture.jpg" data:UIImageJPEGRepresentation(image, 0.6)];
//    [filePicture saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
//     {
//         if (error != nil) [ProgressHUD showError:@"Network error."];
//     }];
//    //---------------------------------------------------------------------------------------------------------------------------------------------
    avatar.image = image;
    NSString * coded = [MBase64 encode:UIImageJPEGRepresentation(avatar.image,0.6)];
    [MServer getUser][USER_AVATAR] = coded;
    
//    PFUser *user = [PFUser currentUser];
//    user[PF_USER_PICTURE] = filePicture;
//    user[PF_USER_THUMBNAIL] = fileThumbnail;
//    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
//     {
//         if (error != nil) [ProgressHUD showError:@"Network error."];
//     }];
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 0) return cellAvatar;
    if (indexPath.row == 0) return cellSaveButton;
    return nil;

 //   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) msgBoxSaveUserProfileResponse:(NSNumber*) index
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

- (void) gotSaveUserProfileResponse:(id)aObject
{
    id anObject = [MServer getWSResult:aObject];
    if ([anObject isKindOfClass:[NSError class]])
    { // GetLogin did not succeeded
        NSLog(@"gotSaveUserProfileResponse ERROR:%@", anObject);
        [ProgressHUD dismiss];
        
        ZSMsgView *alert = [[ZSMsgView alloc] initWithTitle:[[(NSError *)anObject userInfo] valueForKey:NSLocalizedDescriptionKey]
                                                    message:[[(NSError *)anObject userInfo] valueForKey:NSLocalizedFailureReasonErrorKey]
                                                   delegate:self
                                                 onSelector:@selector(msgBoxSaveUserProfileResponse:)
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSLog(@"Got savedprofileresponse:%@",anObject);
//        NSArray * nodes = anObject;
//        for (SMXMLElement * node in nodes)
//        {
//            if ([@"sNickName" ISNODENAME]) [MServer getUser][USER_NICKNAME] = [node value];
//            else NSLog(NODE_NOT_PROCESSED,[node name]);
//        }
        [ProgressHUD showSuccess:[NSString stringWithFormat:@"Profile Saved"]];
//        [MServer saveUserdefaults];
        //UserData * data = anObject;
        //        [[[[ZSAppDelegate shared] appGlobals] userData] setAvatar:[data avatar]];
        //        [[[[ZSAppDelegate shared] appGlobals] userData] setExpireTime:[data expireTime]];
        //        [(ZSRootViewController *)self.parentViewController swapViewController:self toController:@"MainMenuView" duration:VIEWTRANSITIONDURATION options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionTransitionFlipFromLeft completion:nil];
        //        [[[[ZSAppDelegate shared] appGlobals] rootWindow] runGet];
    }
    
}

- (IBAction)SaveProfile:(id)sender {
    
    NSLog(@"SAVE profile button pressed");
    NSString * coded = [MBase64 encode:UIImageJPEGRepresentation(avatar.image,0.6)];
    [MServer getUser][USER_AVATAR] = coded;
    NSLog(@"Imagestring:%@",coded);
    NSLog(@"Size of image:%f,%f",avatar.image.size.width,avatar.image.size.height);
    NSLog(@"Length of image:%tu",coded.length);
    [MServer saveUserdefaults];
    [ProgressHUD show:@"Saving Profile"];

    NSString * profile = [NSString stringWithFormat:@"{\"avatar\":\"%@\"}", [MServer getUser][USER_AVATAR]];
//    NSString * profile = [NSString stringWithFormat:@"{\"avatar\":\"\"}"];
    [MServer SaveUserProfile:profile onDelegate:self onSelector:@selector(gotSaveUserProfileResponse:)];
}
- (IBAction)imagePressed:(id)sender {
    NSLog(@"Avatar pressed");
    ShouldStartPhotoLibrary(self, YES);
}

- (IBAction)actionLogout:(id)sender {
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"Log out", nil];
    [action showFromTabBar:[[self tabBarController] tabBar]];

}
- (IBAction)takePressed:(id)sender {
    ShouldStartCamera(self, YES);
}
@end
