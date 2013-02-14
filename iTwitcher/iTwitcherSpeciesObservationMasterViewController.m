//
//  iTwitcherSpeciesObservationMasterViewController.m
//  iTwitcher
//
//  Created by Raymond Harrison on 2/5/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "iTwitcherSpeciesObservationMasterViewController.h"
#import "iTwitcherSpeciesViewController.h"
#import "ObservationGroup+Query.h"
#import "ObservationCollection+Query.h"
#import "Species.h"
#import "Subspecies.h"

@interface iTwitcherSpeciesObservationMasterViewController ()
{
    NSMutableArray *observationGroups;
    NSMutableArray *birdNames;
}

//@property (nonatomic, strong) ObservationCollection *currentObservationCollection;

@end

@implementation iTwitcherSpeciesObservationMasterViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

-(void)viewDidAppear:(BOOL)animated
{
   // [super viewWillAppear:animated];
    // See if there exists obersvation data for this location
    observationGroups = [NSMutableArray arrayWithArray:[self.observationCollection.observationGroups allObjects]];
    if ([observationGroups count]==0) {
        birdNames = [[NSMutableArray alloc] initWithCapacity:1];
        
        [birdNames addObject:@"Today"];
    }
    NSLog(@"Bird Names Count %d",[birdNames count]);
    for (ObservationGroup *observationGroup in observationGroups) {
        NSLog(@"Observation Group Count %d",[observationGroups count]);
        for (SpeciesObservation *observation in observationGroup.speciesObservations) {
            Species *species = observation.species;
            [birdNames addObject:species.speciesEnglishName];
           // Subspecies *subspecies = observation.subspecies;
            
            //[birdNames addObject:[subspecies.species.speciesEnglishName stringByAppendingFormat:@" - %@",subspecies.subspeciesLatinName]];
            
        }
    }
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    
    return [observationGroups count]>0?[observationGroups count]:1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [birdNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
    // Configure the cell...
    cell.textLabel.text = [birdNames objectAtIndex:indexPath.row]; 
    return cell;
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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (IBAction)doneAction:(id)sender {
    
    // Create or update here
    
    [self.observationMasterDelegate didCreateObservationCollection:self observationCollection:self.observationCollection];
}

- (IBAction)cancelAction:(id)sender {
    // This will remove the annotation on the map
    
    [self.observationMasterDelegate didCancel:self];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddBirds"]){
        
        // First check to see if we have an existing observation at this location
        
  
            // Go to species view controller
            iTwitcherSpeciesViewController *speciesViewController =
            segue.destinationViewController;
            speciesViewController.birdDatabase = self.birdDatabase;
            speciesViewController.location = self.location;
            speciesViewController.observationLocation = self.observationLocation;
        
            ObservationGroup *observationGroup = [[ObservationGroup alloc] initWithContext:[self.birdDatabase managedObjectContext] byDate:[NSDate date]];
            [self.observationCollection addObservationGroupsObject:observationGroup];
            [[self.birdDatabase managedObjectContext] save:nil];
            speciesViewController.observationGroup = observationGroup;
        
   
        
        
        
    }
}


@end
