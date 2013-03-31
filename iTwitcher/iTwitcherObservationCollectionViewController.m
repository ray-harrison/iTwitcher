//
//  iTwitcherObservationCollectionViewController.m
//  iTwitcher
//
//  Created by Raymond Harrison on 2/14/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "iTwitcherObservationCollectionViewController.h"
#import "SpeciesObservation.h"
#import "iTwitcherSpeciesViewController.h"
#import "Species.h"
#import "BirdInfoViewController.h"

@interface iTwitcherObservationCollectionViewController () {
    SpeciesObservation *_currentSpeciesObservation;
    NSString *speciesName;
    NSArray *observationSet;
}

@end

@implementation iTwitcherObservationCollectionViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    observationSet = [[self.observationGroup speciesObservations] allObjects];
}

-(void)viewWillAppear:(BOOL)animated
{
    observationSet = [[self.observationGroup speciesObservations] allObjects];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [[self.observationGroup speciesObservations] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Species Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
  
    
    SpeciesObservation *observation = [observationSet objectAtIndex:indexPath.row ];
    cell.textLabel.text = observation.species.speciesEnglishName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Birds: %d (Female:%d, Male %d, Unkown: %d)",[self speciesSum:observation],
                                 [[self countFemale:observation] intValue],[[self countMale:observation] intValue],[[self countUnknown:observation] intValue]];
    
    // Configure the cell...
    
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
    
    _currentSpeciesObservation = [observationSet objectAtIndex:indexPath.row];
    if (_currentSpeciesObservation) {
        [self performSegueWithIdentifier:@"speciesObservation" sender:self];
    } 
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddBirds"]){
        
        // First check to see if we have an existing observation at this location
        
        
        // Go to species view controller
        iTwitcherSpeciesViewController *speciesViewController =
        segue.destinationViewController;
        speciesViewController.birdDatabase = self.birdDatabase;
      //  speciesViewController.location = self.location;
        speciesViewController.observationLocation = self.observationGroup.observationCollection.observationLocation;
        
        // ObservationGroup *observationGroup = [[ObservationGroup alloc] initWithContext:[self.birdDatabase managedObjectContext] byDate:[NSDate date]];
        // [self.observationCollection addObservationGroupsObject:observationGroup];
        // [[self.birdDatabase managedObjectContext] save:nil];
        
        speciesViewController.observationGroup = self.observationGroup;
        
        
        
        
        
    }  else if ([segue.identifier isEqualToString:@"speciesObservation"]) {
        iTwitcherSpeciesObservationViewController *speciesObservationViewController = segue.destinationViewController;
        speciesObservationViewController.birdDatabase = self.birdDatabase;
      //  SpeciesObservation *speciesObservation = [[SpeciesObservation alloc] initWithContext:[self.birdDatabase managedObjectContext] ];
        speciesObservationViewController.speciesObservation = _currentSpeciesObservation;
      //  Species *speciesSelection = self.tappedSpecies;
        //[speciesObservationViewController.speciesObservation setSpecies:speciesSelection];
        
        //speciesObservationViewController.currentObservationCoordinate = self.location;
        //speciesObservationViewController.species = speciesSelection;
        //[self.observationGroup addSpeciesObservationsObject:speciesObservation];
        
        NSLog(@"Going to Species Observation");
        
        
    } else if ([segue.identifier isEqualToString:@"speciesWeb"] ) {
        
        BirdInfoViewController *birdInfoViewController = segue.destinationViewController;
        
        
        birdInfoViewController.speciesName = speciesName;
        
    }
}

-(int)speciesSum:(SpeciesObservation *)speciesObservation
{
    int sum =  [speciesObservation.femaleAdult intValue]+  [speciesObservation.femaleJuvenile intValue] + [speciesObservation.femaleImmature intValue]+[speciesObservation.femaleAgeUnknown intValue]
    + [speciesObservation.maleAdult intValue] + [speciesObservation.maleJuvenile intValue] + [speciesObservation.maleImmature intValue] + [speciesObservation.maleAgeUnkown intValue]
    + [speciesObservation.sexUnknownAdult intValue] + [speciesObservation.sexUnknownJuvenile intValue] + [speciesObservation.sexUnknownImmature intValue] + [speciesObservation.sexUnknownAgeUnknown intValue];
    return sum;
    
}

-(NSNumber *) countFemale:(SpeciesObservation *)speciesObservation
{
    return [[NSNumber alloc] initWithInt:[speciesObservation.femaleAdult intValue]+[speciesObservation.femaleJuvenile intValue]+[speciesObservation.femaleImmature intValue]+[speciesObservation.femaleAgeUnknown intValue]];
}

-(NSNumber *) countMale:(SpeciesObservation *)speciesObservation
{
    return [[NSNumber alloc] initWithInt:[speciesObservation.maleAdult intValue]+[speciesObservation.maleJuvenile intValue]+[speciesObservation.maleImmature intValue]+[speciesObservation.maleAgeUnkown intValue]];
}

-(NSNumber *) countUnknown:(SpeciesObservation *)speciesObservation
{
    return [[NSNumber alloc] initWithInt:[speciesObservation.sexUnknownAdult intValue]+[speciesObservation.sexUnknownJuvenile intValue]+[speciesObservation.sexUnknownImmature intValue]+[speciesObservation.sexUnknownAgeUnknown intValue]];
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    //species  = [[self fetchedResultsControllerForTableView:tableView] objectAtIndexPath:indexPath];
    SpeciesObservation *observation = [observationSet objectAtIndex:indexPath.row ];
     speciesName = observation.species.speciesEnglishName;
    
    [self performSegueWithIdentifier:@"speciesWeb" sender:self];
}


@end
