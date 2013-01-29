//
//  iTwitcherSpeciesViewController.m
//  iTwitcher
//
//  Created by Raymond Harrison on 1/27/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "iTwitcherSpeciesViewController.h"

@interface iTwitcherSpeciesViewController ()
{
dispatch_queue_t backgroundQueue;
NSMutableArray *searchResults;
}

@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSFetchedResultsController *searchFetchedResultsController;

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, retain) NSIndexPath *lastIndexPath;
@end

@implementation iTwitcherSpeciesViewController







@synthesize savedSearchTerm = _savedSearchTerm;
@synthesize savedScopeButtonIndex = _savedScopeButtonIndex;
@synthesize searchWasActive = _searchWasActive;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize searchFetchedResultsController = _searchFetchedResultsController;
@synthesize context = _context;
@synthesize lastIndexPath = _lastIndexPath;

//@synthesize birdDatabase = _birdDatabase;

@synthesize tappedCellSpecies = _tappedCellSpecies;

@synthesize tappedSpecies = _tappedSpecies;
/*
-(void)setBirdDatabase:(UIManagedDocument *)birdDatabase
{
    NSLog(@"In Set Bird Database");
    _birdDatabase = birdDatabase;
}
*/


- (NSFetchedResultsController *)fetchedResultsControllerForTableView:(UITableView *)tableView
{
    
    
    return  (tableView == self.tableView ? self.fetchedResultsController: self.searchFetchedResultsController);
}

-(void)setupFetchedResultsController
{
    NSLog(@"Starting setup fetched results controller");
    
    // Create a background context to query
    NSManagedObjectContext *backgroundContext = [[NSManagedObjectContext alloc] init];
    [backgroundContext setPersistentStoreCoordinator:[self.birdDatabase.managedObjectContext persistentStoreCoordinator]];
    NSLog(@"Got background context");
    self.fetchedResultsController =
    [Species newFetchedResultsControllerInManagedContext:backgroundContext];
    
    NSLog(@"Setup fetched results controller");
    
    
}

-(void)setupSearchFetchedResultsController
{
    NSManagedObjectContext *backgroundContext = [[NSManagedObjectContext alloc] init];
    if (self.birdDatabase.managedObjectContext == nil) NSLog(@"Managed Context is NULL");
    [backgroundContext setPersistentStoreCoordinator:[self.birdDatabase.managedObjectContext persistentStoreCoordinator]];
    self.searchFetchedResultsController =
    [Species newSearchFetchedResultsControllerWithSearch:[self.searchDisplayController.searchBar text]
                                        inManagedContext:backgroundContext];
}



- (void)performFetch
{
    
    if (self.fetchedResultsController) {
        
        //NSError *error=nil;
        dispatch_queue_t queryQueue = dispatch_queue_create("query queue", NULL);
        
        dispatch_async(queryQueue, ^{
            NSError *error=nil;
            [self.fetchedResultsController performFetch:&error];
            NSLog(@" Size of Fethed Objects Array %d",[self.fetchedResultsController fetchedObjects].count);
            if (error) NSLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error localizedDescription], [error localizedFailureReason]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        });
        //dispatch_release(queryQueue);
        
    } else {
        NSLog(@"No fetchResultsController!");
    }
    
    
    
    // [self.tableView reloadData];
    
}


- (void)performSearchFetch
{
    NSLog(@"Perform Search Fetch");
    if (self.searchFetchedResultsController) {
        NSError *error = nil;
        [self.searchFetchedResultsController performFetch:&error];
        if (error) {
              NSLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error localizedDescription], [error localizedFailureReason]);
        }
    
    NSLog(@" Size of Fethed Objects Array %d",[self.searchFetchedResultsController fetchedObjects].count);
    [self.searchDisplayController.searchResultsTableView reloadData];
    } else {
        [self setupSearchFetchedResultsController];
        NSLog(@"No search fetched view controller");
    }
    /*
    if (self.searchFetchedResultsController) {
        
        dispatch_queue_t queryQueue = dispatch_queue_create("query queue", NULL);
        dispatch_async(queryQueue, ^{
            
            NSError *error = nil;
            [self.searchFetchedResultsController performFetch:&error];
            
            if (error) {  NSLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error localizedDescription], [error localizedFailureReason]);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.searchDisplayController.searchResultsTableView reloadData];
                
            });
        });
        
        
        
    } else {
        [self setupSearchFetchedResultsController];
        NSLog(@"No search fetched view controller");
    }
     */
    
}


- (void)setFetchedResultsController:(NSFetchedResultsController *)newfrc
{
    NSLog(@"Setting fetched results controller");
    NSFetchedResultsController *oldfrc = _fetchedResultsController;
    if (newfrc != oldfrc) {
        _fetchedResultsController = newfrc;
        newfrc.delegate = self;
        // if ((!self.title || [self.title isEqualToString:oldfrc.fetchRequest.entity.name]) && (!self.navigationController || !self.navigationItem.title)) {
        //   self.title = newfrc.fetchRequest.entity.name;
        //}
        if (newfrc) {
            NSLog(@"Performing Fetch");
            [self performFetch];
            NSLog(@" Size of Fethed Objects Array %d",[self.fetchedResultsController fetchedObjects].count);
            NSLog(@"Performed Fetch");
            
        } else {
            NSLog(@"Reload Table Data");
            
            [self.tableView reloadData];
            NSLog(@"Reloaded Table Data");
        }
    }
}

- (void)setSearchFetchedResultsController:(NSFetchedResultsController *)newfrc
{
    
    
    NSFetchedResultsController *oldfrc = _searchFetchedResultsController;
    if (newfrc != oldfrc) {
        
        _searchFetchedResultsController = newfrc;
        
        newfrc.delegate = self;
        // if ((!self.title || [self.title isEqualToString:oldfrc.fetchRequest.entity.name]) && (!self.navigationController || !self.navigationItem.title)) {
        //   self.title = newfrc.fetchRequest.entity.name;
        //}
        if (newfrc) {
            
            
            [self performSearchFetch];
            [self.searchDisplayController.searchResultsTableView reloadData];
        } else {
            
            
            [self performSearchFetch];
            [self.searchDisplayController.searchResultsTableView reloadData];
            
        }
    } else {
        [self setupSearchFetchedResultsController];
        [self performSearchFetch];
        // [self.searchDisplayController.searchResultsTableView reloadData];
    }
}



#pragma mark - View Lifecycle


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"View will appear");
    
    
    
    // [self.tableView reloadData];
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"View Did Load");
    
    [self loadDocument];
    
    if (self.savedSearchTerm)
    {
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:self.savedSearchTerm];
        
        self.savedSearchTerm = nil;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Load UI Managed Document
-(void)loadDocument
{
    NSURL *url = nil;
    if (!self.birdDatabase) {
        NSLog(@"Init Bird Datbase");
        
        url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"iBirderDatabase"];
        self.birdDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
    }
}


- (void)setBirdDatabase:(UIManagedDocument *)birdDatabase
{
    
    if (_birdDatabase != birdDatabase) {
        _birdDatabase = birdDatabase;
        [self useDocument];
        
    }
}


- (void)useDocument
{
    NSLog(@"Location %@",self.birdDatabase.fileURL);
    if (self.birdDatabase.documentState == UIDocumentStateClosed) {
        // exists on disk, but we need to open it
        
        [self.birdDatabase openWithCompletionHandler:^(BOOL success) {
            [self setupFetchedResultsController];
            
            
        }];
    } else if (self.birdDatabase.documentState == UIDocumentStateNormal) {
        // already open and ready to use
        
        [self setupFetchedResultsController];
        
    }
}
/*
- (void)setBirdDatabase:(UIManagedDocument *)birdDatabase
{
    
    if (_birdDatabase != birdDatabase) {
        _birdDatabase = birdDatabase;
        [self useDocument];
        self.context = [self birdDatabase].managedObjectContext;
    }
}
*/





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = [[[self fetchedResultsControllerForTableView:tableView] sections] count];
    
    return count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    NSFetchedResultsController *fetchController = [self fetchedResultsControllerForTableView:tableView];
    NSArray *sections = fetchController.sections;
    if(sections.count > 0)
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = sections[section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    
    return numberOfRows;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Species Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //     cell = [[UITableViewCell alloc]
        //             initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        // UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoLight];
        // cell.imageView.image = button.imageView.image;
        
    }
    
    
    
    // Configure the cell...
    
    Species *species = nil;
    species = [[self fetchedResultsControllerForTableView:tableView] objectAtIndexPath:indexPath];
    
    
    //  [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    //  if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
    //     if (self.tappedCellSpecies && ![self.tappedCellSpecies containsObject:species]) {
    //      cell.accessoryType = UITableViewCellAccessoryNone;
    //     }
    //
    //   }
    cell.textLabel.text = species.speciesEnglishName;
    
    cell.detailTextLabel.text = species.genusLatinName;
    
    cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
    
    
    
    return cell;
}



#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath");
    // [self performSegueWithIdentifier:@"observationDetails" sender:self];
    // self.tappedSpecies = [[self fetchedResultsControllerForTableView:tableView] objectAtIndexPath:indexPath];
    
    //  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //  cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    //cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    /*
     if (!self.tappedCellSpecies) {
     self.tappedCellSpecies = [[NSMutableArray alloc] init];
     }
     Species * species = [[self fetchedResultsControllerForTableView:tableView] objectAtIndexPath:indexPath];
     if (self.tappedCellSpecies && ![[self tappedCellSpecies] containsObject:species]) {
     [[self tappedCellSpecies] addObject:species];
     }
     */
    
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        [self.searchDisplayController setActive:NO animated:YES];
        
        
        
        
        
        
    }
    
    
    
    
    
    
}


/*
 - (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
 {
 NSLog(@"Did Select Row");
 
 
 UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
 
 //cell.accessoryType = UITableViewCellAccessoryNone;
 self.tappedSpecies = [[self fetchedResultsControllerForTableView:tableView] objectAtIndexPath:indexPath];
 // if (self.tappedCellSpecies && [[self tappedCellSpecies] containsObject:species]) {
 
 //    [[self tappedCellSpecies] removeObject:species];
 // }
 }
 */

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([[self fetchedResultsControllerForTableView:tableView] sections] == nil) {
        NSLog(@"Search fetchResultsController is nil");
    }
    
    return [[[self fetchedResultsControllerForTableView:tableView] sections][section] name];
    
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [[self fetchedResultsControllerForTableView:tableView] sectionForSectionIndexTitle:title atIndex:index];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [[self fetchedResultsControllerForTableView:tableView] sectionIndexTitles];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    
    if ([segue.identifier isEqualToString:@"observation"] ) {
        NSLog(@"Observation Segue");
        
     //   iBirderObservationViewController *observationController = segue.destinationViewController;
      //  observationController.speciesName = self.tappedSpecies.englishName;
        
    } else if ([segue.identifier isEqualToString:@"birdWiki"] ) {
        
      //  BirdInfoViewController *birdInfoViewController = segue.destinationViewController;
        
        
     //   birdInfoViewController.speciesName = [self.tappedSpecies englishName];
        
    } else if ([segue.identifier isEqualToString:@"observationDetails"]) {
        NSLog(@"Observation Details Segue");
       // iBirderObservationDetailViewController *observationDetailViewController = segue.destinationViewController;
      //  observationDetailViewController.navigationController.title=@"Observation Detail";
        
    }
    
    
}


- (void)fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController configureCell:(UITableViewCell *)theCell atIndexPath:(NSIndexPath *)theIndexPath
{
    // your cell guts here
}






#pragma mark -
#pragma mark Content Filtering
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSInteger)scope
{
    
    
    //  searchResults =  [NSMutableArray arrayWithArray:[self.searchFetchedResultsController fetchedObjects]];
    
    
    self.searchFetchedResultsController = nil;
    
    self.searchFetchedResultsController.delegate = nil;
    
    
    // [NSFetchedResultsController deleteCacheWithName:[self.searchFetchedResultsController cacheName]];
}



#pragma mark -
#pragma mark Search Bar
/*
 - (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
 {
 tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
 [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLineEtched];
 [tableView setAllowsMultipleSelectionDuringEditing:YES];
 
 
 }
 
 - (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
 {
 tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
 
 [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLineEtched];
 [tableView setAllowsMultipleSelectionDuringEditing:YES];
 
 }
 */
/* Uncomment to get back to normal
 - (void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView;
 {
 //   [self.filteredList removeAllObjects];
 //   [self.tappedCellSpecies removeAllObjects];
 self.searchFetchedResultsController = nil;
 self.searchFetchedResultsController.delegate = nil;
 }
 */

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
    //  [searchResults removeAllObjects];
    //	[searchResults addObjectsFromArray:[[self.searchFetchedResultsController fetchedObjects] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"englishName CONTAINS[cd] %@", searchString]]];
    
    [self filterContentForSearchText:searchString
                               scope:[self.searchDisplayController.searchBar selectedScopeButtonIndex]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text]
                               scope:[self.searchDisplayController.searchBar selectedScopeButtonIndex]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    //[self.filteredListContent removeAllObjects];
    // self.searchFetchedResultsController = nil;
    // self.searchFetchedResultsController.delegate = nil;
    
}

/*
 
 -(NSFetchedResultsController *)fetchedResultsController
 {
 if (_fetchedResultsController != nil) {
 return _fetchedResultsController;
 } else {
 
 
 if (!self.birdDatabase.managedObjectContext) [self useDocument];
 
 dispatch_queue_t queryQueue = dispatch_queue_create("query queue", NULL);
 dispatch_async(queryQueue, ^{
 
 _fetchedResultsController = [Species newFetchedResultsControllerInManagedContext:self.birdDatabase.managedObjectContext];
 dispatch_async(dispatch_get_main_queue(), ^{
 [self.tableView reloadData];
 });
 });
 
 
 
 
 return _fetchedResultsController;
 }
 
 }
 */

/*
 -(NSFetchedResultsController *)searchFetchedResultsController
 {
 if (_searchFetchedResultsController != nil) {
 return _searchFetchedResultsController;
 } else {
 NSLog(@"searchFetchedResultsController");
 //  if (!self.birdDatabase.managedObjectContext) [self useDocument];
 
 _searchFetchedResultsController = [Species newSearchFetchedResultsControllerWithSearch:self.searchDisplayController.searchBar.text inManagedContext:self.birdDatabase.managedObjectContext];
 
 
 return _searchFetchedResultsController;
 }
 
 }
 */


#pragma mark - NSFetchedResultsControllerDelegate

/*
 * Convenience method for returning the appropriate table view based on the controller
 */

- (UITableView *) tableViewForController:(NSFetchedResultsController *)controller
{
    
    UITableView *tableView = (controller == self.fetchedResultsController) ? self.tableView : self.searchDisplayController.searchResultsTableView;
    return tableView;
    
}



- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    UITableView *tableView = controller == self.fetchedResultsController ? self.tableView : self.searchDisplayController.searchResultsTableView;
    [tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex
	 forChangeType:(NSFetchedResultsChangeType)type
{
    // if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext)
    // {
    NSLog(@"didChangeSection");
    
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            
            [[self tableViewForController:controller] insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            [[self tableViewForController:controller] reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            
            [[self tableViewForController:controller] deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            [[self tableViewForController:controller] reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            
            break;
        case NSFetchedResultsChangeUpdate:
            
            break;
            
    }
    // }
}




- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath
{
    NSLog(@"didChangeObject");
    // if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext)
    // {
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            
            [[self tableViewForController:controller] insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
        case NSFetchedResultsChangeDelete:
            
            [[self tableViewForController:controller] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
        case NSFetchedResultsChangeUpdate:
            
            [[self tableViewForController:controller] reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            
            [[self tableViewForController:controller] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [[self tableViewForController:controller] insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
    // }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    UITableView *tableView = controller == self.fetchedResultsController ? self.tableView : self.searchDisplayController.searchResultsTableView;
    [tableView endUpdates];
    
}



-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    self.tappedSpecies = [[self fetchedResultsControllerForTableView:tableView] objectAtIndexPath:indexPath];
    
    [self performSegueWithIdentifier:@"birdWiki" sender:self];
}





@end
