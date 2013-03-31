//
//  SpeciesListDetailTableViewController.m
//  iTwitcher
//
//  Created by Raymond Harrison on 3/22/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "SpeciesListDetailTableViewController.h"
#import "SpeciesObservation+Query.h"
#import "ObservationCollection.h"
#import "ObservationGroup.h"
#import "ObservationLocation.h"
#import "ObservationLocation+Query.h"
#import "Species.h"

@interface SpeciesListDetailTableViewController () {
    ObservationGroup *_currentObservationGroup;
    SpeciesObservation *_currentSpeciesObservation;
}
@property (nonatomic, strong) NSArray *speciesObservations;
@property (nonatomic, strong) NSArray *observationLocations;

@end

@implementation SpeciesListDetailTableViewController

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
    self.speciesObservations = [SpeciesObservation speciesObservations:[self.birdDatabase managedObjectContext]  bySpeciesName:self.speciesName];
    self.observationLocations = [ObservationLocation queryObservationLocations:[self.birdDatabase managedObjectContext] bySpeciesName:self.speciesName];
    NSLog(@"Species Observations Count %d",[self.speciesObservations count]);
    self.navigationItem.title = self.speciesName;
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

    return [self.observationLocations count]>0?[self.observationLocations count]:1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
   
    
    return ((ObservationLocation *)self.observationLocations[section]).name;
}
 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     NSArray *titles = [self observationLocationsBySpeciesObservations];
     NSString *name = ((ObservationLocation *)titles[section]).name;
    NSLog(@"COUNT %d",[[ObservationLocation searchLocationByName:name inContext:[self.birdDatabase managedObjectContext] bySpeciesName:self.speciesName] count]);
    NSLog(@"NUMBER OF LOCATIONS %d",[[ObservationLocation queryObservationLocations:[self.birdDatabase managedObjectContext] bySpeciesName:self.speciesName] count]);
    // Return the number of rows in the section.
    return [self observationCountByLocationName:name];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"speciesObservationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSArray *speciesObservations = [self speciesObservationsBySection:indexPath.section];
    SpeciesObservation *speciesObservation = speciesObservations[indexPath.row];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
    NSString *dateString = [dateFormat stringFromDate:speciesObservation.date];
    cell.textLabel.text = [NSString stringWithFormat:@"Date: %@",dateString];
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
    NSArray *speciesObservations = [self speciesObservationsBySection:indexPath.section];
    _currentSpeciesObservation = speciesObservations[indexPath.row];
    _currentObservationGroup = _currentSpeciesObservation.observationGroup;
    [self performSegueWithIdentifier:@"speciesObservation" sender:self];
    
}
-(NSArray *)observationLocationsBySpeciesObservations
{
    NSMutableArray *mutableLocationArray = [[NSMutableArray alloc] initWithCapacity:1];
    NSLog(@"in ObservationLocations");
    for (SpeciesObservation *speciesObservation in self.speciesObservations) {
        NSLog(@"In forLoop in ObservationLocations");
        ObservationGroup *observationGroup = speciesObservation.observationGroup;
        ObservationCollection *observationCollection = observationGroup.observationCollection;
        ObservationLocation *observationLocation = observationCollection.observationLocation;
        if (![mutableLocationArray containsObject:observationLocation]) {
          [mutableLocationArray addObject:observationLocation];  
        }
    }
    NSLog(@"Loaded array in ObservationLocations");
 //   NSArray *resultsArray = [[NSArray alloc] initWithArray:mutableLocationArray];
    

    
    NSArray *sortedResultsArray = [mutableLocationArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *locationName1 = [(ObservationLocation *)obj1 name];
        NSString *locationName2 = [(ObservationLocation *)obj2 name];
        return [locationName2 compare:locationName1];
    }];
    NSLog(@"Sorted array size in ObservationLocations %d",[sortedResultsArray count]);
    return sortedResultsArray;
}

-(int)observationCountByLocationName:(NSString *)locationName
{
    int count = 0;
    for (SpeciesObservation *speciesObservation in self.speciesObservations) {
        
        ObservationGroup *observationGroup = speciesObservation.observationGroup;
        ObservationCollection *observationCollection = observationGroup.observationCollection;
        ObservationLocation *observationLocation = observationCollection.observationLocation;
        if([observationLocation.name isEqualToString:locationName]) {
            count++;
        }

    }
    return count;
}
-(NSString *)locationNameFromLocation:(ObservationLocation *)observationLocation
{
    return observationLocation.name;
}

-(NSArray *)speciesObservationsBySection:(NSInteger) section
{
    
    ObservationLocation *observationLocation = self.observationLocations[section];
    
    int count = 0;
    NSMutableArray *locations = [[NSMutableArray alloc] initWithCapacity:1];
    
    for (ObservationCollection *observationCollection in observationLocation.observationCollections) {
            for (ObservationGroup *observationGroup in observationCollection.observationGroups) {
                for (SpeciesObservation *speciesObservation in observationGroup.speciesObservations) {
                    if ([speciesObservation.species.speciesEnglishName isEqualToString:self.speciesName]) {
                        [locations addObject:speciesObservation];
                        count++;
                    }
                }
            }
            
        }
    return locations;
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   if ([segue.identifier isEqualToString:@"speciesObservation"]) {
    SpeciesObservationViewController *speciesObservationViewController = segue.destinationViewController;
    speciesObservationViewController.birdDatabase = self.birdDatabase;
    //  SpeciesObservation *speciesObservation = [[SpeciesObservation alloc] initWithContext:[self.birdDatabase managedObjectContext] ];
    speciesObservationViewController.speciesObservation = _currentSpeciesObservation;
    speciesObservationViewController.observationGroup = _currentSpeciesObservation.observationGroup;
    
    //NSLog(@"SPECIES COLLECTION %@",_currentSpeciesObservation.observationGroup.observationCollection);
    speciesObservationViewController.delegate = self;
   }
}

-(void)didManipulateObservation:(SpeciesObservationViewController *)controller speciesObservation:(SpeciesObservation *)speciesObservation
{
    
    
    NSLog(@"Did Manipulate Observation");
}

@end
