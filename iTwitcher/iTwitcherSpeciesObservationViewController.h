//
//  iTwitcherSpeciesObservationViewController.h
//  iTwitcher
//
//  Created by Raymond Harrison on 1/29/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SpeciesObservation.h"
#import "ObservationGroup+Query.h"
#import "Species.h"
#import "Subspecies.h"

@class iTwitcherSpeciesObservationViewController;
@protocol iTwitcherSpeciesObservationDelegate <NSObject>
-(void) didCreateObservation: (iTwitcherSpeciesObservationViewController *)controller speciesObservation: (SpeciesObservation *)speciesObservation;
-(void) didCancel:(iTwitcherSpeciesObservationViewController *)controller;

@end


@interface iTwitcherSpeciesObservationViewController : UITableViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIWebViewDelegate>
@property (nonatomic, strong) UIManagedDocument *birdDatabase;
@property (nonatomic, strong) SpeciesObservation *speciesObservation;
@property (weak, nonatomic) IBOutlet UISegmentedControl *birdGenderSelecter;
- (IBAction)selectGender:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;
- (IBAction)snapPhoto:(id)sender;

- (IBAction)shareObservation:(id)sender;
//@property (weak, nonatomic) IBOutlet UILabel *femaleCountLabel;
//@property (weak, nonatomic) IBOutlet UILabel *maleCountLabel;
//@property (weak, nonatomic) IBOutlet UILabel *unknownCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *adultCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *juvenileCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *immatureCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *unknownAgeCountLabel;
@property (weak, nonatomic) IBOutlet UISlider *adultIncrementer;
@property (weak, nonatomic) IBOutlet UISlider *juvenileIncrementer;
@property (weak, nonatomic) IBOutlet UISlider *immatureIncrementer;
@property (weak, nonatomic) IBOutlet UISlider *unknownAgeIncrementer;
@property (weak, nonatomic) IBOutlet UIWebView *birdWebView;

- (IBAction)adultIncrementerControl:(id)sender;
- (IBAction)juvenileIncrementerControl:(id)sender;
- (IBAction)immatureIncrementerControl:(id)sender;
- (IBAction)unknownAgeIncrementerControl:(id)sender;
- (IBAction)save:(id)sender;

- (IBAction)trash:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *birdObservationImage;
@property (weak, nonatomic) UIImage *birdImage;

@property (nonatomic, weak) id <iTwitcherSpeciesObservationDelegate> observationDelegate;

@property (nonatomic) CLLocationCoordinate2D currentObservationCoordinate;
@property (nonatomic, strong) ObservationGroup *observationGroup;
@property (nonatomic, strong) Species *species;
@property (nonatomic, strong) Subspecies *subspecies;




@end
