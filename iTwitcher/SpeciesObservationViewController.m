//
//  SpeciesObservationViewController.m
//  iTwitcher
//
//  Created by Raymond Harrison on 3/9/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "SpeciesObservationViewController.h"
#import <Social/Social.h>
#import <QuartzCore/QuartzCore.h>
#import "CoverFlowLayout.h"
#import "CCoverflowCollectionViewLayout.h"

#import "Flickr.h"
#import "FlickrPhoto.h"
#import "iTwitcherPhotoCollectionViewCell.h"

#import "PhotoCollectionViewCell.h"
#import "Species.h"
#import "ObservationCollection.h"


@interface SpeciesObservationViewController () 
@property (nonatomic) NSInteger previouslySelectedIndex;

//@property (nonatomic, strong) CoverFlowLayout *coverFlowLayout;
@property (nonatomic, strong) NSMutableArray *flickrResults;
@property (nonatomic, strong) NSMutableDictionary *searchResults;
@property (nonatomic, strong) NSMutableArray *searches;
@property (nonatomic, strong) Flickr *flickr;
@property (readwrite, nonatomic, strong) NSCache *imageCache;

@end

@implementation SpeciesObservationViewController

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
    NSLog(@"View did load");
    
    
  //  [self.collectionView registerNib:[UINib nibWithNibName:@"iTwitcherPhotoCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"photoViewCell"];
   // [self.collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"photoCell"];
   // self.coverFlowLayout = [[CCoverflowCollectionViewLayout alloc] init];
   // self.collectionView.delegate = self;
   // self.collectionView.dataSource = self;
   // [self.collectionView setCollectionViewLayout:[[CCoverflowCollectionViewLayout alloc] init]];
    self.flickrResults = [@[] mutableCopy];
    self.flickr = [[Flickr alloc] init];
    self.imageCache = [[NSCache alloc] init];
    NSLog(@"English Name %@",self.speciesObservation.species.speciesEnglishName);
    
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"View did appear");
    [self initializeSliderValues];
    NSLog(@"View did appear %d",self.birdGenderSelector.selectedSegmentIndex);
    [self setSlidersBySelectedGender:self.birdGenderSelector.selectedSegmentIndex];
    self.previouslySelectedIndex=self.birdGenderSelector.selectedSegmentIndex;
    self.speciesNameLabel.text = self.speciesObservation.species.speciesEnglishName;
    [self.collectionView reloadData];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"View will appear");
    //[self.birdGenderSelector setSelectedSegmentIndex:0];
   // [self.collectionView setCollectionViewLayout:[[CCoverflowCollectionViewLayout alloc] init]];
    
    [self.flickr searchFlickrForTerm:self.speciesObservation.species.speciesEnglishName completionBlock:^(NSString *searchTerm, NSArray *results, NSError *error) {
        if (results && [results count] > 0) {
            if (![self.searches containsObject:searchTerm]) {
                NSLog(@"Found %d photos matching %@", [results count],searchTerm);
                
			}
            self.flickrResults = [NSMutableArray arrayWithArray:results];
			dispatch_async(dispatch_get_main_queue(), ^{
				// RUN AFTER SEARCH HAS FINISHED
                [self.collectionView reloadData];
                /*
					[self.collectionView performBatchUpdates:^{
                        NSInteger newSection = (self.flickrResults.count - 1);
                        for (NSInteger i = 0; i < [results count]; i++) {
                            [self.collectionView insertItemsAtIndexPaths:
                             @[[NSIndexPath indexPathForItem:i inSection:newSection]]];
                        }
                        [self.collectionView insertSections:
                         [NSIndexSet indexSetWithIndex:newSection]];
					} completion:nil];
                 */
				
			});
		} else {
			NSLog(@"Error searching Flickr: %@", error.localizedDescription);
		}
	}];
    NSLog(@"Leaving view will appear");
}


-(void) viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        [self.delegate didManipulateObservation:self speciesObservation:self.speciesObservation];
    }
     [super viewWillDisappear:animated];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"Will Rotate To Interface Orientation");
}


-(BOOL) shouldAutorotate
{
    NSLog(@"Should auto rotate");
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations{
    NSLog(@"supported interface orientations ###");
    return UIInterfaceOrientationMaskPortrait; // etc
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    NSLog(@"shouldAutorotateToInterfaceOrientation");
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) initializeSliderValues
{
    
    
    
    //  self.femaleCountLabel.text = [[NSString alloc] initWithFormat:@"%@",[self countFemale]];
    
    //self.maleCountLabel.text = [[NSString alloc] initWithFormat:@"%@",[self countMale]];
    
    // self.unknownCountLabel.text = [[NSString alloc] initWithFormat:@"%@",[self countUnknown]];
    
    [self setBySelectedGender:self.birdGenderSelector.selectedSegmentIndex];
    switch (self.birdGenderSelector.selectedSegmentIndex) {
        case 0: self.genderLabel.text = @"Male";
            break;
        case 1: self.genderLabel.text = @"Female";
            break;
        case 2: self.genderLabel.text = @"?";
    }
    
    
    
    //  [self setSegmentedControlTitleBySelectedIndex:self.birdGenderSelecter selectedIndex:0];
    //   [self setSegmentedControlTitleBySelectedIndex:self.birdGenderSelecter selectedIndex:1];
    //  [self setSegmentedControlTitleBySelectedIndex:self.birdGenderSelecter selectedIndex:2];
    
}



- (IBAction)adultChange:(id)sender {
    UIStepper *slider = sender;
    self.adultCountLabel.text = [[NSString alloc] initWithFormat:@"%d",(int)slider.value];
    [self appendTotalsBySelectedGender:self.birdGenderSelector.selectedSegmentIndex value:(int)slider.value];
   // [self saveDataBySelectedGender:self.birdGenderSelector.selectedSegmentIndex];
}

- (IBAction)juvenileChange:(id)sender {
    UIStepper *slider = sender;
    self.juvenileCountLabel.text = [[NSString alloc] initWithFormat:@"%d",(int)slider.value];
    [self appendTotalsBySelectedGender:self.birdGenderSelector.selectedSegmentIndex value:(int)slider.value];
//    [self saveDataBySelectedGender:self.birdGenderSelector.selectedSegmentIndex];
}

- (IBAction)immatureChange:(id)sender {
    UIStepper *slider = sender;
    self.immatureCountLabel.text = [[NSString alloc] initWithFormat:@"%d",(int)slider.value];
    [self appendTotalsBySelectedGender:self.birdGenderSelector.selectedSegmentIndex value:(int)slider.value];
//    [self saveDataBySelectedGender:self.birdGenderSelector.selectedSegmentIndex];
}

- (IBAction)unknownAgeChange:(id)sender {
    UIStepper *slider = sender;
    self.unknownAgeCountLabel.text = [[NSString alloc] initWithFormat:@"%d",(int)slider.value];
    [self appendTotalsBySelectedGender:self.birdGenderSelector.selectedSegmentIndex value:(int)slider.value];
//    [self saveDataBySelectedGender:self.birdGenderSelector.selectedSegmentIndex];
}

- (IBAction)birdGenderSelection:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    segmentedControl.highlighted = YES;
   
    //  [segmentedControl setT]
    [self saveDataBySelectedGender:self.previouslySelectedIndex];
    
    self.previouslySelectedIndex = segmentedControl.selectedSegmentIndex;
    // _previousIndex = segmentedControl.selectedSegmentIndex;
	
    [self setBySelectedGender:self.birdGenderSelector.selectedSegmentIndex];
    [self setSlidersBySelectedGender:self.birdGenderSelector.selectedSegmentIndex];
    switch (self.birdGenderSelector.selectedSegmentIndex) {
        case 0: self.genderLabel.text = @"Male";
            break;
        case 1: self.genderLabel.text = @"Female";
            break;
        case 2: self.genderLabel.text = @"?";
    }
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
    
    NSString *initalTextString = [NSString stringWithFormat:@"@iBirder #iTwitcher %@:F:%dM:%dU:%d (%f|%f)",
                                  self.speciesObservation.species.speciesEnglishName,[[self countFemale] intValue], [[self countMale] intValue], [[self countUnknown] intValue],[self.observationGroup.observationCollection.latitude floatValue],[self.observationGroup.observationCollection.longitude floatValue]];
    
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
                                               UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, SpeciesDelegate>) delegate {
    
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
    
    
//    [self.birdObservationImageView setImage:self.birdImage];
    
    // UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"changeBird"]){
        
        NSLog(@"Changing Bird - Going to Species View Controller");
        
        // First check to see if we have an existing observation at this location
        
        
        // Go to species view controller
        iTwitcherSpeciesViewController *speciesViewController =
        segue.destinationViewController;
        speciesViewController.birdDatabase = self.birdDatabase;

        speciesViewController.delegate = self;
        
        
        
        
    }  
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





#pragma mark - UICollectionView Datasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)cv {

   // return [self.flickrResults count];
    return 1;
}

-(NSInteger)collectionView:(UICollectionView*)cv numberOfItemsInSection:(NSInteger)section {

    
    NSLog(@"Result Size %d",[self.flickrResults count]);
    //return 10;
    return [self.flickrResults count]>0?[self.flickrResults count]:10;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)cv cellForItemAtIndexPath:(NSIndexPath*)indexPath {
     NSLog(@"in cell fo item at index path");
 
     PhotoCollectionViewCell *theCell = [cv dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    
    if (theCell.gestureRecognizers.count == 0)
    {
		[theCell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCell:)]];
    }
    
	theCell.backgroundColor = [UIColor colorWithHue:(float)indexPath.row / (float)[self.flickrResults count] saturation:0.333 brightness:1.0 alpha:1.0];
    
    FlickrPhoto *flickrPhoto = nil;


    //cell.birdPhotoImageView.image = self.flickrResults[indexPath.item];

    //cell.photo = flickrPhoto;
    
    if (indexPath.row < [self.flickrResults count] && ([self.flickrResults count]>0)) {
        flickrPhoto = self.flickrResults[indexPath.item];
        NSNumber *key = [NSNumber numberWithLong:flickrPhoto.photoID ];
        UIImage *theImage = [self.imageCache objectForKey:key ];
        if (!theImage) {
            
           theImage =  flickrPhoto.thumbnail;
    
        //NSLog(@"image %@",[NSNumber numberWithFloat:theImage.size.height]);
            [self.imageCache setObject:theImage forKey:key];
        }
        theCell.imageView.image = theImage;
        theCell.reflectionImageView.image = theImage;
        theCell.backgroundColor = [UIColor clearColor];
    }
   
    return theCell;
}

/*
- (UICollectionReusableView *)collectionView:(UICollectionView *)cv viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    FlickrPhotoHeaderView *headerView = [cv dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FlickrPhotoHeaderView" forIndexPath:indexPath];
    NSString *searchTerm = nil;
    if (cv == self.collectionView) {
        searchTerm = self.searches[indexPath.section];
    } else if (cv == self.currentPinchCollectionView) {
        // ADDED
        searchTerm = self.searches[self.currentPinchedItem.item];
    }
    [headerView setSearchText:searchTerm];
    return headerView;
}
*/
/*
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView*)cv layout:(UICollectionViewLayout*)cvl sizeForItemAtIndexPath:(NSIndexPath*)indexPath {
    CGSize retVal = self.collectionView.frame.size;
    NSLog(@"in size for item at index path");
    return retVal;
}
*/


#pragma mark -

- (void)tapCell:(UITapGestureRecognizer *)inGestureRecognizer
{
	NSIndexPath *theIndexPath = [self.collectionView indexPathForCell:(UICollectionViewCell *)inGestureRecognizer.view];
    
	NSLog(@"%@", [self.collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:theIndexPath]);
	NSURL *theURL = [self.flickrResults objectAtIndex:theIndexPath.row];
    FlickrPhoto *photo = [self.flickrResults objectAtIndex:theIndexPath.row];
    self.birdImage = photo.thumbnail;
	NSLog(@"%@", theURL);
}

#pragma mark - Species Delegate
-(void)didSelectSpecies:(iTwitcherSpeciesViewController *)controller species:(Species *)species
{
    [self.speciesObservation setSpecies:species];
   // [_currentObservationGroup addSpeciesObservationsObject:_currentSpeciesObservation];
    [self.collectionView reloadData]; // ?? Figure out the section and reload
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didCancelSpeciesSelection:(iTwitcherSpeciesViewController *)controller
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
