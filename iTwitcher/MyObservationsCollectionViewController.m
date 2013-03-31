//
//  MyObservationsCollectionViewController.m
//  iTwitcher
//
//  Created by Raymond Harrison on 3/4/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "MyObservationsCollectionViewController.h"
#import "MyObservationsCollectionReusableView.h"
#import "iTwitcherObservationCollectionViewCell.h"
#import "ObservationGroup+Query.h"
#import "ObservationCollection+Query.h"
#import "Species.h"
#import "iTwitcherSpeciesObservationViewController.h"
#import "BirdInfoViewController.h"
#import "iTwitcherSpeciesViewController.h"

#import "SpeciesObservationViewController.h"




@interface MyObservationsCollectionViewController () {
    NSMutableArray *observationGroups;
    ObservationGroup *_currentObservationGroup;
    SpeciesObservation *_currentSpeciesObservation;
    iTwitcherObservationCollectionViewCell *_currentCell;
    NSMutableArray *birdNames;
}

@property (nonatomic) BOOL editingHeader;
@end

@implementation MyObservationsCollectionViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date"
                                                  ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    if ([self.observationCollection.observationGroups count] == 0) {
        // Create a default observation group for this collection
        ObservationGroup *observationGroup = [[ObservationGroup alloc] initWithContext:[self.birdDatabase managedObjectContext] byDate:[NSDate date]];
        [self.observationCollection addObservationGroupsObject:observationGroup];
        
        
    }
              NSLog(@"My %f %f",[self.observationCollection.latitude floatValue],[self.observationCollection.longitude floatValue]);
    observationGroups = [NSMutableArray arrayWithArray:[self.observationCollection.observationGroups sortedArrayUsingDescriptors:sortDescriptors]];
    self.editingHeader = NO;
    
}

-(void) viewDidAppear:(BOOL)animated
{
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate
{
    return NO;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {
    // _data is a class member variable that contains one array per section.
    return [observationGroups count]>0?[observationGroups count]:1;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    ObservationGroup *observationGroup = observationGroups[section];
   
    return [[observationGroup speciesObservations] count];
}

-(void)didSelectSpecies:(iTwitcherSpeciesViewController *)controller species:(Species *)species
{
    [_currentSpeciesObservation setSpecies:species];
    [_currentObservationGroup addSpeciesObservationsObject:_currentSpeciesObservation];
    [self.collectionView reloadData]; // ?? Figure out the section and reload 
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didCancelSpeciesSelection:(iTwitcherSpeciesViewController *)controller
{
    [[self.birdDatabase managedObjectContext] deleteObject:_currentSpeciesObservation];
    [[self.birdDatabase managedObjectContext] save:nil];
    _currentSpeciesObservation = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UICollectionView delegate
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
 
    iTwitcherObservationCollectionViewCell *cell = nil;

    cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"observationCell" forIndexPath:indexPath];
    
    ObservationGroup *observationGroup = observationGroups[indexPath.section];
    NSSet *speciesObservations = [observationGroup speciesObservations];
    NSOrderedSet *orderedSpeciesObservations = [NSOrderedSet orderedSetWithSet:speciesObservations];
    
    NSArray *speciesObservationsArray = [orderedSpeciesObservations sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *englishName1 = [(SpeciesObservation *)obj1 species].speciesEnglishName;
        NSString *englishName2 = [(SpeciesObservation *)obj2 species].speciesEnglishName;
        return [englishName2 compare:englishName1];
    }];
    SpeciesObservation *speciesObservation = speciesObservationsArray[indexPath.item];
  
    UILabel *speciesLabel = (UILabel *)[cell viewWithTag:1101];
    speciesLabel.text = speciesObservation.species.speciesEnglishName;
    
    UILabel *countLabel = (UILabel *)[cell viewWithTag:1102];
    countLabel.text = [NSString stringWithFormat:@"Count: %d",[self speciesSum:speciesObservation]];
    
    cell.speciesObservation = speciesObservation;
    cell.delegate = self;
    
    
   // UILabel *detailsLabel = (UILabel *)[cell viewWithTag:1103];
   // detailsLabel.text = [NSString stringWithFormat:@"F:%d M: %d U: %d",
     //                    [[self countFemale:speciesObservation] intValue],[[self countMale:speciesObservation] intValue],[[self countUnknown:speciesObservation] intValue]];
    return cell;
}




-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    MyObservationsCollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Collection Header" forIndexPath:indexPath];
    
    ObservationGroup *observationGroup = observationGroups[indexPath.section];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
    
    NSDate *date = observationGroup.date;
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [dateFormat setTimeZone:timeZone];
    NSString *formattedDate = [dateFormat stringFromDate:date];
    
    reusableView.myObservationDateLabel.text = formattedDate;
    reusableView.section = indexPath.section;
    reusableView.editingHeader = self.editingHeader;
    if (!self.editingHeader ) {
        reusableView.deletable = NO;
      [reusableView.addSpecies setImage:[UIImage imageNamed:@"add25x25.png"] forState:UIControlStateNormal];
    } else if (self.editingHeader == YES){
        reusableView.deletable = YES;
        [reusableView.deleteButton setHidden:NO];
     
        
       [reusableView.addSpecies setImage:[UIImage imageNamed:@"delete25x25.png"] forState:UIControlStateNormal]; 
    }
    return reusableView;
    
    
}
-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Item Section %d Item Item %d",indexPath.section,indexPath.item);
    ObservationGroup *observationGroup = observationGroups[indexPath.section];
    NSSet *speciesObservations = [observationGroup speciesObservations];
    NSOrderedSet *orderedSpeciesObservations = [NSOrderedSet orderedSetWithSet:speciesObservations];
    
    NSArray *speciesObservationsArray = [orderedSpeciesObservations sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *englishName1 = [(SpeciesObservation *)obj1 species].speciesEnglishName;
        NSString *englishName2 = [(SpeciesObservation *)obj2 species].speciesEnglishName;
        return [englishName2 compare:englishName1];
    }];
    _currentSpeciesObservation = speciesObservationsArray[indexPath.item];
    _currentObservationGroup = observationGroup;
    NSLog(@"Species English Name %@",_currentSpeciesObservation.species.speciesEnglishName);
    if (_currentSpeciesObservation.species.speciesEnglishName != nil) {
     [self performSegueWithIdentifier:@"speciesObservation" sender:self];
    } else {
      [self performSegueWithIdentifier:@"AddBirds" sender:self];  
    }
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddBirds"]){
        
        NSLog(@"Adding Bird - Going to Species View Controller");
        
        // First check to see if we have an existing observation at this location
        
        
        // Go to species view controller
        iTwitcherSpeciesViewController *speciesViewController =
        segue.destinationViewController;
        speciesViewController.birdDatabase = self.birdDatabase;
        //  speciesViewController.location = self.location;
     //   speciesViewController.observationLocation = _currentObservationGroup.observationCollection.observationLocation;
        
        // ObservationGroup *observationGroup = [[ObservationGroup alloc] initWithContext:[self.birdDatabase managedObjectContext] byDate:[NSDate date]];
        // [self.observationCollection addObservationGroupsObject:observationGroup];
        // [[self.birdDatabase managedObjectContext] save:nil];
        
     //   speciesViewController.observationGroup = _currentObservationGroup;
     //   speciesViewController.speciesObservation = _currentSpeciesObservation;
        speciesViewController.delegate = self;
    
        
        
        
    }  else if ([segue.identifier isEqualToString:@"speciesObservation"]) {
        SpeciesObservationViewController *speciesObservationViewController = segue.destinationViewController;
        speciesObservationViewController.birdDatabase = self.birdDatabase;
        //  SpeciesObservation *speciesObservation = [[SpeciesObservation alloc] initWithContext:[self.birdDatabase managedObjectContext] ];
        speciesObservationViewController.speciesObservation = _currentSpeciesObservation;
        speciesObservationViewController.observationGroup = _currentSpeciesObservation.observationGroup;
        
        NSLog(@"SPECIES COLLECTION %@",_currentSpeciesObservation.observationGroup.observationCollection);
        speciesObservationViewController.delegate = self;
        //speciesObservationViewController.species = _currentSpeciesObservation.species;
       // speciesViewController.observationGroup = _currentObservationGroup;
        //[observationGroup addSpeciesObservationsObject:speciesObservation];
        //  Species *speciesSelection = self.tappedSpecies;
        //[speciesObservationViewController.speciesObservation setSpecies:speciesSelection];
        
        //speciesObservationViewController.currentObservationCoordinate = self.location;
        //speciesObservationViewController.species = speciesSelection;
        //[self.observationGroup addSpeciesObservationsObject:speciesObservation];
        
        NSLog(@"Going to Species Observation");
        
        
    } else if ([segue.identifier isEqualToString:@"speciesWeb"] ) {
        
        BirdInfoViewController *birdInfoViewController = segue.destinationViewController;
      //  NSLog(@"Species Name %@",_currentSpeciesObservation.species.speciesEnglishName);
        
        birdInfoViewController.speciesName = _currentCell.speciesObservation.species.speciesEnglishName;
        
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

-(void) didPressSpeciesWeb:(iTwitcherObservationCollectionViewCell *)cell
{
    NSLog(@"Did Press Species Web %@",cell.speciesObservation.species.speciesEnglishName);
    _currentCell = cell;
    if (_currentCell.speciesObservation.species.speciesEnglishName) {
        [self performSegueWithIdentifier:@"speciesWeb" sender:self];
    }
}

-(void) didChooseSave:(MyObservationsCollectionViewController *)controller observationLocation:(ObservationCollection *)observationCollection
{
    self.observationCollection = observationCollection;
    [[self.birdDatabase managedObjectContext] save:nil];
   // self.observationNameButton.titleLabel.text = self.observationCollection.name;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) didCancel:(MyObservationsCollectionViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(int)speciesCount:(ObservationGroup *)observationGroup atItem:(NSInteger)item
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
    SpeciesObservation *speciesObservation = [[SpeciesObservation alloc] initWithContext:[self.birdDatabase managedObjectContext]];
    [observationGroup addSpeciesObservationsObject:speciesObservation];
    [self.observationCollection addObservationGroupsObject:observationGroup];
    [[self.birdDatabase managedObjectContext] save:nil];
    NSLog(@"observationGroups Count %d",[observationGroups count]);
    
    
    [observationGroups addObject:observationGroup];
    [self.observationCollection addObservationGroupsObject:observationGroup];
    NSLog(@"observationGroups Count After %d",[observationGroups count]);
    [self.collectionView reloadData];
    
}



- (IBAction)addSpeciesObservation:(id)sender {
    
    MyObservationsCollectionReusableView *reusableView = (MyObservationsCollectionReusableView *)[(UIButton *)sender superview];
    
    
    ObservationGroup *observationGroup = observationGroups[reusableView.section];
    _currentObservationGroup = observationGroup;
    
    
    if (reusableView.deletable) {
        [observationGroups removeObject:observationGroup];
        [[self.birdDatabase managedObjectContext] deleteObject:observationGroup];
        [[self.birdDatabase managedObjectContext] save:nil];
    } else {
    SpeciesObservation *speciesObservation = [[SpeciesObservation alloc] initWithContext:[self.birdDatabase managedObjectContext]];
        [speciesObservation setDate:[NSDate date]];
        [[self.birdDatabase managedObjectContext] save:nil];
        NSLog(@"Saved speciesObservation");
        _currentSpeciesObservation = speciesObservation;
        
    [observationGroup addSpeciesObservationsObject:speciesObservation];
        
   // _currentSpeciesObservation = speciesObservation;
        [self performSegueWithIdentifier:@"AddBirds" sender:self];
    }
    
    NSLog(@"Reusable View %d",reusableView.section);
    [self.collectionView reloadData];
}

- (IBAction)birdInfo:(id)sender {
    NSLog(@"Species Web");
    UIButton *infoButton = (UIButton *)sender;
    CGPoint center = [infoButton center];
    NSIndexPath *indexPath2 = [self.collectionView indexPathForItemAtPoint:center];
    
    iTwitcherObservationCollectionViewCell *collectionViewCell = (iTwitcherObservationCollectionViewCell *)[infoButton superview];
    NSLog(@"Section %d Item %d",indexPath2.section,indexPath2.item);
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:collectionViewCell];
    ObservationGroup *observationGroup = observationGroups[indexPath.section];
    NSSet *speciesObservations = [observationGroup speciesObservations];
    NSOrderedSet *orderedSpeciesObservations = [NSOrderedSet orderedSetWithSet:speciesObservations];
    
    
    NSArray *speciesObservationsArray = [orderedSpeciesObservations sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *englishName1 = [(SpeciesObservation *)obj1 species].speciesEnglishName;
        NSString *englishName2 = [(SpeciesObservation *)obj2 species].speciesEnglishName;
        return [englishName2 compare:englishName1];
    }];
    _currentSpeciesObservation = collectionViewCell.speciesObservation;
    _currentObservationGroup = observationGroup;
    NSLog(@"Species Web Action %@",_currentSpeciesObservation.species.speciesEnglishName);
   
    [self performSegueWithIdentifier:@"speciesWeb" sender:self];
    
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    NSLog(@"Editing!");
    
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


- (IBAction)handleSwipeGesture:(UISwipeGestureRecognizer *)sender {
   NSLog(@"%@", [self.collectionView indexPathsForSelectedItems]);
    CGPoint pointLocation = [sender locationInView:self.collectionView];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:pointLocation];
    NSLog(@"Swipe View %d %d",indexPath.section,indexPath.item);
    NSLog(@"Swipe Gesture");
  //  [self.instructionView removeFromSuperview];
}


- (IBAction)editGroupAction:(id)sender {
 
    [self setEditing:YES
            animated:YES];
    self.editingHeader = YES;
    self.editGroup.style = UIBarButtonItemStyleDone;
    self.editGroup.title = @"Done";

    [self.collectionView reloadData];
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(paste:))
        return NO;
    if (action == @selector(copy:))
        return NO;
    
    return YES;
}
-(void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    ObservationGroup *observationGroup = observationGroups[indexPath.section];
    NSSet *speciesObservations = [observationGroup speciesObservations];
    NSOrderedSet *orderedSpeciesObservations = [NSOrderedSet orderedSetWithSet:speciesObservations];
    
    
    NSArray *speciesObservationsArray = [orderedSpeciesObservations sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *englishName1 = [(SpeciesObservation *)obj1 species].speciesEnglishName;
        NSString *englishName2 = [(SpeciesObservation *)obj2 species].speciesEnglishName;
        return [englishName2 compare:englishName1];
    }];
    SpeciesObservation *speciesObservation = speciesObservationsArray[indexPath.item];
    [observationGroup removeSpeciesObservationsObject:speciesObservation];
    [self.collectionView reloadData];
   // [observationGroup removeSpeciesObservationObject:speciesObservation];
    
}

-(void)didManipulateObservation:(SpeciesObservationViewController *)controller speciesObservation:(SpeciesObservation *)speciesObservation
{
    NSLog(@"Did Manipulate Observation");
}
@end
