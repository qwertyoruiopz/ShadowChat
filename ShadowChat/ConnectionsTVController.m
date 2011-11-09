//
//  ConnectionsTVController.m
//  ShadowChat
//
//  Created by James Long on 06/09/2011.
//  Copyright 2011 uiop. All rights reserved.
//

#import "ConnectionsTVController.h"
#import "AddConnectionTVController.h"
#import "SHIRCNetwork.h"
#import "SHIRCChannel.h"
<<<<<<< HEAD
#import "GradientView.h"
#import "ClearLabelsCellView.h"
=======
>>>>>>> a9cf0f370e2516ef5ac6ec513e4892a0fba70015
@implementation ConnectionsTVController

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
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:[self tableView]];
    [super dealloc];
}
- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:[self tableView]
                                             selector:@selector(reloadData) 
                                                 name:@"ReloadNetworks"
                                               object:nil];

    [super viewDidLoad];
    
    self.title = @"Connections";

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addConnection)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    [rightBarButtonItem release];
}

- (void)addConnection {
    NSLog(@"MUDKIPZ CONNECT! :D");
    AddConnectionTVController *addConnectionVC = [[AddConnectionTVController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *addConnectionNavController = [[UINavigationController alloc] initWithRootViewController:addConnectionVC];
    [self presentModalViewController:addConnectionNavController animated:YES];
    [addConnectionVC release];
    [addConnectionNavController release];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[SHIRCNetwork allNetworks] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
<<<<<<< HEAD
        cell = [[[ClearLabelsCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundView = [[[GradientView alloc] init] autorelease];
=======
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleBlue;
>>>>>>> a9cf0f370e2516ef5ac6ec513e4892a0fba70015
    }
    cell.textLabel.text=[[[SHIRCNetwork allNetworks] objectAtIndex:indexPath.row] descr] ? [[[SHIRCNetwork allNetworks] objectAtIndex:indexPath.row] descr] : [[[SHIRCNetwork allNetworks] objectAtIndex:indexPath.row] server];
    BOOL online;
    if ([[[SHIRCNetwork allNetworks] objectAtIndex:indexPath.row] isOpen]) {
        online = YES;
    } else {
        online = NO;
    }
<<<<<<< HEAD
    cell.detailTextLabel.text = online ? @"Connected" : @"Offline";
=======
    cell.detailTextLabel.text = online ? @"Online" : @"Offline";
>>>>>>> a9cf0f370e2516ef5ac6ec513e4892a0fba70015
    
    // Configure the cell...
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [[[SHIRCNetwork allNetworks] objectAtIndex:indexPath.row] disconnect];
        [((NSMutableArray *)[SHIRCNetwork allNetworks]) removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [SHIRCNetwork saveDefaults];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    //if ([[[SHIRCNetwork allNetworks] objectAtIndex:indexPath.row] isOpen]) {
    //    [[[SHIRCNetwork allNetworks] objectAtIndex:indexPath.row] disconnect];
    //} else {
        [[[SHIRCNetwork allNetworks] objectAtIndex:indexPath.row] connect];
    //}
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView reloadData];
}

@end
