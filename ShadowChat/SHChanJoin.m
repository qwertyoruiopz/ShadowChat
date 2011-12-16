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
		[self doneWithJoin:[textField text]];
	[textField resignFirstResponder];
    return NO;
}


- (id)initWithStyle:(UITableViewStyle)style {
	if ((self = [super initWithStyle:style])) {
		rooms = [[NSMutableDictionary alloc] init];
		_rooms = [[NSMutableArray alloc] init];
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

- (void)doneWithJoin:(NSString *)room {
    [[SHIRCChannel alloc] initWithSocket:network.socket andChanName:(room ? room : @"#help")];
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
        case 1:
            return [[rooms allKeys] count];
            
        default:
			break;
    }
    return 0;
}


- (void)loadAvailableRoomsOnServer {
	[[network socket] findAvailableRoomsWithCallback:self];
	[rooms setObject:@"k" forKey:@"Loading..."];
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
		cell = [[[UITableViewCell alloc] initWithStyle:(indexPath.section == 0 ? UITableViewCellStyleDefault : UITableViewCellStyleSubtitle) reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
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
			id dict = [rooms objectForKey:cell.textLabel.text];
			if ([dict isKindOfClass:[NSDictionary class]]) {
				cell.detailTextLabel.text = ([[[rooms objectForKey:cell.textLabel.text] objectForKey:@"T0PIC"] isEqualToString:@" "] ? @"No Topic Set" : [[rooms objectForKey:cell.textLabel.text] objectForKey:@"T0PIC"]);
			}
			break;
		default:
			break;
	}
	return cell;
}


- (void)addRoom:(NSString *)room withRoomInfo:(NSDictionary *)infos {
	
	[self deleteLoadingCellIfNecessary];
	[rooms setObject:infos forKey:room];
	[self.tableView beginUpdates];
	[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationLeft];
	[self.tableView endUpdates];
	[self.tableView reloadData];
	//	NSLog(@"0.o %@ : %d", c, [self.tableView indexPathForCell:c].section);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 0:
			return 40.0;
		case 1:
			return 50.0;
		default:
			return 40.0;
	}
	return 40.0;
}

- (void)dealloc {
	[super dealloc];
	[rooms release];
	[_rooms release];
	
}

- (void)deleteLoadingCellIfNecessary {
	if (![[rooms allKeys] containsObject:@"Loading..."])
		return;
	[rooms removeObjectForKey:@"Loading..."];
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
	if (indexPath.section == 1) {
		[self doneWithJoin:[[[tableView cellForRowAtIndexPath:indexPath] textLabel] text]];
	}
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
