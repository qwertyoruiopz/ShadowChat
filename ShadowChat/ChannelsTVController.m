//
//  ChannelsTVController.m
//  ShadowChat
//
//  Created by James Long on 07/09/2011.
//  Copyright 2011 uiop. All rights reserved.
//

#import "ChannelsTVController.h"
#import "SHClearLabelCellView.h"
#import "SHGradientView.h"
#import "SHIRCNetwork.h"
#import <QuartzCore/QuartzCore.h>
#import "SHChatPanel.h"
#import "SHChanJoin.h"

@implementation ChannelsTVController

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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:[self tableView]];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:[self tableView]
                                             selector:@selector(reloadData) 
                                                 name:@"ReloadChans"
                                               object:nil];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [[NSNotificationCenter defaultCenter] addObserver:[self tableView]
                                             selector:@selector(reloadData) 
                                                 name:@"ReloadNetworks"
                                               object:nil];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    [leftBarButtonItem release];
    self.tableView.allowsSelectionDuringEditing = YES;
}

- (void)edit
{
    isReallyEditing=!isReallyEditing;
    [((UITableView*)self.view) setEditing:!isReallyEditing animated:NO];
    [((UITableView*)self.view) setEditing:isReallyEditing animated:YES];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:([((UITableView*)self.view) isEditing] ? UIBarButtonSystemItemDone : UIBarButtonSystemItemEdit) target:self action:@selector(edit)];
    self.navigationItem.leftBarButtonItem = rightBarButtonItem;
    [rightBarButtonItem release];
    [((UITableView*)self.view) beginUpdates]; 
    int net=[self numberOfSectionsInTableView:nil];
    while (net--) {
    (
     isReallyEditing ?
     [((UITableView*)self.view) insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[self tableView:nil numberOfRowsInSection:net]-1 inSection:net]] withRowAnimation:UITableViewRowAnimationTop] :
     [((UITableView*)self.view) deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[self tableView:nil numberOfRowsInSection:net] inSection:net]] withRowAnimation:UITableViewRowAnimationTop]
     );
    }
    [((UITableView*)self.view) endUpdates];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self tableView] reloadData];
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
    return [[SHIRCNetwork allConnectedNetworks] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[(SHIRCNetwork*)[[SHIRCNetwork allConnectedNetworks] objectAtIndex:section] socket] channels] count] + isReallyEditing;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[[SHIRCNetwork allConnectedNetworks] objectAtIndex:section] descr] ? [[[SHIRCNetwork allConnectedNetworks] objectAtIndex:section] descr] : [[[SHIRCNetwork allConnectedNetworks] objectAtIndex:section] server];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    SHClearLabelCellView *cell = (SHClearLabelCellView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[SHClearLabelCellView alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundView = [[[SHGradientView alloc] initWithFrame:CGRectZero  reversed: NO] autorelease];
		cell.accessoryView = [[[SHGradientView alloc] initWithFrame:CGRectMake(0, 0, 70, 30)  reversed: YES] autorelease];
        cell.accessoryView.layer.cornerRadius = 8;
		cell.thirdLabel.hidden = YES;
		cell.delegate = self;
	}
    if ([[[(SHIRCNetwork*)[[SHIRCNetwork allConnectedNetworks] objectAtIndex:indexPath.section] socket] channels] count] == indexPath.row) {
        cell.textLabel.text = @"Join a channel";
    } else
    cell.textLabel.text=[((SHIRCChannel *)[[[(SHIRCNetwork*)[[SHIRCNetwork allConnectedNetworks] objectAtIndex:indexPath.section] socket] channels] objectAtIndex:indexPath.row]) formattedName];
    // Confgure the cell...
    
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
        //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self tableView:nil numberOfRowsInSection:indexPath.section]-1==indexPath.row) {
        return UITableViewCellEditingStyleInsert;
    }
    return UITableViewCellEditingStyleDelete;
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
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    // Determine if row is selectable based on the NSIndexPath.
    NSLog(@"OMFG, %@", path);
    if (![tv isEditing]) {
        return path;
    } else
        if ([self tableView:nil numberOfRowsInSection:path.section]-1==path.row)
        {
            return path;
        }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self tableView:nil numberOfRowsInSection:indexPath.section]-1==indexPath.row&&[tableView isEditing])
    {
        SHChanJoin *addChanVC = [[SHChanJoin alloc] initWithStyle:UITableViewStyleGrouped];
        [addChanVC setNetwork:[[SHIRCNetwork allConnectedNetworks] objectAtIndex:indexPath.section]];
        UINavigationController *addChanNavController = [[UINavigationController alloc] initWithRootViewController:addChanVC];
        [self presentModalViewController:addChanNavController animated:YES];
        [addChanVC release];
        [addChanNavController release];
        [self performSelector:@selector(edit)];
        goto end;
    }
    id vc=nil;
    vc=[[SHChatPanel alloc] initWithChan:[[[(SHIRCNetwork*)[[SHIRCNetwork allConnectedNetworks] objectAtIndex:indexPath.section] socket] channels] objectAtIndex:indexPath.row]];
    [[self navigationController] pushViewController:vc animated:YES];
    end:
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
