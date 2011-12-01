//
//  SHUsersTableView.m
//  ShadowChat
//
//  Created by Max Shavrick on 11/30/11.
//  Copyright (c) 2011 uiop. All rights reserved.
//

#import "SHUsersTableView.h"


@implementation SHUsersTableView

- (id)initWithStyle:(UITableViewStyle)style {
	if ((self = [super initWithStyle:style])) {
		ops = [[NSMutableArray alloc] init];
		vops = [[NSMutableArray alloc] init];
		hops = [[NSMutableArray alloc] init];
		sops = [[NSMutableArray alloc] init];
		aops = [[NSMutableArray alloc] init];
		norms = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)setUsers:(NSArray *)_users {
	users = [[_users retain] mutableCopy];
	[self sortNicks];
	[self.tableView reloadData];
}

- (void)sortNicks {
	for (id _nick in users) {
		if ([_nick hasPrefix:@"@"]) {
			[ops addObject:_nick];
		}
		else if ([_nick hasPrefix:@"~"]) {
			[sops addObject:_nick];
			}
		else if ([_nick hasPrefix:@"%"]) {
			[hops addObject:_nick];
		}
		else if ([_nick hasPrefix:@"+"]) {
			[vops addObject:_nick];
		}
		else if ([_nick hasPrefix:@"&"]) {
			[aops addObject:_nick];
		}
	}
}

- (void)removeUser:(NSString *)aUser {
	
}
- (void)addUser:(NSString *)aUser {
	
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 1:
			return [sops count];
		case 2:
			return [aops count];
		case 3: 
			return [ops count];
		case 4:
			return [hops count];
		case 5:
			return [vops count];
		case 6:
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
		case 1:
			cell.textLabel.text = [sops objectAtIndex:indexPath.row];
			break;
		case 2:
			cell.textLabel.text = [aops objectAtIndex:indexPath.row];
			break;
		case 3:
			cell.textLabel.text = [ops objectAtIndex:indexPath.row];
			break;
		case 4:
			cell.textLabel.text = [hops objectAtIndex:indexPath.row];
			break;
		case 5:
			cell.textLabel.text = [vops objectAtIndex:indexPath.row];
			break;
		case 6:
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
			return @"SOP";
			break;
		case 1:
			return @"AOP";
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
	[super dealloc];
	[users release];
	[ops release];
	[vops release];
	[hops release];
	[sops release];
	[aops release];
	[norms release];
}

@end
