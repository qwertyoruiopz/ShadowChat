
//
//  AddConnectionTVController.m
//  ShadowChat
//
//  Created by James Long on 06/09/2011.
//  Copyright 2011 uiop. All rights reserved.
//

#import "AddConnectionTVController.h"
#import "SHIRCNetwork.h"
#import "SHIRCChannel.h"
@interface UIView (FindAndResignFirstResponder)
- (BOOL)findAndResignFirstResponder;
@end
@implementation UIView (FindAndResignFirstResponder)

- (BOOL)findAndResignFirstResponder
{
    if (self.isFirstResponder) {
        [self resignFirstResponder];
        return YES;     
    }
    for (UIView *subView in self.subviews) {
        if ([subView findAndResignFirstResponder])
            return YES;
    }
    return NO;
}
@end

@implementation AddConnectionTVController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        description=nil;
        server=nil;
        user=nil;
        nick=nil;
        name=nil;
        spass=nil;
        npass=nil;
        hasSSL=NO;
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
    [[self tableView] findAndResignFirstResponder];
	[[SHIRCNetwork createNetworkWithServer:[server text] andPort:[[port text] intValue] isSSLEnabled:hasSSL description:[description text]
                              withUsername:user ? [user text] : @"shadowchat"
                               andNickname:nick ? [nick text] : [[[[UIDevice currentDevice] name] componentsSeparatedByString:@" "] objectAtIndex:0]
                               andRealname:name ? [name text] : @"ShadowChat User"
                            serverPassword:[spass text]
                          nickServPassword:[npass text]]
     connect];
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
    NSString *CellIdentifier = [[NSString alloc] initWithFormat:@"serverconnection-%d-%d", indexPath.section, indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
                switch (indexPath.section) {
            case 0:
                if (indexPath.row == 0) {                
                    [cell.textLabel setText: @"Description"];
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
                    
                    UITextField *adescr = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 185, 22)];
                    adescr.adjustsFontSizeToFitWidth = YES;
                    adescr.placeholder = @"Enter a description";
                    adescr.returnKeyType = UIReturnKeyNext;
                    adescr.tag = 12340;
                    adescr.keyboardAppearance = UIKeyboardAppearanceAlert;
                    [adescr setDelegate:self];
                    [cell setAccessoryView: adescr];
                    [adescr release];
                } else if (indexPath.row == 1) {
                    [cell.textLabel setText: @"Address"];
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
                    
                    UITextField *aaddr = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 185, 22)];
                    aaddr.adjustsFontSizeToFitWidth = YES;
                    aaddr.placeholder = @"irc.network.tld";
                    aaddr.keyboardType = UIKeyboardTypeURL;
                    aaddr.returnKeyType = UIReturnKeyNext;
                    aaddr.tag = 12341;
                    aaddr.keyboardAppearance = UIKeyboardAppearanceAlert;
                    [aaddr setDelegate:self];
                    [cell setAccessoryView: aaddr];
                    [aaddr release];
                } else if (indexPath.row == 2) {
                    [cell.textLabel setText: @"Port"];
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
                    UITextField *portField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 185, 22)];
                    portField.adjustsFontSizeToFitWidth = YES;
                    portField.placeholder = @"6667";
                    portField.keyboardType = UIKeyboardTypeNumberPad;
                    portField.returnKeyType = UIReturnKeyNext;
                    portField.tag = 12342;
                    portField.keyboardAppearance = UIKeyboardAppearanceAlert;
                    [portField setDelegate:self];
                    [cell setAccessoryView: portField];
                    [portField release];
                } else if (indexPath.row == 3) {
                    [cell.textLabel setText: @"Connect via SSL"];
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
                    UISwitch* sslSwitch=[[UISwitch alloc] initWithFrame:CGRectZero];
                    sslSwitch.tag = 12350;
                    [sslSwitch addTarget: self action: @selector(flip:) forControlEvents:UIControlEventValueChanged];
                    [cell setAccessoryView:sslSwitch];
                    [sslSwitch release];
                }
                break;
            case 1:
                if (indexPath.row == 0) {                
                    [cell.textLabel setText: @"Username"];
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
                    UITextField *userField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 185, 22)];
                    userField.adjustsFontSizeToFitWidth = YES;
                    userField.placeholder = @"shadowchat";
                    userField.returnKeyType = UIReturnKeyNext;
                    userField.keyboardAppearance = UIKeyboardAppearanceAlert;
                   userField.tag = 12343;
                    [userField setDelegate:self];
                    [cell setAccessoryView: userField];
                    [userField release];
                } else if (indexPath.row == 1) {
                    [cell.textLabel setText: @"Nickname"];
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
                    UITextField *nickField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 185, 22)];
                    nickField.adjustsFontSizeToFitWidth = YES;
                    nickField.keyboardAppearance = UIKeyboardAppearanceAlert;
                    @try {
                        nickField.placeholder = [[[[UIDevice currentDevice] name] componentsSeparatedByString:@" "] objectAtIndex:0];
                    }
                    @catch (NSException *exception) {
                        nickField.placeholder = @"Something";
                    }
                    nickField.returnKeyType = UIReturnKeyNext;
                    nickField.tag = 12344;
                    [nickField setDelegate:self];
                    [cell setAccessoryView: nickField];
                    [nickField release];
                } else if (indexPath.row == 2) {
                    [cell.textLabel setText: @"Real Name"];
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
                    
                    UITextField *rlname = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 185, 22)];
                    rlname.adjustsFontSizeToFitWidth = YES;
                    rlname.keyboardAppearance = UIKeyboardAppearanceAlert;
                    rlname.placeholder = @"ShadowChat User";
                    rlname.returnKeyType = UIReturnKeyNext;
                    rlname.tag = 12345;
                    [rlname setDelegate:self];
                    [cell setAccessoryView: rlname];
                    [rlname release];
                }
                break;
            case 2:
                if (indexPath.row == 0) {                
                    [cell.textLabel setText: @"Nick Password"];
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
                    
                    UITextField *passField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 155, 22)];
                    passField.adjustsFontSizeToFitWidth = YES;
                    passField.placeholder = @"";
                    passField.returnKeyType = UIReturnKeyNext;
                    passField.keyboardAppearance = UIKeyboardAppearanceAlert;
                    passField.secureTextEntry = YES;
                    passField.tag = 12346;
                    [passField setDelegate:self];
                    [cell setAccessoryView: passField];
                    [passField release];
                } else if (indexPath.row == 1) {
                    [cell.textLabel setText: @"Server password"];
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
                    
                    UITextField *nserv = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 155, 22)];
                    nserv.keyboardAppearance = UIKeyboardAppearanceAlert;
                    nserv.adjustsFontSizeToFitWidth = YES;
                    nserv.placeholder = @"";
                    nserv.returnKeyType = UIReturnKeyDone;
                    nserv.tag = 12347;
                    [nserv setDelegate:self];
                    [cell setAccessoryView: nserv];
                    [nserv release];
                } 
                break;
            default:
                break;
        }
    }
    cell.tag=1227;
    [CellIdentifier release];
    return cell;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField tag] == 12341||[textField tag] == 12344||[textField tag] == 12343) {
        if ([string isEqualToString:@" "]) {
            return NO;
        }
        if ([textField tag] == 12341) {
            if (range.length==1&&[[textField text]length]==1) {
                self.navigationItem.rightBarButtonItem.enabled=NO;
            } else if (range.length==0&&range.location==0)
            {
                self.navigationItem.rightBarButtonItem.enabled=YES;
            }
        }
    }
    return YES;
}
- (void)flip:(id)sender
{
    hasSSL=[sender isOn];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [[[self tableView] viewWithTag:textField.tag+1] becomeFirstResponder];
    [[self tableView] scrollToRowAtIndexPath:[self.tableView indexPathForCell:(UITableViewCell*)
                                              [textField superview]] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return NO;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"Saving!");
    switch ([textField tag]) {
        case 12340:
            description=textField;
            break;
        case 12341:
            server=textField;
            break;
        case 12342:
            port=textField;
            break;
        case 12343:
            user=(![[textField text] isEqualToString:@""]) ? textField : nil;
            break;
        case 12344:
            nick=(![[textField text] isEqualToString:@""]) ? textField : nil;
            break;
        case 12345:
            name=(![[textField text] isEqualToString:@""]) ? textField : nil;
            break;
        case 12346:
            npass=textField;
            break;
        case 12347:
            spass=textField;
            break;
        default:
            break;
    }
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
