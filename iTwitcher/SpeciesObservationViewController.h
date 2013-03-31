//
//  SpeciesObservationViewController.h
//  iTwitcher
//
//  Created by Raymond Harrison on 3/9/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpeciesObservation.h"
#import "iTwitcherSpeciesViewController.h"
#import "ObservationGroup.h"





@class SpeciesObservationViewController;
@protocol SpeciesObservationDelegate <NSObject>
-(void) didManipulateObservation: (SpeciesObservationViewController *)controller speciesObservation: (SpeciesObservation *)speciesObservation;
//-(void) didCancel:(iTwitcherSpeciesObservationViewController *)controller;

@end


@interface SpeciesObservationViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, SpeciesDelegate>

@property (nonatomic, strong) UIManagedDocument *birdDatabase;
@property (nonatomic, strong) SpeciesObservation *speciesObservation;
@property (nonatomic, strong) ObservationGroup *observationGroup;


@property (weak, nonatomic) IBOutlet UIStepper *adultIncrementer;
@property (weak, nonatomic) IBOutlet UIStepper *juvenileIncrementer;
@property (weak, nonatomic) IBOutlet UIStepper *immatureIncrementer;
@property (weak, nonatomic) IBOutlet UIStepper *unknownAgeIncrementer;
@property (weak, nonatomic) IBOutlet UILabel *adultCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *juvenileCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *immatureCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *unknownAgeCountLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *birdGenderSelector;
//@property (weak, nonatomic) IBOutlet UIImageView *birdObservationImageView;
@property (weak, nonatomic) IBOutlet UILabel *speciesNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, weak) id <SpeciesObservationDelegate> delegate;
- (IBAction)shareObservation:(id)sender;

- (IBAction)snapPhoto:(id)sender;

- (IBAction)adultChange:(id)sender;
- (IBAction)juvenileChange:(id)sender;
- (IBAction)immatureChange:(id)sender;
- (IBAction)unknownAgeChange:(id)sender;
- (IBAction)birdGenderSelection:(id)sender;

@property (weak, nonatomic) UIImage *birdImage;

@end
