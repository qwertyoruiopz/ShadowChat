//
//  ConnectionsTVController.m
//  ShadowChat
//
//  Created by James Long on 06/09/2011.
//  Copyright 2011 uiop. All rights reserved.
//

#import "SHConnectionController.h"


@implementation SHConnectionController
@synthesize nothingView;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return 60;
}

- (id)initWithStyle:(UITableViewStyle)style {
	if ((self = [super initWithStyle:style])) {
		isCellSwiped = NO;
		self.tableView.delegate = self;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (isCellSwiped) {
		[swipedCell undrawOptionsViewAnimated:YES];
		isCellSwiped = NO;
	}
}

- (void)clearCellSwiped:(id)c {
	if (isCellSwiped) {
		[swipedCell undrawOptionsViewAnimated:YES];
	}
	isCellSwiped = YES;
	swipedCell = (SHClearLabelCellView *)c;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return isReallyEditing;
}

- (void)cellReturned {
	swipedCell = nil;
	isCellSwiped = NO;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:[self tableView]];
	[super dealloc];
}

- (void)viewDidLoad {
	[[NSNotificationCenter defaultCenter] addObserver:[self tableView]
											 selector:@selector(reloadData) 
												 name:@"ReloadNetworks"
											   object:nil];
    
	[super viewDidLoad];
	[self.view addSubview:nothingView];
	[nothingView setAlpha:0];
	self.title = @"Connections";
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit)];
	self.navigationItem.leftBarButtonItem = rightBarButtonItem;
	[rightBarButtonItem release];
	self.tableView.allowsSelectionDuringEditing = YES;
}

- (void)editConnectionForCell:(SHClearLabelCellView *)cell {
	NSLog(@"Cell: %@",cell);
	for (SHIRCNetwork *n in [SHIRCNetwork allNetworks]) {
		if ([[n.server lowercaseString] isEqualToString:[cell.detailTextLabel.text lowercaseString]]) {
			NSLog(@"Found which network....%@", n);
			SHAddCTController *tmp = [[SHAddCTController alloc] initWithStyle:UITableViewStyleGrouped andNetwork:n];
			UINavigationController *addConnectionNavController = [[UINavigationController alloc] initWithRootViewController:tmp];
			[self presentModalViewController:addConnectionNavController animated:YES];
			[tmp release];
			[addConnectionNavController release];
			break;
		}
	}
	NSLog(@"Nothing found..:(");
}

/* Maybe one day i will try to reincarnate this concept.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return !([[SHIRCNetwork allNetworks] count] == indexPath.row);
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	
}*/

- (void)edit {
	[self scrollViewDidScroll:nil];
	// fix... So the cell wasn't hidden for some odd reason when set editing..
    isReallyEditing = !isReallyEditing;
    [((UITableView *)self.view) setEditing:!isReallyEditing animated:NO];
    [((UITableView *)self.view) setEditing:isReallyEditing animated:YES];
	UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:([((UITableView*)self.view) isEditing] ? UIBarButtonSystemItemDone : UIBarButtonSystemItemEdit) target:self action:@selector(edit)];
	self.navigationItem.leftBarButtonItem = rightBarButtonItem;
	[rightBarButtonItem release];
	[((UITableView *)self.view) beginUpdates]; 
	(isReallyEditing ?
     [((UITableView *)self.view) insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[[SHIRCNetwork allNetworks] count] inSection:0]] withRowAnimation:UITableViewRowAnimationTop] :
     [((UITableView *)self.view) deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[[SHIRCNetwork allNetworks] count] inSection:0]] withRowAnimation:UITableViewRowAnimationTop]);
    [((UITableView *)self.view) endUpdates];
}

- (void)addConnection {
	SHAddCTController *addConnectionVC = [[SHAddCTController alloc] initWithStyle:UITableViewStyleGrouped andNetwork:nil];
	UINavigationController *addConnectionNavController = [[UINavigationController alloc] initWithRootViewController:addConnectionVC];
	[self presentModalViewController:addConnectionNavController animated:YES];
	[addConnectionVC release];
	[addConnectionNavController release];
}

- (void)viewDidUnload {
    [super viewDidUnload];
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
    return YES; // (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	NSLog(@"Rotating.... %@", swipedCell);
	if (swipedCell != nil) {
		[swipedCell undrawOptionsViewAnimated:YES];
		[self.tableView reloadData];
	}
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	[self updateNoNetworks];
	return (isReallyEditing ? [[SHIRCNetwork allNetworks] count] +1 : [[SHIRCNetwork allNetworks] count]);
}

- (int)updateNoNetworks {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5f];
	if (([[SHIRCNetwork allNetworks] count] !=0) || isReallyEditing)
		[nothingView setAlpha:0];
	else
		[nothingView setAlpha:1];
	[UIView commitAnimations];
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
    
	SHClearLabelCellView *cell = (SHClearLabelCellView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[SHClearLabelCellView alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundView = [[[SHGradientView alloc] initWithFrame:CGRectZero reversed:NO] autorelease];
		cell.delegate = self;
	}
	if ([[SHIRCNetwork allNetworks] count] == indexPath.row) {
		cell.textLabel.text = @"Add an IRC Network";
		cell.detailTextLabel.text = @"Click here to configure a new network";
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        [cell undrawOptionsViewAnimated:YES];
		return cell;
	}
    cell.textLabel.text = [[[SHIRCNetwork allNetworks] objectAtIndex:indexPath.row] descr] ? [[[SHIRCNetwork allNetworks] objectAtIndex:indexPath.row] descr] : [[[SHIRCNetwork allNetworks] objectAtIndex:indexPath.row] server];
	if ([[[SHIRCNetwork allNetworks] objectAtIndex:indexPath.row] isRegistered]) {
		cell.thirdLabel.text = @"Connected!";
    }
	else if ([((SHIRCSocket *)[((SHIRCNetwork *)[[SHIRCNetwork allNetworks] objectAtIndex:indexPath.row]) socket]) status] == SHSocketStausError) {
		cell.thirdLabel.text = @"Error connecting to the server";
    }
	else {
		cell.thirdLabel.text = [[[SHIRCNetwork allNetworks] objectAtIndex:indexPath.row] isOpen] ? @"Connecting..." : @"Disconnected.";
    }
	cell.detailTextLabel.text = ((SHIRCNetwork *)[[SHIRCNetwork allNetworks] objectAtIndex:indexPath.row]).server;
/* 	cell.detailTextLabel.text = [((SHIRCNetwork *)[[SHIRCNetwork allNetworks] objectAtIndex:indexPath.row]).server ? ((SHIRCNetwork *)[[SHIRCNetwork allNetworks] objectAtIndex:indexPath.row]).server : @"" lowercaseString];
 
	previously here...^
	not really necessary.. if the server address if null, we can't connect anyways, we shouldn't be able to add a network if the server is null...
 
 */

    [cell.thirdLabel sizeToFit];
    [cell undrawOptionsViewAnimated:NO];
    return cell;
}


// Override to support conditional editing of the table view.

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[SHIRCNetwork allNetworks] count] == indexPath.row) {
        return UITableViewCellEditingStyleInsert;
    }
	return UITableViewCellEditingStyleDelete;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [[[SHIRCNetwork allNetworks] objectAtIndex:indexPath.row] disconnect];
        [((NSMutableArray *)[SHIRCNetwork allNetworks]) removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [SHIRCNetwork saveDefaults];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        [self addConnection];
        [self performSelector:@selector(edit)];
    }
}



#pragma mark - Table view delegate
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path {
    // Determine if row is selectable based on the NSIndexPath.
    if (![tv isEditing] || [[SHIRCNetwork allNetworks] count] == path.row) {
        return path;
	}
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[tableView cellForRowAtIndexPath:indexPath] selectionStyle] == UITableViewCellSelectionStyleNone) return;
    if ([[SHIRCNetwork allNetworks] count] == indexPath.row) {
        [self addConnection];
		[self performSelector:@selector(edit)];
        return;
    }
    if ([[[SHIRCNetwork allNetworks] objectAtIndex:indexPath.row] isOpen])
        [[[SHIRCNetwork allNetworks] objectAtIndex:indexPath.row] disconnect];
    else if ([((SHIRCSocket *)[((SHIRCNetwork *)[[SHIRCNetwork allNetworks] objectAtIndex:indexPath.row]) socket]) status] == SHSocketStausError) 
        goto nothing;
    else
        [[[SHIRCNetwork allNetworks] objectAtIndex:indexPath.row] connect];
nothing:
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadData];
}

@end
