//
//  SHUsersTableView.m
//  ShadowChat
//
//  Created by Max Shavrick on 11/30/11.
//  Copyright (c) 2011 uiop. All rights reserved.
//

#import "SHUsersTableView.h"

@interface NSString (UserAdditions) 
- (BOOL)isHigherPowerThan:(NSString *)t;
@end
@implementation NSString (UserAdditions)

- (BOOL)isHigherPowerThan:(NSString *)t {
	if ([self hasPrefix:@"~"])
		return NO; // Nothing is higher.. don't even bother.
	else if ([self hasPrefix:@"&"])
		return [t isEqualToString:@"~"];
	else if ([self hasPrefix:@"@"])
		return ([t isEqualToString:@"~"] || [t isEqualToString:@"&"]);
	else if ([self hasPrefix:@"%"])
		return ([t isEqualToString:@"~"] || [t isEqualToString:@"@"] || [t isEqualToString:@"&"]);
	else if ([self hasPrefix:@"+"]) 
		return ([t isEqualToString:@"~"] || [t isEqualToString:@"@"] || [t isEqualToString:@"&"] || [t isEqualToString:@"%"]);
	return NO;
	
}

@end

@implementation SHUsersTableView

- (id)initWithStyle:(UITableViewStyle)style {
	if ((self = [super initWithStyle:style])) {
		userTitles = [[NSMutableDictionary alloc] init];
		ops = [[NSMutableArray alloc] init];
		vops = [[NSMutableArray alloc] init];
		hops = [[NSMutableArray alloc] init];
		sops = [[NSMutableArray alloc] init];
		aops = [[NSMutableArray alloc] init];
		norms = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString *)nickWithoutFormatting:(NSString *)__nick {
	return [[[[[__nick stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"~" withString:@""] stringByReplacingOccurrencesOfString:@"%" withString:@""] stringByReplacingOccurrencesOfString:@"&"withString:@""] stringByReplacingOccurrencesOfString:@"+" withString:@""];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)setUsers:(NSArray *)_users {

	for (NSString *user in _users) {
		if (![user isEqualToString:@""])
			if (![[userTitles allKeys] containsObject:[self nickWithoutFormatting:user]])
				[self categorizeNick:user];
	}
	[self.tableView reloadData];

}

- (BOOL)hasPowerz:(NSString *)sNick {
	return [sNick hasPrefix:@"@"] || [sNick hasPrefix:@"&"] || [sNick hasPrefix:@"+"] || [sNick hasPrefix:@"~"] || [sNick hasPrefix:@"%"];
}

- (void)categorizeNick:(NSString *)aNick {
	if (![aNick isEqualToString:@""] && ![aNick isEqualToString:@" "]) {
		if ([aNick hasPrefix:@"@"]) {
			[ops addObject:aNick];
			[userTitles setObject:[aNick substringWithRange:NSMakeRange(0, 1)] forKey:[self nickWithoutFormatting:aNick]];
		}
		else if ([aNick hasPrefix:@"~"]) {
			[sops addObject:aNick];
			[userTitles setObject:[aNick substringWithRange:NSMakeRange(0, 1)] forKey:[self nickWithoutFormatting:aNick]];
		}
		else if ([aNick hasPrefix:@"%"]) {
			[hops addObject:aNick];
			[userTitles setObject:[aNick substringWithRange:NSMakeRange(0, 1)] forKey:[self nickWithoutFormatting:aNick]];
		}
		else if ([aNick hasPrefix:@"+"]) {
			[vops addObject:aNick];
			[userTitles setObject:[aNick substringWithRange:NSMakeRange(0, 1)] forKey:[self nickWithoutFormatting:aNick]];
		}
		else if ([aNick hasPrefix:@"&"]) {
			[aops addObject:aNick];
			[userTitles setObject:[aNick substringWithRange:NSMakeRange(0, 1)] forKey:[self nickWithoutFormatting:aNick]];
		}
		else {
			[norms addObject:aNick];
			[userTitles setObject:@"" forKey:[self nickWithoutFormatting:aNick]];
		}
	}
}



- (void)setUserRank:(NSString *)_user_ rank:(NSString *)_rank {
	
}

- (void)removeUser:(NSString *)aUser {
	[self performSelectorInBackground:@selector(findArrayAndRemoveNick:) withObject:aUser];
	[userTitles removeObjectForKey:aUser];
}

- (void)findArrayAndRemoveNick:(NSString *)_sUser {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	if ([norms containsObject:_sUser]) {
		[norms removeObject:_sUser];
		goto cleanup;
	}
	BOOL p = [_sUser isEqualToString:[self nickWithoutFormatting:_sUser]];
	if (!p) _sUser = [@"+" stringByAppendingString:_sUser];
	if ([vops containsObject:_sUser]) {
		[vops removeObject:_sUser];
		goto cleanup;
	}
	if (!p) _sUser = [_sUser stringByReplacingOccurrencesOfString:@"+" withString:@"%"];
	if ([hops containsObject:_sUser]) {
		[hops removeObject:_sUser];
		goto cleanup;
	}
	if (!p) _sUser = [_sUser stringByReplacingOccurrencesOfString:@"%" withString:@"@"];
	if ([ops containsObject:_sUser]) {
		[ops removeObject:_sUser];
		goto cleanup;
	}
	if (!p) _sUser = [_sUser stringByReplacingOccurrencesOfString:@"@" withString:@"&"];
	if ([aops containsObject:_sUser]) {
		[aops removeObject:_sUser];
		goto cleanup;
	}
	if (!p) _sUser = [_sUser stringByReplacingOccurrencesOfString:@"&" withString:@"~"];
	if ([sops containsObject:_sUser]) {
		[sops removeObject:_sUser];
		goto cleanup;
	}
cleanup:
	[self.tableView reloadData];
	[pool drain];
	return;

}


- (void)addUser:(NSString *)aUser {
	[norms addObject:aUser];
	[self.tableView reloadData];
}

- (NSString *)titleForModeChange:(NSString *)up {
	if ([up hasPrefix:@"+"]) {
		// promotion D:
		NSString *change = [up substringWithRange:NSMakeRange(1, up.length-1)];
		if ([change isEqualToString:@"o"]) {
			
		}
	}
	else {
		// HOPEFULLLY... only demotion here.. otherwise make case for "-"
	}
	return @"";
}



- (void)setMode:(NSString *)mode forUser:(NSString *)_cUser fromUser:(NSString *)__sU {

	NSString *directMode = [mode substringWithRange:NSMakeRange(1, 1)];
	if ([userTitles objectForKey:_cUser] == nil) {
		[self removeUser:_cUser];
		if ([mode characterAtIndex:0] == '+') {
			if ([self hasPowerz:_cUser]) {
				if (![[mode substringWithRange:NSMakeRange(0, 1)] isHigherPowerThan:directMode]) 
					[userTitles setObject:directMode forKey:_cUser];
				else return;
			}
			else {
				[userTitles setObject:directMode forKey:_cUser];
			}
		}
		else if ([mode characterAtIndex:0] == '-') {
			// begin removing shits..
		}
		else {
			// :o wth?!?
		}
		//someone figure this shit out...
		// if a user is given voice. (+v)
		// then given halfop, or a higher ranking
		// then it's removed, it's forgotten that the user had voice.
		// need a workaround. Maybe setting the object for the key (nick)
		// to maybe a +h (+v)
		// sort of hidden.. but needs to be recognized somehow.. :(
		// also kind of sad no one will probably ever read this...
	}
//	arrayOfArrays = [NSArray arrayWithObjects:norms, vops, hops, ops, aops, sops, nil];
//	for (int i = 0; i < [arrayOfArrays count]; i++) {
//		for (int f = 0; f < [[arrayOfArrays objectAtIndex:i] count]; f++) {
//			id currentArray = [arrayOfArrays objectAtIndex:i];
//			
//		}
//	}
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		UIBarButtonItem *invite = [[UIBarButtonItem alloc] initWithTitle:@"Invite" style:UIBarButtonItemStyleBordered target:self action:@selector(showInviteView:)];
		[[self navigationItem] setLeftBarButtonItem:invite];
		[invite release];
	}
	[self doneEditing:nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)edit:(id)barBtn {
	UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing:)];
	[[self navigationItem] setRightBarButtonItem:done];
	[done release];
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
		UIBarButtonItem *invite = [[UIBarButtonItem alloc] initWithTitle:@"Invite" style:UIBarButtonItemStyleBordered target:self action:@selector(showInviteView:)];
		[[self navigationItem] setLeftBarButtonItem:invite];
		[invite release];
	}
	[self setEditing:YES animated:YES];
}

- (void)showInviteView:(id)i {
	NSLog(@"Nothing to see here...");
}

- (void)doneEditing:(id)tb {
	UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit:)];
	[[self navigationItem] setRightBarButtonItem:edit];
	[edit release];
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
		[[self navigationItem] setLeftBarButtonItem:nil];
	[self setEditing:NO animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
	return @"Kick";
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
	// return ([sops count] > 0) + ([aops count] > 0) + ([ops count] > 0) + ([hops count] > 0) + ([vops count] > 0) + ([norms count] > 0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return [sops count];
		case 1:
			return [aops count];
		case 2: 
			return [ops count];
		case 3:
			return [hops count];
		case 4:
			return [vops count];
		case 5:
			return [norms count];
		default: 
			return 0;
	}
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	switch (indexPath.section) {
		case 0:
			cell.textLabel.text = [sops objectAtIndex:indexPath.row];
			break;
		case 1:
			cell.textLabel.text = [aops objectAtIndex:indexPath.row];
			break;
		case 2:
			cell.textLabel.text = [ops objectAtIndex:indexPath.row];
			break;
		case 3:
			cell.textLabel.text = [hops objectAtIndex:indexPath.row];
			break;
		case 4:
			cell.textLabel.text = [vops objectAtIndex:indexPath.row];
			break;
		case 5:
			cell.textLabel.text = [norms objectAtIndex:indexPath.row];
		default:
			break;
	}
    // Configure the cell...
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

	switch (section) {
		case 0:
			return @"Owner";
			break;
		case 1:
			return @"SOP";
			break;
		case 2:
			return @"OP";
			break;
		case 3:
			return @"HOP";
			break;
		case 4:
			return @"VOP";
			break;
		case 5:
			return @"Normal";
			break;
		default:
			return @"ohai";
			break;
	}
	return @"HAI";
	
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
}

- (void)dealloc {
	[ops release];
	[vops release];
	[hops release];
	[sops release];
	[aops release];
	[userTitles release];
	[norms release];
	[super dealloc];
}

@end
