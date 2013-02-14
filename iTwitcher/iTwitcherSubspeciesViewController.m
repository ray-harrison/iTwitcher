//
//  iTwitcherSubspeciesViewController.m
//  iTwitcher
//
//  Created by Raymond Harrison on 2/3/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "iTwitcherSubspeciesViewController.h"
#import "Species.h"
#import "Subspecies.h"
#import "BirdInfoViewController.h"
#import "iTwitcherSpeciesObservationViewController.h"

@interface iTwitcherSubspeciesViewController ()

@end

@implementation iTwitcherSubspeciesViewController

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
  //  self.navigationController.navigationItem.titleView;
    self.tableView.delegate = self;
    
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
    return [self subspecies].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Subspecies Cell";
   // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //     cell = [[UITableViewCell alloc]
        //             initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        // UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoLight];
        // cell.imageView.image = button.imageView.image;
        
    }
    
    Subspecies *subspecies_ = [self.subspecies objectAtIndex:indexPath.row];
    Species *species = subspecies_.species;
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@",species.speciesEnglishName,subspecies_.subspeciesLatinName ];
    
    cell.detailTextLabel.text = species.genusLatinName;
    
    cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
    
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
    
    [self performSegueWithIdentifier:@"speciesObservation" sender:self];
}


- (void)useDocument
{
    NSLog(@"Location %@",self.birdDatabase.fileURL);
    if (self.birdDatabase.documentState == UIDocumentStateClosed) {
        // exists on disk, but we need to open it
        
        [self.birdDatabase openWithCompletionHandler:^(BOOL success) {
          
            
            
        }];
    } else if (self.birdDatabase.documentState == UIDocumentStateNormal) {
        // already open and ready to use
        
       
        
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    
    if ([segue.identifier isEqualToString:@"observation"] ) {
        NSLog(@"Observation Segue");
        
        //   iBirderObservationViewController *observationController = segue.destinationViewController;
        //  observationController.speciesName = self.tappedSpecies.englishName;
        
    } else if ([segue.identifier isEqualToString:@"speciesWeb"] ) {
        
    //    BirdInfoViewController *birdInfoViewController = segue.destinationViewController;
        
        
       // birdInfoViewController.speciesName = [self.tappedSpecies speciesEnglishName];
        
    } else if ([segue.identifier isEqualToString:@"speciesObservation"]) {
        NSLog(@"Observation Details Segue!");
        NSLog(@"Species Observation %@",self.speciesObservation);
        
        // iBirderObservationDetailViewController *observationDetailViewController = segue.destinationViewController;
        //  observationDetailViewController.navigationController.title=@"Observation Detail";
        iTwitcherSpeciesObservationViewController *speciesObservationViewController = segue.destinationViewController;
        speciesObservationViewController.birdDatabase = self.birdDatabase;
        speciesObservationViewController.speciesObservation = self.speciesObservation;
        
        
    }
    
    
}

@end
