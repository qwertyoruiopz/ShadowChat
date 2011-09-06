//
//  AddConnectionTVController.m
//  ShadowChat
//
//  Created by James Long on 06/09/2011.
//  Copyright 2011 uiop. All rights reserved.
//

#import "AddConnectionTVController.h"


@implementation AddConnectionTVController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Add Connection";

    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneConnection)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelConnection)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    [self.tableView setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)doneConnection {
    NSLog(@"Done :D");
    [self dismissModalViewControllerAnimated:YES];
}

- (void)cancelConnection {
    NSLog(@"Cancelled D:");
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 3;
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"Connection Information";
            break;
        case 1:
            return @"User Information";
            break;
        default:
            return nil;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {                
                [cell.textLabel setText: @"Description"];
                cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
                
                UITextField *descr = [[UITextField alloc] initWithFrame:CGRectMake(125, 11, 185, 30)];
                descr.adjustsFontSizeToFitWidth = YES;
                descr.placeholder = @"Enter a description";
                descr.returnKeyType = UIReturnKeyNext;
                
                [cell addSubview: descr];
            } else if (indexPath.row == 1) {
                [cell.textLabel setText: @"Address"];
                cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
                
                UITextField *addr = [[UITextField alloc] initWithFrame:CGRectMake(125, 11, 185, 30)];
                addr.adjustsFontSizeToFitWidth = YES;
                addr.placeholder = @"irc.network.tld";
                addr.keyboardType = UIKeyboardTypeURL;
                addr.returnKeyType = UIReturnKeyNext;
                
                [cell addSubview: addr];
            }
            break;
        case 1:
            if (indexPath.row == 0) {                
                [cell.textLabel setText: @"Username"];
                cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
                
                UITextField *user = [[UITextField alloc] initWithFrame:CGRectMake(125, 11, 185, 30)];
                user.adjustsFontSizeToFitWidth = YES;
                user.placeholder = [[UIDevice currentDevice] name];
                user.returnKeyType = UIReturnKeyNext;
                
                [cell addSubview: user];
            } else if (indexPath.row == 1) {
                [cell.textLabel setText: @"Nickname"];
                cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
                
                UITextField *nick = [[UITextField alloc] initWithFrame:CGRectMake(125, 11, 185, 30)];
                nick.adjustsFontSizeToFitWidth = YES;
                nick.placeholder = [[UIDevice currentDevice] name];
                nick.keyboardType = UIKeyboardTypeURL;
                nick.returnKeyType = UIReturnKeyNext;
                
                [cell addSubview: nick];
            } else if (indexPath.row == 2) {
                [cell.textLabel setText: @"Real Name"];
                cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
                
                UITextField *rlname = [[UITextField alloc] initWithFrame:CGRectMake(125, 11, 185, 30)];
                rlname.adjustsFontSizeToFitWidth = YES;
                rlname.placeholder = [[UIDevice currentDevice] name];
                rlname.keyboardType = UIKeyboardTypeURL;
                rlname.returnKeyType = UIReturnKeyNext;
                
                [cell addSubview: rlname];
            }
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
