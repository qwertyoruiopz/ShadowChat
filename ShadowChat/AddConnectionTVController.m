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
    rightBarButtonItem.enabled=NO;
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    [rightBarButtonItem release];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelConnection)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    [leftBarButtonItem release];
    //[self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"] ] ];
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 4;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 2;
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
        case 2:
            return @"Authentication";
            break;
        default:
            return nil;
            break;
    }
}
/*
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    // | <UITableHeaderFooterView: 0x4b69830; frame = (0 10; 320 36); text = 'Connection Information'; autoresize = W; layer = <CALayer: 0x4b69480>>
    UILabel *headerView = [[[UILabel alloc] initWithFrame:CGRectMake(10, 10, tableView.bounds.size.width, 36)] autorelease];
    [headerView setBackgroundColor:[UIColor clearColor]];
    [headerView setTextColor:[UIColor whiteColor]];
    [headerView setShadowColor:[UIColor blackColor]];
    [headerView setShadowOffset:CGSizeMake(0, 1)];
    [headerView setFont:[UIFont boldSystemFontOfSize:[UIFont labelFontSize]-1]];
    [headerView setText:[self tableView:tableView titleForHeaderInSection:section]];
    return headerView;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"serverconnection";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
                switch (indexPath.section) {
            case 0:
                if (indexPath.row == 0) {                
                    [cell.textLabel setText: @"Description"];
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
                    
                    UITextField *descr = [[UITextField alloc] initWithFrame:CGRectMake(125, 11, 185, 30)];
                    descr.adjustsFontSizeToFitWidth = YES;
                    descr.placeholder = @"Enter a description";
                    descr.returnKeyType = UIReturnKeyNext;
                    descr.tag = 12340;
                    [descr setDelegate:self];
                    [cell addSubview: descr];
                    [descr release];
                } else if (indexPath.row == 1) {
                    [cell.textLabel setText: @"Address"];
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
                    
                    UITextField *addr = [[UITextField alloc] initWithFrame:CGRectMake(125, 11, 185, 30)];
                    addr.adjustsFontSizeToFitWidth = YES;
                    addr.placeholder = @"irc.network.tld";
                    addr.keyboardType = UIKeyboardTypeURL;
                    addr.returnKeyType = UIReturnKeyNext;
                    addr.tag = 12341;
                    [addr setDelegate:self];
                    [cell addSubview: addr];
                    [addr release];
                } else if (indexPath.row == 2) {
                    [cell.textLabel setText: @"Port"];
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
                    
                    UITextField *port = [[UITextField alloc] initWithFrame:CGRectMake(125, 11, 185, 30)];
                    port.adjustsFontSizeToFitWidth = YES;
                    port.placeholder = @"6667";
                    port.keyboardType = UIKeyboardTypeNumberPad;
                    port.returnKeyType = UIReturnKeyNext;
                    port.tag = 12342;
                    [port setDelegate:self];
                    [cell addSubview: port];
                    [port release];
                } else if (indexPath.row == 3) {
                    [cell.textLabel setText: @"SSL"];
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
                    UISwitch* sslSwitch=[[UISwitch alloc] initWithFrame:CGRectZero];
                    sslSwitch.tag = 12350;
                    [cell setAccessoryView:sslSwitch];
                    [sslSwitch release];
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
                    user.tag = 12343;
                    [user setDelegate:self];
                    [cell addSubview: user];
                    [user release];
                } else if (indexPath.row == 1) {
                    [cell.textLabel setText: @"Nickname"];
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
                    UITextField *nick = [[UITextField alloc] initWithFrame:CGRectMake(125, 11, 185, 30)];
                    nick.adjustsFontSizeToFitWidth = YES;
                    nick.placeholder = [[UIDevice currentDevice] name];
                    nick.returnKeyType = UIReturnKeyNext;
                    nick.tag = 12344;
                    [nick setDelegate:self];
                    [cell addSubview: nick];
                    [nick release];
                } else if (indexPath.row == 2) {
                    [cell.textLabel setText: @"Real Name"];
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
                    
                    UITextField *rlname = [[UITextField alloc] initWithFrame:CGRectMake(125, 11, 185, 30)];
                    rlname.adjustsFontSizeToFitWidth = YES;
                    rlname.placeholder = [[UIDevice currentDevice] name];
                    rlname.returnKeyType = UIReturnKeyNext;
                    rlname.tag = 12345;
                    [rlname setDelegate:self];
                    [cell addSubview: rlname];
                    [rlname release];
                }
                break;
            case 2:
                if (indexPath.row == 0) {                
                    [cell.textLabel setText: @"Password"];
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
                    
                    UITextField *spass = [[UITextField alloc] initWithFrame:CGRectMake(125, 11, 185, 30)];
                    spass.adjustsFontSizeToFitWidth = YES;
                    spass.placeholder = @"";
                    spass.returnKeyType = UIReturnKeyNext;
                    spass.secureTextEntry = YES;
                    spass.tag = 12346;
                    [spass setDelegate:self];
                    [cell addSubview: spass];
                    [spass release];
                } else if (indexPath.row == 1) {
                    [cell.textLabel setText: @"Nick password"];
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
                    
                    UITextField *nserv = [[UITextField alloc] initWithFrame:CGRectMake(125, 11, 185, 30)];
                    nserv.adjustsFontSizeToFitWidth = YES;
                    nserv.placeholder = @"";
                    nserv.returnKeyType = UIReturnKeyDone;
                    nserv.tag = 12347;
                    [nserv setDelegate:self];
                    [cell addSubview: nserv];
                    [nserv release];
                } 
                break;
            default:
                break;
        }
    }

    return cell;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [[[self tableView] viewWithTag:textField.tag+1] becomeFirstResponder];
    [[self tableView] scrollToRowAtIndexPath:[self.tableView indexPathForCell:(UITableViewCell*)
                                              [textField superview]] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return NO;
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
- (void) dealloc
{
    NSLog(@"Deallocating");
    [super dealloc];
}

@end
