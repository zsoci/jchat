//
//  ChatRoomsTableViewController.m
//  zschat
//
//  Created by Zsolt Laky on 2014. 11. 30..
//  Copyright (c) 2014. Zsolt Laky. All rights reserved.
//

#import "MServer.h"
#import "ChatRoomsViewController.h"
#import "LoginViewController.h"
#import "utilities.h"
#import "ProgressHUD.h"
#import "Common.h"
//#import "SMXMLDocument.h"
#import "MJSONParsers.h"
#import "AppDelegate.h"

@interface ChatRoomsViewController ()
- (IBAction)ItemPressed:(id)sender;

@end

@implementation ChatRoomsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"ChatRoomsViewController loaded");
    [ProgressHUD show:@"Connecting"];
    [MServer setup:DEFAULTHOST withPort:DEFAULTPORT withApp:APPLICATIONID];
    
    [MServer Login:@"" onDelegate:myAppDelegate onSelector:@selector(getLoginResponse:)];
//    [MServer Login:@"" onDelegate:self onSelector:@selector(getLoginResponse:)];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"ChatRoomsViewController appeared");

//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
//    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void) getLoginResponse:(id)aObject
//{
//    id anObject = [MServer getWSResult:aObject];
//    if ([anObject isKindOfClass:[NSError class]])
//    { // GetLogin did not succeeded
//        [ProgressHUD dismiss];
//        LoginUser(self);
//    }
//    else
//    {
//        NSLog(@"Got login response data in chatroomsviewcontroller.m:%@",anObject);
////        NSArray * nodes = anObject;
////        for (SMXMLElement * node in nodes)
////        {
////            if ([@"sNickName" ISNODENAME]) [MServer getUser][USER_NICKNAME] = [node value];
////            else NSLog(NODE_NOT_PROCESSED,[node name]);
////        }
////        NSDictionary * dict = anObject;
//        [MServer getUser][USER_NICKNAME] = [(NSDictionary *) anObject objectForKey:@"nick_name"];
//        //[MServer getUser][USER_NICKNAME] = [dict objectForKey:@"nick_name"];
//        [ProgressHUD showSuccess:[NSString stringWithFormat:@"Welcome back %@!", [MServer getUser][USER_NICKNAME]]];
//        [MServer saveUserdefaults];
//        [myAppDelegate getMessages:@""];
//    }
//}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

- (IBAction)ItemPressed:(id)sender {
    LoginUser(self);
}
@end
