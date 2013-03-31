//
//  iTwitcherSpeciesObservationViewController.m
//  iTwitcher
//
//  Created by Raymond Harrison on 1/29/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "iTwitcherSpeciesObservationViewController.h"
#import <Social/Social.h>
#import <QuartzCore/QuartzCore.h>
typedef enum SocialButtonTags {
    SocialButtonTagFacebook, SocialButtonTagSinaWeibo, SocialButtonTagTwitter
} SocialButtonTags;
@interface iTwitcherSpeciesObservationViewController () {
    
    NSArray *femaleTitles;
    NSArray *maleTitles;
    NSArray *unknownTitles;
    //UIWebView *birdWebView;

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
    
  //  	CGRect webFrame = [[UIScreen mainScreen] applicationFrame];
	//webFrame.origin.y += kTopMargin + 5.0;	// leave from the URL input field and its label
    //	webFrame.size.height -= 40.0;
    //	self.birdInfoView = [[UIWebView alloc] initWithFrame:webFrame];
    //	self.birdInfoView.backgroundColor = [UIColor whiteColor];
    //	self.birdInfoView.scalesPageToFit = YES;
    //	self.birdInfoView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
  
   // [self initializeSliderValues];
	// Do any additional setup after loading the view.
    femaleTitles = @[
                              @"Adult Female",
                              @"Juvenile Female",
                              @"Immature Female",
                              @"Female (Unknown Age)"
                              ];
    maleTitles = @[
                     @"Adult Male",
                     @"Juvenile Male",
                     @"Immature Male",
                     @"Male (Unknown Age)"
                     ];
    
    unknownTitles = @[
                     @"Adult Sex Unknown",
                     @"Juvenile Sex Unknown",
                     @"Immature Sex Unknown",
                     @"Sex Unknown (Unknown Age)"
                     ];
   // self.navigationController.delegate = self;
   // self.navigationController.navigationItem.titleView = self.birdGenderSelecter;
    //self.navigationItem.
  //  birdWebView = [[UIWebView alloc] initWithFrame:webFrame];

    NSURLRequest *requestObject = [self birdURL:self.species.speciesEnglishName];
    [self.birdWebView loadRequest:requestObject];
  //  UIGraphicsBeginImageContext(self.birdWebView.bounds.size);
 //   [self.birdWebView.layer renderInContext:UIGraphicsGetCurrentContext()];
 //   self.birdImage = UIGraphicsGetImageFromCurrentImageContext();
 //   UIGraphicsEndImageContext();
    
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    UIGraphicsBeginImageContext(self.birdWebView.bounds.size);
    [self.birdWebView.layer renderInContext:UIGraphicsGetCurrentContext()];
    self.birdImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"Species Observation %@",self.speciesObservation);
   [self initializeSliderValues];
    [self setSlidersBySelectedGender:self.birdGenderSelecter.selectedSegmentIndex];
    self.previouslySelectedIndex=self.birdGenderSelecter.selectedSegmentIndex;
    
    NSLog(@"Previously selected index %d",self.previouslySelectedIndex);
    
}





-(void) viewWillDisappear:(BOOL)animated
{
    /*
    if (weakSelf) {
        NSLog(@"Weak Self Exists");
        [weakSelf saveDataBySelectedGender:weakSelf.birdGenderSelecter.selectedSegmentIndex];
        
        [weakSelf.observationDelegate didCreateObservation:weakSelf speciesObservation:weakSelf.speciesObservation];
    }
  
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        NSLog(@"Not found %d", _previousIndex);
        if ([self speciesObservationNonZero]) {
            NSLog(@"Did Save");
            [self saveDataBySelectedGender:self.birdGenderSelecter.selectedSegmentIndex];
            
            [self.observationDelegate didCreateObservation:self speciesObservation:self.speciesObservation];
        } else {
            NSLog(@"Did Cancel");
            [self.observationDelegate didCancel:self];
        }
        
        
        
    }
     */
     
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
    NSLog(@"UISegmented Control Title %@",[segmentedControl titleForSegmentAtIndex:self.birdGenderSelecter.selectedSegmentIndex]);
  //  [segmentedControl setT]
    [self saveDataBySelectedGender:self.previouslySelectedIndex];
    
     self.previouslySelectedIndex = segmentedControl.selectedSegmentIndex;
   // _previousIndex = segmentedControl.selectedSegmentIndex;
	
    [self setBySelectedGender:self.birdGenderSelecter.selectedSegmentIndex];
    [self setSlidersBySelectedGender:self.birdGenderSelecter.selectedSegmentIndex];
    [self.tableView reloadData];
    
}



- (IBAction)adultIncrementerControl:(id)sender {
    UISlider *slider = sender;
    self.adultCountLabel.text = [[NSString alloc] initWithFormat:@"%d",(int)slider.value];
    [self appendTotalsBySelectedGender:self.birdGenderSelecter.selectedSegmentIndex value:(int)slider.value];
    [self saveDataBySelectedGender:self.birdGenderSelecter.selectedSegmentIndex];
   // [self.tableView reloadData];
}

- (IBAction)juvenileIncrementerControl:(id)sender {
    UISlider *slider = sender;
    self.juvenileCountLabel.text = [[NSString alloc] initWithFormat:@"%d",(int)slider.value];
    [self appendTotalsBySelectedGender:self.birdGenderSelecter.selectedSegmentIndex value:(int)slider.value];
    [self saveDataBySelectedGender:self.birdGenderSelecter.selectedSegmentIndex];
  //  [self.tableView reloadData];
}

- (IBAction)immatureIncrementerControl:(id)sender {
    UISlider *slider = sender;
    self.immatureCountLabel.text = [[NSString alloc] initWithFormat:@"%d",(int)slider.value];
    [self appendTotalsBySelectedGender:self.birdGenderSelecter.selectedSegmentIndex value:(int)slider.value];
    [self saveDataBySelectedGender:self.birdGenderSelecter.selectedSegmentIndex];
  //  [self.tableView reloadData];
}

- (IBAction)unknownAgeIncrementerControl:(id)sender {
    UISlider *slider = sender;
    self.unknownAgeCountLabel.text = [[NSString alloc] initWithFormat:@"%d",(int)slider.value];
    [self appendTotalsBySelectedGender:self.birdGenderSelecter.selectedSegmentIndex value:(int)slider.value];
    [self saveDataBySelectedGender:self.birdGenderSelecter.selectedSegmentIndex];
  //  [self.tableView reloadData];
}

- (IBAction)save:(id)sender {
    [self saveDataBySelectedGender:self.birdGenderSelecter.selectedSegmentIndex];
}

- (IBAction)trash:(id)sender {
}
                                           
                            

-(void) initializeSliderValues
{
    
    
    
  //  self.femaleCountLabel.text = [[NSString alloc] initWithFormat:@"%@",[self countFemale]];

    //self.maleCountLabel.text = [[NSString alloc] initWithFormat:@"%@",[self countMale]];
    
   // self.unknownCountLabel.text = [[NSString alloc] initWithFormat:@"%@",[self countUnknown]];
    
    [self setBySelectedGender:self.birdGenderSelecter.selectedSegmentIndex];
    
   
    
  //  [self setSegmentedControlTitleBySelectedIndex:self.birdGenderSelecter selectedIndex:0];
 //   [self setSegmentedControlTitleBySelectedIndex:self.birdGenderSelecter selectedIndex:1];
  //  [self setSegmentedControlTitleBySelectedIndex:self.birdGenderSelecter selectedIndex:2];
     
}
                                           
/*
-(void) setSegmentedControlTitleBySelectedIndex:(UISegmentedControl *)segmentedControl selectedIndex:(NSInteger)selectedSegmentIndex
{
    switch(selectedSegmentIndex) {
        case 0: // Female
            [segmentedControl setTitle:[NSString stringWithFormat:@"F (%@)",self.countFemale] forSegmentAtIndex:selectedSegmentIndex];
            break;
        case 1: // Male
            [segmentedControl setTitle:[NSString stringWithFormat:@"M (%@)",self.countMale] forSegmentAtIndex:selectedSegmentIndex];
            break;
        case 2: // Unknown
            [segmentedControl setTitle:[NSString stringWithFormat:@"U (%@)",self.countUnknown] forSegmentAtIndex:selectedSegmentIndex];
            break;
        
    }
}
*/

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
    int count = [[[NSNumber alloc] initWithInt:[self.speciesObservation.sexUnknownAdult intValue]+[self.speciesObservation.sexUnknownJuvenile intValue]+[self.speciesObservation.sexUnknownImmature intValue]+[self.speciesObservation.sexUnknownAgeUnknown intValue]] intValue];
    NSLog(@"Unknown %d",count);
    return [[NSNumber alloc] initWithInt:[self.speciesObservation.sexUnknownAdult intValue]+[self.speciesObservation.sexUnknownJuvenile intValue]+[self.speciesObservation.sexUnknownImmature intValue]+[self.speciesObservation.sexUnknownAgeUnknown intValue]];
}

-(void) setBySelectedGender:(NSInteger)selectedSegmentIndex
{
    switch (selectedSegmentIndex) {
        case 0: // Female
            self.adultCountLabel.text = [[NSString alloc] initWithFormat:@"%@",self.speciesObservation.femaleAdult];
            self.juvenileCountLabel.text = [[NSString alloc] initWithFormat:@"%@",self.speciesObservation.femaleJuvenile];
            self.immatureCountLabel.text = [[NSString alloc] initWithFormat:@"%@",self.speciesObservation.femaleImmature];
            self.unknownAgeCountLabel.text = [[NSString alloc] initWithFormat:@"%@",self.speciesObservation.femaleAgeUnknown];
            
        //   [self setSegmentedControlTitleBySelectedIndex:self.birdGenderSelecter selectedIndex:selectedSegmentIndex];
            
            break;
        case 1:
            self.adultCountLabel.text = [[NSString alloc] initWithFormat:@"%@",self.speciesObservation.maleAdult];
            self.juvenileCountLabel.text = [[NSString alloc] initWithFormat:@"%@",self.speciesObservation.maleJuvenile];
            self.immatureCountLabel.text = [[NSString alloc] initWithFormat:@"%@",self.speciesObservation.maleImmature];
            self.unknownAgeCountLabel.text = [[NSString alloc] initWithFormat:@"%@",self.speciesObservation.maleAgeUnkown];
            
      //      [self setSegmentedControlTitleBySelectedIndex:self.birdGenderSelecter selectedIndex:selectedSegmentIndex];
            
            break;
        case 2:
            self.adultCountLabel.text = [[NSString alloc] initWithFormat:@"%@",self.speciesObservation.sexUnknownAdult];
            self.juvenileCountLabel.text = [[NSString alloc] initWithFormat:@"%@",self.speciesObservation.sexUnknownJuvenile];
            self.immatureCountLabel.text = [[NSString alloc] initWithFormat:@"%@",self.speciesObservation.sexUnknownImmature];
            self.unknownAgeCountLabel.text = [[NSString alloc] initWithFormat:@"%@",self.speciesObservation.sexUnknownAgeUnknown];
      //     [self setSegmentedControlTitleBySelectedIndex:self.birdGenderSelecter selectedIndex:selectedSegmentIndex];
            break;
            
            
    }
}

-(void) setSlidersBySelectedGender:(NSInteger)selectedSegmentIndex
{
    switch (selectedSegmentIndex) {
        case 0: // Female
            self.adultIncrementer.value = [self.speciesObservation.femaleAdult floatValue];
            self.juvenileIncrementer.value = [self.speciesObservation.femaleJuvenile floatValue];
            self.immatureIncrementer.value = [self.speciesObservation.femaleImmature floatValue];
            self.unknownAgeIncrementer.value = [self.speciesObservation.femaleAgeUnknown floatValue];
            
            
            
            break;
        case 1:
            
            self.adultIncrementer.value = [self.speciesObservation.maleAdult floatValue];
            self.juvenileIncrementer.value = [self.speciesObservation.maleJuvenile floatValue];
            self.immatureIncrementer.value = [self.speciesObservation.maleImmature floatValue];
            self.unknownAgeIncrementer.value = [self.speciesObservation.maleAgeUnkown floatValue];
            
     
            
            
            
            break;
        case 2:
            
            self.adultIncrementer.value = [self.speciesObservation.sexUnknownAdult floatValue];
            self.juvenileIncrementer.value = [self.speciesObservation.sexUnknownJuvenile floatValue];
            self.immatureIncrementer.value = [self.speciesObservation.sexUnknownImmature floatValue];
            self.unknownAgeIncrementer.value = [self.speciesObservation.sexUnknownAgeUnknown floatValue];
            
         
            
            break;
            
            
    }
}

-(void) appendTotalsBySelectedGender:(NSInteger)selectedSegmentIndex value:(int) value
{
    switch (selectedSegmentIndex) {
        case 0: // Female
            //self.femaleCountLabel.text = [[NSString alloc] initWithFormat:@"%d",value + [[self countUnknown] intValue]+[[self countMale] intValue]];
          //  self.femaleCountLabel.text = [[NSString alloc] initWithFormat:@"%d",[[self countFemale] intValue]];
            [self saveDataBySelectedGender:selectedSegmentIndex];
       //     [self setSegmentedControlTitleBySelectedIndex:self.birdGenderSelecter selectedIndex:selectedSegmentIndex];
            
            break;
        case 1:// Male
            //self.maleCountLabel.text = [[NSString alloc] initWithFormat:@"%d",[[self countMale] intValue]];
           
            [self saveDataBySelectedGender:selectedSegmentIndex];
        //    [self setSegmentedControlTitleBySelectedIndex:self.birdGenderSelecter selectedIndex:selectedSegmentIndex];
            break;
        case 2: // Unknown
           // self.unknownCountLabel.text = [[NSString alloc] initWithFormat:@"%d",[[self countUnknown] intValue]];
            [self saveDataBySelectedGender:selectedSegmentIndex];
        //    [self setSegmentedControlTitleBySelectedIndex:self.birdGenderSelecter selectedIndex:selectedSegmentIndex];
            break;
            
            
    }
}

-(void) saveDataBySelectedGender:(NSInteger)selectedSegmentIndex
{
   
    switch (selectedSegmentIndex) {
        case 0: // Female
            
            self.speciesObservation.femaleAdult = [[NSNumber alloc] initWithFloat:self.adultIncrementer.value] ;
            
            self.speciesObservation.femaleJuvenile = [[NSNumber alloc] initWithFloat:self.juvenileIncrementer.value];
            
            self.speciesObservation.femaleImmature = [[NSNumber alloc] initWithFloat:self.immatureIncrementer.value];
            
            self.speciesObservation.femaleAgeUnknown = [[NSNumber alloc] initWithFloat:self.unknownAgeIncrementer.value] ;
            
            break;
        case 1:
            
            
            self.speciesObservation.maleAdult = [[NSNumber alloc] initWithFloat:self.adultIncrementer.value] ;
            
            self.speciesObservation.maleJuvenile = [[NSNumber alloc] initWithFloat:self.juvenileIncrementer.value];
            
            self.speciesObservation.maleImmature = [[NSNumber alloc] initWithFloat:self.immatureIncrementer.value];
            
            self.speciesObservation.maleAgeUnkown = [[NSNumber alloc] initWithFloat:self.unknownAgeIncrementer.value] ;
            

            
            
            
            
            
            break;
        case 2:
            
            self.speciesObservation.sexUnknownAdult = [[NSNumber alloc] initWithFloat:self.adultIncrementer.value] ;
            
            self.speciesObservation.sexUnknownJuvenile = [[NSNumber alloc] initWithFloat:self.juvenileIncrementer.value];
            
            self.speciesObservation.sexUnknownImmature = [[NSNumber alloc] initWithFloat:self.immatureIncrementer.value];
            
            self.speciesObservation.sexUnknownAgeUnknown = [[NSNumber alloc] initWithFloat:self.unknownAgeIncrementer.value] ;
            
            
            
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


- (IBAction)shareObservation:(id)sender {
    NSString *initalTextString = [NSString stringWithFormat:@"@iBirder sighting: Species- %@, F:%d M:%d U:%d (Test)",
                                  self.speciesObservation.species.speciesEnglishName,[[self countFemale] intValue], [[self countMale] intValue], [[self countUnknown] intValue]];
    
    NSArray *activityItems;
    
    if (_birdImage != nil) {
        activityItems = @[initalTextString, _birdImage];
    } else {
        activityItems = @[initalTextString];
    }
    UIActivityViewController *activityViewController;
    NSLog(@"Text String %@",initalTextString);
   // if (self.birdImage != nil) {
       activityViewController =
       [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    //} else {
      //  NSLog(@"No Image View");
       // [[UIActivityViewController alloc]
        //activityViewController =
        //[[UIActivityViewController alloc] initWithActivityItems:[@initalTextString] applicationActivities:nil];
   // }
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (IBAction)snapPhoto:(id)sender {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    // imagePicker.showsCameraControls = YES;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // imagePicker.showsCameraControls = YES;
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        imagePicker.showsCameraControls = YES;
        
    }
    else
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [imagePicker setDelegate:self];
    
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (BOOL) startMediaBrowserFromViewController: (UIViewController*) controller
                               usingDelegate: (id <UIImagePickerControllerDelegate,
                                               UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    // Displays saved pictures and movies, if both are available, from the
    // Camera Roll album.
    mediaUI.mediaTypes =
    [UIImagePickerController availableMediaTypesForSourceType:
     UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    mediaUI.allowsEditing = YES;
    
    mediaUI.delegate = delegate;
    
    [controller presentViewController: mediaUI animated: YES completion:nil];
    return YES;
}

- (IBAction)mediaBrowser:(id)sender {
    [self startMediaBrowserFromViewController: self
                                usingDelegate: self];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.birdImage = info[UIImagePickerControllerOriginalImage];
    
    [self.birdObservationImage setImage:self.birdImage];
    
    // UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table View



-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
 //   NSArray *females = @[self.speciesObservation.femaleAdult,self.speciesObservation.femaleJuvenile,self.speciesObservation.femaleImmature,self.speciesObservation.femaleAgeUnknown];
 //   NSArray *males = @[self.speciesObservation.maleAdult,self.speciesObservation.maleJuvenile,self.speciesObservation.maleImmature,self.speciesObservation.maleAgeUnkown];
 //   NSArray *unknown = @[self.speciesObservation.sexUnknownAdult,self.speciesObservation.sexUnknownJuvenile,self.speciesObservation.sexUnknownImmature,self.speciesObservation.sexUnknownAgeUnknown];
    NSInteger arrayIndex = section-1;
    
    if (arrayIndex == 0 || arrayIndex == 1 || arrayIndex == 2 || arrayIndex == 3) {
       switch (self.birdGenderSelecter.selectedSegmentIndex ) {
        case 0:
            return ([[NSString alloc] initWithFormat:@"%@",femaleTitles[arrayIndex]]);

            
            break;
        case 1:
            return ([[NSString alloc] initWithFormat:@"%@",maleTitles[arrayIndex]]);

            
            break;
        case 2:
            return ([[NSString alloc] initWithFormat:@"%@",unknownTitles[arrayIndex]]);

            break;
            
            
     }
    }
    
    return nil;
    
}

-(NSURLRequest *) birdURL:(NSString *)birdName
{
    NSString *unescapedString = [[NSString alloc] initWithString:birdName];
    if ([unescapedString isEqualToString:@"Merlin"]) {
        unescapedString = @"Merlin_(bird)";
    }
    
    if ([unescapedString isEqualToString:@"Redhead"]) {
        unescapedString = @"Redhead_(bird)";
    }
    
	unescapedString =  [unescapedString stringByReplacingOccurrencesOfString:@" " withString:@"_"];
	
	NSLog(@"Bird Info Mutable %@",[unescapedString stringByReplacingOccurrencesOfString:@" " withString:@"_"]);
	
    
	NSString *urlWikipedia = @"http://en.m.wikipedia.org/wiki/";
	NSString *urlAddress = [urlWikipedia stringByAppendingString:unescapedString];
	//NSString *urlAddress = @"http://www.wikipedia.org";
	NSLog(@"Wikipedia URL %@",urlAddress);
	
	
	//Create a URL object.
	NSURL *url = [NSURL URLWithString:urlAddress];
	
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10];
    return requestObj;
}

@end
