//
//  SpeciesListWeekTableViewController.m
//  iTwitcher
//
//  Created by Raymond Harrison on 3/19/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "SpeciesListWeekTableViewController.h"
#import "SpeciesObservation.h"
#import "ObservationGroup.h"
#import "ObservationCollection.h"
#import "ObservationLocation.h"
#import "SpeciesListDetailTableViewController.h"

@interface SpeciesListWeekTableViewController (){
    NSString *speciesName;
}
@property (nonatomic, strong) NSArray *mySpeciesList;

@end

@implementation SpeciesListWeekTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(UIManagedDocument *)birdDatabase
{
    if (!_birdDatabase) {
        NSURL *url = nil;

            
            url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
            url = [url URLByAppendingPathComponent:@"iBirderDatabase"];
            _birdDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
           if (_birdDatabase.documentState == UIDocumentStateClosed) {
            // exists on disk, but we need to open it
            
            [_birdDatabase openWithCompletionHandler:^(BOOL success) {
                if (success) {
                    //[self populateDocument];
                    NSLog(@"Document moved from state closed to open");
                    self.mySpeciesList = [Species speciesWithObservationsWeek:[self.birdDatabase managedObjectContext]];
                    [self.tableView reloadData];
                    
                } else {
                    NSLog(@"Document State Closed could not open");
                }
                
                
            }];
        } else if (_birdDatabase.documentState == UIDocumentStateNormal) {
            // already open and ready to use
            NSLog(@"Document state normal");
            
            //[self populateDocument];
        }
        
        
    }
    return _birdDatabase;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.mySpeciesList = [Species speciesWithObservationsWeek:[self.birdDatabase managedObjectContext]];
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
    return [self.mySpeciesList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"mySpecies";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Species *species = self.mySpeciesList[indexPath.row];
    int locations = 0;
    int speciesCount = 0;
    NSString *name = nil;
    for (SpeciesObservation *speciesObservation in species.speciesObservations) {
        speciesCount += [self speciesSum:speciesObservation];
        NSString *currentName =  speciesObservation.observationGroup.observationCollection.observationLocation.name;
        if (![currentName isEqualToString:name]) {
            locations++;
            name = currentName;
        }
    }
    cell.textLabel.text = species.speciesEnglishName;
    NSString *subTitle = [NSString stringWithFormat:@"Total of (%d) in (%d) observations in (%d) locations",speciesCount,[species.speciesObservations count],locations];
    cell.detailTextLabel.text = subTitle;
    // Configure the cell...
    
    return cell;
}

-(int)speciesSum:(SpeciesObservation *)speciesObservation
{
    int sum =  [speciesObservation.femaleAdult intValue]+  [speciesObservation.femaleJuvenile intValue] + [speciesObservation.femaleImmature intValue]+[speciesObservation.femaleAgeUnknown intValue]
    + [speciesObservation.maleAdult intValue] + [speciesObservation.maleJuvenile intValue] + [speciesObservation.maleImmature intValue] + [speciesObservation.maleAgeUnkown intValue]
    + [speciesObservation.sexUnknownAdult intValue] + [speciesObservation.sexUnknownJuvenile intValue] + [speciesObservation.sexUnknownImmature intValue] + [speciesObservation.sexUnknownAgeUnknown intValue];
    return sum;
    
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
    Species *species = self.mySpeciesList[indexPath.row];
    speciesName = species.speciesEnglishName;
    NSLog(@"Species Name (Species List) %@",speciesName);
    [self performSegueWithIdentifier:@"speciesListDetail" sender:self];
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Prepare for Segue");
    if ([segue.identifier isEqualToString:@"speciesListDetail"]) {
        SpeciesListDetailTableViewController *speciesListDetailTableViewController = segue.destinationViewController;
        speciesListDetailTableViewController.birdDatabase = self.birdDatabase;
        NSLog(@"Species Name %@",speciesName);
        speciesListDetailTableViewController.speciesName = speciesName;
        
    }
}

@end
