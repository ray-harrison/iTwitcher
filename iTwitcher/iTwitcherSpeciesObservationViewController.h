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


@interface iTwitcherSpeciesObservationViewController : UIViewController <UINavigationControllerDelegate>
@property (nonatomic, strong) UIManagedDocument *birdDatabase;
@property (nonatomic, strong) SpeciesObservation *speciesObservation;
@property (weak, nonatomic) IBOutlet UISegmentedControl *selectGenderSegmentedControl;
- (IBAction)selectGender:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;
- (IBAction)snapPhoto:(id)sender;

- (IBAction)shareObservation:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *femaleCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *maleCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *unknownCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *adultSliderLabel;
@property (weak, nonatomic) IBOutlet UILabel *juvenileSliderLabel;
@property (weak, nonatomic) IBOutlet UILabel *immatureSliderLabel;
@property (weak, nonatomic) IBOutlet UILabel *unknownSliderLabel;
@property (weak, nonatomic) IBOutlet UISlider *adultSlider;
@property (weak, nonatomic) IBOutlet UISlider *juvenileSlider;
@property (weak, nonatomic) IBOutlet UISlider *immatureSlider;
@property (weak, nonatomic) IBOutlet UISlider *unknownSlider;
- (IBAction)adultSliderControl:(id)sender;
- (IBAction)juvenileSliderControl:(id)sender;
- (IBAction)immatureSliderControl:(id)sender;
- (IBAction)unknownSliderControl:(id)sender;
- (IBAction)save:(id)sender;

- (IBAction)trash:(id)sender;

@property (nonatomic, weak) id <iTwitcherSpeciesObservationDelegate> observationDelegate;

@property (nonatomic) CLLocationCoordinate2D currentObservationCoordinate;
@property (nonatomic, strong) ObservationGroup *observationGroup;
@property (nonatomic, strong) Species *species;
@property (nonatomic, strong) Subspecies *subspecies;


@end
