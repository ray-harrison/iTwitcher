//
//  iTwitcherSpeciesObservationMasterViewController.m
//  iTwitcher
//
//  Created by Raymond Harrison on 2/5/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "iTwitcherSpeciesObservationMasterViewController.h"
#import "iTwitcherSpeciesViewController.h"
#import "iTwitcherObservationCollectionViewController.h"
#import "ObservationGroup+Query.h"
#import "ObservationCollection+Query.h"
#import "Species.h"
#import "Subspecies.h"

@interface iTwitcherSpeciesObservationMasterViewController ()
{
    NSMutableArray *observationGroups;
    ObservationGroup *_currentObservationGroup;
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
   // self.tableView.delegate = self;
  //  self.tableView.dataSource = self;
    observationGroups = [NSMutableArray arrayWithArray:[self.observationCollection.observationGroups allObjects]];
   // self.navigationController.navigationBar.delegate = self;
    
    self.observationNameButton.titleLabel.text = self.observationCollection.name;
  //  [self.tableView reloadData];
}
/*
-(void)viewWillAppear:(BOOL)animated
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
        NSLog(@"Observation Group %@",observationGroup.date);
        for (SpeciesObservation *observation in observationGroup.speciesObservations) {
            Species *species = observation.species;
            [birdNames addObject:species.speciesEnglishName];
           // Subspecies *subspecies = observation.subspecies;
            
            //[birdNames addObject:[subspecies.species.speciesEnglishName stringByAppendingFormat:@" - %@",subspecies.subspeciesLatinName]];
            
        }
    }
    
    [self.tableView reloadData];
 
}
*/

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"View Did Appear");
    self.observationNameButton.titleLabel.text = self.observationCollection.name;
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
    //return [observationGroups count]>0?[observationGroups count]:1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"observationGroups count %d",[observationGroups count]);
    // Return the number of rows in the section.
    return [observationGroups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    NSLog(@"Cell for row at index path");
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
    // Configure the cell...
    ObservationGroup *observationGroup = [observationGroups objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",observationGroup.date];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Species:%d Birds:%d",[self speciesCount:observationGroup],[self birdCount:observationGroup]];
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
     _currentObservationGroup = [observationGroups objectAtIndex:indexPath.row];
    if ([[_currentObservationGroup speciesObservations] count]>0) {
        [self performSegueWithIdentifier:@"collectionGroup" sender:self];
    } else {
       [self performSegueWithIdentifier:@"AddBirds" sender:self];
    }
    
}

- (IBAction)doneAction:(id)sender {
    
    // Create or update here
    
    [self.observationMasterDelegate didCreateObservationCollection:self observationCollection:self.observationCollection];
}

- (IBAction)cancelAction:(id)sender {
    // This will remove the annotation on the map
    
    [self.observationMasterDelegate didCancel:self];
}


-(void) didChooseSave:(iTwitcherSpeciesObservationDescriptionViewController *)controller observationLocation:(ObservationCollection *)observationCollection
{
    self.observationCollection = observationCollection;
    [[self.birdDatabase managedObjectContext] save:nil];
    self.observationNameButton.titleLabel.text = self.observationCollection.name;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) didCancel:(iTwitcherSpeciesObservationDescriptionViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
        
           // ObservationGroup *observationGroup = [[ObservationGroup alloc] initWithContext:[self.birdDatabase managedObjectContext] byDate:[NSDate date]];
           // [self.observationCollection addObservationGroupsObject:observationGroup];
           // [[self.birdDatabase managedObjectContext] save:nil];
        
            speciesViewController.observationGroup = _currentObservationGroup;
        
   
        
        
        
    } else if([segue.identifier isEqualToString:@"collectionGroup"] ) {
        iTwitcherObservationCollectionViewController *speciesGroupViewController =
        segue.destinationViewController;
        speciesGroupViewController.birdDatabase = self.birdDatabase;
        speciesGroupViewController.observationGroup = _currentObservationGroup;
        
    } else if ([segue.identifier isEqualToString:@"speciesObservationDescription"]) {
        iTwitcherSpeciesObservationDescriptionViewController *speciesObservationDescriptionViewController = segue.destinationViewController;
        speciesObservationDescriptionViewController.observationDescriptionDelegate = self;
        speciesObservationDescriptionViewController.observationCollection = self.observationCollection;
    }
}

-(int)speciesCount:(ObservationGroup *)observationGroup
{
    int count = 0;
   // NSSet *observationGroups = [self.observationCollection observationGroups];
   // for (ObservationGroup *observationGroup in observationGroups) {
        count += [[observationGroup speciesObservations] count];
        
    //}
    return count;
    
}
-(int)birdCount:(ObservationGroup *)observationGroup
{
    int count = 0;
    
 //   NSSet *observationGroups = [self.observationCollection observationGroups];
   // for (ObservationGroup *observationGroup in observationGroups) {
        NSSet *speciesObservations = [observationGroup speciesObservations];
        for (SpeciesObservation *speciesObservation in speciesObservations) {
            count += [self speciesSum:speciesObservation];
        }
        
    //}
    return count;
}
-(int)speciesSum:(SpeciesObservation *)speciesObservation
{
    int sum =  [speciesObservation.femaleAdult intValue]+  [speciesObservation.femaleJuvenile intValue] + [speciesObservation.femaleImmature intValue]+[speciesObservation.femaleAgeUnknown intValue]
    + [speciesObservation.maleAdult intValue] + [speciesObservation.maleJuvenile intValue] + [speciesObservation.maleImmature intValue] + [speciesObservation.maleAgeUnkown intValue]
    + [speciesObservation.sexUnknownAdult intValue] + [speciesObservation.sexUnknownJuvenile intValue] + [speciesObservation.sexUnknownImmature intValue] + [speciesObservation.sexUnknownAgeUnknown intValue];
    return sum;
    
}


- (IBAction)addGroup:(id)sender {
    ObservationGroup *observationGroup = [[ObservationGroup alloc] initWithContext:[self.birdDatabase managedObjectContext] byDate:[NSDate date]];
    [self.observationCollection addObservationGroupsObject:observationGroup];
    [[self.birdDatabase managedObjectContext] save:nil];
    NSLog(@"observationGroups Count %d",[observationGroups count]);
    
    [observationGroups addObject:observationGroup];
    NSLog(@"observationGroups Count After %d",[observationGroups count]);
    [self.tableView reloadData];
    
}
@end
