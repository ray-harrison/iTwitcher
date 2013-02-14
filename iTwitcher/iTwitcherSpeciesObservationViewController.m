//
//  iTwitcherSpeciesObservationViewController.m
//  iTwitcher
//
//  Created by Raymond Harrison on 1/29/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "iTwitcherSpeciesObservationViewController.h"

@interface iTwitcherSpeciesObservationViewController () {
    __weak iTwitcherSpeciesObservationViewController *weakSelf;
    
}

@property (nonatomic) NSInteger previouslySelectedIndex;
@end

@implementation iTwitcherSpeciesObservationViewController




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
    weakSelf = self;
   // [self initializeSliderValues];
	// Do any additional setup after loading the view.
    
   // self.navigationController.delegate = self;
   // self.navigationController.navigationItem.titleView = self.selectGenderSegmentedControl;
    //self.navigationItem.
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"Species Observation %@",self.speciesObservation);
   [self initializeSliderValues];
    [self setSlidersBySelectedGender:self.selectGenderSegmentedControl.selectedSegmentIndex];
    self.previouslySelectedIndex=self.selectGenderSegmentedControl.selectedSegmentIndex;
    NSLog(@"Previously selected index %d",self.previouslySelectedIndex);
    
}





-(void) viewWillDisappear:(BOOL)animated
{
    if (weakSelf) {
        NSLog(@"Weak Self Exists");
        [weakSelf saveDataBySelectedGender:weakSelf.selectGenderSegmentedControl.selectedSegmentIndex];
        
        [weakSelf.observationDelegate didCreateObservation:weakSelf speciesObservation:weakSelf.speciesObservation];
    }
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        NSLog(@"Not found");
        if ([self speciesObservationNonZero]) {
            NSLog(@"Did Save");
            [self saveDataBySelectedGender:self.selectGenderSegmentedControl.selectedSegmentIndex];
            
            [self.observationDelegate didCreateObservation:self speciesObservation:self.speciesObservation];
        } else {
            NSLog(@"Did Cancel");
            [self.observationDelegate didCancel:self];
        }
        
        
        
    }
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)selectGender:(id)sender {
    if (!sender) {
        NSLog(@"Sender is NIL");
        return;
    } else {
        NSLog(@"Selecting Gender");
    }
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    segmentedControl.highlighted = YES;
    
    [self saveDataBySelectedGender:self.previouslySelectedIndex];
    
    self.previouslySelectedIndex = segmentedControl.selectedSegmentIndex;
	
    [self setBySelectedGender:self.selectGenderSegmentedControl.selectedSegmentIndex];
    [self setSlidersBySelectedGender:self.selectGenderSegmentedControl.selectedSegmentIndex];
    
}
- (IBAction)snapPhoto:(id)sender {
}

- (IBAction)shareObservation:(id)sender {
}
- (IBAction)adultSliderControl:(id)sender {
    UISlider *slider = sender;
    self.adultSliderLabel.text = [[NSString alloc] initWithFormat:@"%d",(int)slider.value];
    [self appendTotalsBySelectedGender:self.selectGenderSegmentedControl.selectedSegmentIndex value:(int)slider.value];
    [self saveDataBySelectedGender:self.selectGenderSegmentedControl.selectedSegmentIndex];
}

- (IBAction)juvenileSliderControl:(id)sender {
    UISlider *slider = sender;
    self.juvenileSliderLabel.text = [[NSString alloc] initWithFormat:@"%d",(int)slider.value];
    [self appendTotalsBySelectedGender:self.selectGenderSegmentedControl.selectedSegmentIndex value:(int)slider.value];
    [self saveDataBySelectedGender:self.selectGenderSegmentedControl.selectedSegmentIndex];
}

- (IBAction)immatureSliderControl:(id)sender {
    UISlider *slider = sender;
    self.immatureSliderLabel.text = [[NSString alloc] initWithFormat:@"%d",(int)slider.value];
    [self appendTotalsBySelectedGender:self.selectGenderSegmentedControl.selectedSegmentIndex value:(int)slider.value];
    [self saveDataBySelectedGender:self.selectGenderSegmentedControl.selectedSegmentIndex];
}

- (IBAction)unknownSliderControl:(id)sender {
    UISlider *slider = sender;
    self.unknownSliderLabel.text = [[NSString alloc] initWithFormat:@"%d",(int)slider.value];
    [self appendTotalsBySelectedGender:self.selectGenderSegmentedControl.selectedSegmentIndex value:(int)slider.value];
    [self saveDataBySelectedGender:self.selectGenderSegmentedControl.selectedSegmentIndex];
}

- (IBAction)save:(id)sender {
    [self saveDataBySelectedGender:self.selectGenderSegmentedControl.selectedSegmentIndex];
}

- (IBAction)trash:(id)sender {
}

-(void) initializeSliderValues
{
    
    self.femaleCountLabel.text = [[NSString alloc] initWithFormat:@"%@",[self countFemale]];

    self.maleCountLabel.text = [[NSString alloc] initWithFormat:@"%@",[self countMale]];
    
    self.unknownCountLabel.text = [[NSString alloc] initWithFormat:@"%@",[self countUnknown]];
    
    [self setBySelectedGender:self.selectGenderSegmentedControl.selectedSegmentIndex];
     
}

-(NSNumber *) countFemale
{
    return [[NSNumber alloc] initWithInt:[self.speciesObservation.femaleAdult intValue]+[self.speciesObservation.femaleJuvenile intValue]+[self.speciesObservation.femaleImmature intValue]+[self.speciesObservation.femaleAgeUnknown intValue]];
}

-(NSNumber *) countMale
{
    return [[NSNumber alloc] initWithInt:[self.speciesObservation.maleAdult intValue]+[self.speciesObservation.maleJuvenile intValue]+[self.speciesObservation.maleImmature intValue]+[self.speciesObservation.maleAgeUnkown intValue]];
}

-(NSNumber *) countUnknown
{
    return [[NSNumber alloc] initWithInt:[self.speciesObservation.sexUnknownAdult intValue]+[self.speciesObservation.sexUnknownJuvenile intValue]+[self.speciesObservation.sexUnknownImmature intValue]+[self.speciesObservation.sexUnknownAgeUnknown intValue]];
}

-(void) setBySelectedGender:(NSInteger)selectedSegmentIndex
{
    switch (selectedSegmentIndex) {
        case 0: // Female
            self.adultSliderLabel.text = [[NSString alloc] initWithFormat:@"%@",self.speciesObservation.femaleAdult];
            self.juvenileSliderLabel.text = [[NSString alloc] initWithFormat:@"%@",self.speciesObservation.femaleJuvenile];
            self.immatureSliderLabel.text = [[NSString alloc] initWithFormat:@"%@",self.speciesObservation.femaleImmature];
            self.unknownSliderLabel.text = [[NSString alloc] initWithFormat:@"%@",self.speciesObservation.femaleAgeUnknown];
            
            
            
            break;
        case 1:
            self.adultSliderLabel.text = [[NSString alloc] initWithFormat:@"%@",self.speciesObservation.maleAdult];
            self.juvenileSliderLabel.text = [[NSString alloc] initWithFormat:@"%@",self.speciesObservation.maleJuvenile];
            self.immatureSliderLabel.text = [[NSString alloc] initWithFormat:@"%@",self.speciesObservation.maleImmature];
            self.unknownSliderLabel.text = [[NSString alloc] initWithFormat:@"%@",self.speciesObservation.maleAgeUnkown];
            
            
            
            break;
        case 2:
            self.adultSliderLabel.text = [[NSString alloc] initWithFormat:@"%@",self.speciesObservation.sexUnknownAdult];
            self.juvenileSliderLabel.text = [[NSString alloc] initWithFormat:@"%@",self.speciesObservation.sexUnknownJuvenile];
            self.immatureSliderLabel.text = [[NSString alloc] initWithFormat:@"%@",self.speciesObservation.sexUnknownImmature];
            self.unknownSliderLabel.text = [[NSString alloc] initWithFormat:@"%@",self.speciesObservation.sexUnknownAgeUnknown];
            
            break;
            
            
    }
}

-(void) setSlidersBySelectedGender:(NSInteger)selectedSegmentIndex
{
    switch (selectedSegmentIndex) {
        case 0: // Female
            self.adultSlider.value = [self.speciesObservation.femaleAdult floatValue];
            self.juvenileSlider.value = [self.speciesObservation.femaleJuvenile floatValue];
            self.immatureSlider.value = [self.speciesObservation.femaleImmature floatValue];
            self.unknownSlider.value = [self.speciesObservation.femaleAgeUnknown floatValue];
            
            
            
            break;
        case 1:
            
            self.adultSlider.value = [self.speciesObservation.maleAdult floatValue];
            self.juvenileSlider.value = [self.speciesObservation.maleJuvenile floatValue];
            self.immatureSlider.value = [self.speciesObservation.maleImmature floatValue];
            self.unknownSlider.value = [self.speciesObservation.maleAgeUnkown floatValue];
            
     
            
            
            
            break;
        case 2:
            
            self.adultSlider.value = [self.speciesObservation.sexUnknownAdult floatValue];
            self.juvenileSlider.value = [self.speciesObservation.sexUnknownJuvenile floatValue];
            self.immatureSlider.value = [self.speciesObservation.sexUnknownImmature floatValue];
            self.unknownSlider.value = [self.speciesObservation.sexUnknownAgeUnknown floatValue];
            
         
            
            break;
            
            
    }
}

-(void) appendTotalsBySelectedGender:(NSInteger)selectedSegmentIndex value:(int) value
{
    switch (selectedSegmentIndex) {
        case 0: // Female
            self.femaleCountLabel.text = [[NSString alloc] initWithFormat:@"%d",value + [[self countUnknown] intValue]+[[self countMale] intValue]];

            [self saveDataBySelectedGender:selectedSegmentIndex];
            
            
            break;
        case 1:// Male
            self.maleCountLabel.text = [[NSString alloc] initWithFormat:@"%d",value + [[self countUnknown] intValue]+[[self countFemale] intValue]];
            
            [self saveDataBySelectedGender:selectedSegmentIndex];
            
            break;
        case 2: // Unknown
            self.unknownCountLabel.text = [[NSString alloc] initWithFormat:@"%d",value +[[self countMale] intValue]+[[self countFemale] intValue]];
            [self saveDataBySelectedGender:selectedSegmentIndex];
            break;
            
            
    }
}

-(void) saveDataBySelectedGender:(NSInteger)selectedSegmentIndex
{
    NSLog(@"Weak Self %d",selectedSegmentIndex);
    switch (selectedSegmentIndex) {
        case 0: // Female
            
            self.speciesObservation.femaleAdult = [[NSNumber alloc] initWithFloat:self.adultSlider.value] ;
            
            self.speciesObservation.femaleJuvenile = [[NSNumber alloc] initWithFloat:self.juvenileSlider.value];
            
            self.speciesObservation.femaleImmature = [[NSNumber alloc] initWithFloat:self.immatureSlider.value];
            
            self.speciesObservation.femaleAgeUnknown = [[NSNumber alloc] initWithFloat:self.adultSlider.value] ;            
            
            break;
        case 1:
            
            
            self.speciesObservation.maleAdult = [[NSNumber alloc] initWithFloat:self.adultSlider.value] ;
            
            self.speciesObservation.maleJuvenile = [[NSNumber alloc] initWithFloat:self.juvenileSlider.value];
            
            self.speciesObservation.maleImmature = [[NSNumber alloc] initWithFloat:self.immatureSlider.value];
            
            self.speciesObservation.maleAgeUnkown = [[NSNumber alloc] initWithFloat:self.adultSlider.value] ;
            

            
            
            
            
            
            break;
        case 2:
            
            self.speciesObservation.sexUnknownAdult = [[NSNumber alloc] initWithFloat:self.adultSlider.value] ;
            
            self.speciesObservation.sexUnknownJuvenile = [[NSNumber alloc] initWithFloat:self.juvenileSlider.value];
            
            self.speciesObservation.sexUnknownImmature = [[NSNumber alloc] initWithFloat:self.immatureSlider.value];
            
            self.speciesObservation.sexUnknownAgeUnknown = [[NSNumber alloc] initWithFloat:self.adultSlider.value] ;
            
            
            
            break;
            
            
    }
  //  if (self.species != nil) {
  //      self.speciesObservation.species = self.species;
  //  } else {
  //      self.subspecies = self.subspecies;
  //  }
    [[self.birdDatabase managedObjectContext] save:nil];
    NSLog(@"%@",self.speciesObservation.observationGroup);
}

-(BOOL) speciesObservationNonZero
{
  int sum =  [self.speciesObservation.femaleAdult intValue]+  [self.speciesObservation.femaleJuvenile intValue] + [self.speciesObservation.femaleImmature intValue]+[self.speciesObservation.femaleAgeUnknown intValue]
    + [self.speciesObservation.maleAdult intValue] + [self.speciesObservation.maleJuvenile intValue] + [self.speciesObservation.maleImmature intValue] + [self.speciesObservation.maleAgeUnkown intValue]
    + [self.speciesObservation.sexUnknownAdult intValue] + [self.speciesObservation.sexUnknownJuvenile intValue] + [self.speciesObservation.sexUnknownImmature intValue] + [self.speciesObservation.sexUnknownAgeUnknown intValue];
    
    
    return sum>0?YES:NO;
    
}


@end
