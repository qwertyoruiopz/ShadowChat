//
//  SHChanJoin.m
//  ShadowChat
//
//  Created by qwerty or on 09/11/11.
//  Copyright 2011 uiop. All rights reserved.
//

#import "SHChanJoin.h"
#import "SHIRCSocket.h"
#import "SHIRCChannel.h"

@implementation SHChanJoin
@synthesize network;

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField tag] == 12341 || [textField tag] == 12344 || [textField tag] == 12343) {
        if ([string isEqualToString:@" "]) {
            return NO;
        }
        if ([textField tag] == 12341) {
            if (range.length == 1 && [[textField text] length] == 1) {
                self.navigationItem.rightBarButtonItem.enabled = NO;
            }
			else if (range.length == 0 && range.location == 0) {
                self.navigationItem.rightBarButtonItem.enabled = YES;
            }
        }
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (![[textField text] isEqualToString:@""] && ![[textField text] isEqualToString:@" "] && ![[textField text] isEqualToString:@"#"] && ![[textField text] isEqualToString:@"# "] && ![[textField text] isEqualToString:@"#  "]) // just in case.. stfu. :P
		[self doneWithJoin];
	[textField resignFirstResponder];
    return NO;
}


- (id)initWithStyle:(UITableViewStyle)style {
	if ((self = [super initWithStyle:style])) {
		rooms = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Join a channel";

    [self loadAvailableRoomsOnServer];
	
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Join" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithJoin)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    [rightBarButtonItem release];
	
    rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(done)];
    self.navigationItem.leftBarButtonItem = rightBarButtonItem;
    [rightBarButtonItem release];
}

- (void)doneWithJoin {
    [[SHIRCChannel alloc] initWithSocket:network.socket andChanName:([[(UITextField *)[self.tableView viewWithTag:12340] text] isEqualToString:@""] ? [(UITextField *)[self.tableView viewWithTag:12340] placeholder] : [(UITextField *)[self.tableView viewWithTag:12340] text])];
    [self done];
}

- (void)done {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
//    [[self.tableView viewWithTag:12340] becomeFirstResponder];
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 1;
            break;
            
        case 1:
            return [[rooms allKeys] count];
            break;
            
        default:
            break;
    }
    return 0;
}


- (void)loadAvailableRoomsOnServer {
	
	if ([[[[network socket] availableRooms] allKeys] count] == 0) {
		[[network socket] findAvailableRoomsWithCallback:self];
		[rooms setObject:@"k" forKey:@"Loading..."];
	}
	else {
		rooms = [[network socket] availableRooms];
		[self.tableView reloadData];
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Pick a channel";
            break;
            
        case 1:
            return @"Channel List";
            break;
            
        default:
            break;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *CellIdentifier = [[NSString alloc] initWithFormat:@"chanjoin-%d-%d", indexPath.section, indexPath.row];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		switch (indexPath.section) {
			case 0:
				switch (indexPath.row) {
					case 0:
						cell.textLabel.text = @"Channel Name";
						cell.selectionStyle = UITableViewCellSelectionStyleNone;
						cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
						UITextField *adescr = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 150, 22)];
						adescr.adjustsFontSizeToFitWidth = YES;
						adescr.placeholder = @"#help";
						adescr.returnKeyType = UIReturnKeyDone;
						adescr.tag = 12340;
						adescr.keyboardAppearance = UIKeyboardAppearanceAlert;
						[adescr setDelegate:(id<UITextFieldDelegate>)self];
						[cell setAccessoryView: adescr];
						[adescr release];
						break;
					default:
						break;
				}
				break;
			case 1: 
					cell.textLabel.text = [[rooms allKeys] objectAtIndex:indexPath.row];
				break;
			default:
				break;
		}
        // Configure the cell...
	}
	return cell;
}

- (void)addRoom:(NSString *)room withUserCount:(NSString *)_count {
	[rooms removeObjectForKey:@"Loading..."];
	[self deleteLoadingCellIfNecessary];
	if (![[rooms allKeys] containsObject:room])
		[rooms setObject:_count forKey:room];
//	else {
//		if (![[rooms objectForKey:room] isEqualToString:_count]) {
//			[rooms removeObjectForKey:room];
//			[rooms setObject:_count forKey:room];
//		}
//	}
	[self.tableView reloadData];
}

- (void)dealloc {
	[super dealloc];
	[rooms release];
	
}

- (void)deleteLoadingCellIfNecessary {
	for (UITableViewCell *c in [self.tableView visibleCells]) {
		if ([c.textLabel.text isEqualToString:@"Loading..."]) {
			[self.tableView beginUpdates];
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[self.tableView indexPathForCell:c]] withRowAnimation:UITableViewRowAnimationFade];
			[self.tableView endUpdates];
			break;
		}
	}
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
