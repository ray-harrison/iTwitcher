//
//  MyObservationsCollectionViewController.h
//  iTwitcher
//
//  Created by Raymond Harrison on 3/4/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SpeciesObservation+Create.h"
#import "SpeciesObservation+Query.h"
#import "ObservationLocation.h"
#import "ObservationCollection+Query.h"
#import "iTwitcherSpeciesViewController.h"
#import "SpeciesObservationViewController.h"

#import "iTwitcherObservationCollectionViewCell.h"

@class MyObservationsCollectionViewController;
@protocol MyObservationsMasterDelegate <NSObject>
-(void) didCreateObservationCollection: (MyObservationsCollectionViewController *)controller observationCollection: (ObservationCollection *)observationCollection;
-(void) didCancel:(MyObservationsCollectionViewController *)controller;

@end



@interface MyObservationsCollectionViewController : UICollectionViewController <UICollectionViewDelegate,   ObservationCollectionViewCellDelegate, SpeciesDelegate, SpeciesObservationDelegate>

@property (nonatomic, weak) id <MyObservationsMasterDelegate> observationMasterDelegate;

@property (nonatomic, strong) UIManagedDocument *birdDatabase;
@property (nonatomic) CLLocationCoordinate2D location;
@property (nonatomic, strong) ObservationLocation *observationLocation;
@property (nonatomic, strong) ObservationCollection *observationCollection;

- (IBAction)doneAction:(id)sender;
- (IBAction)cancelAction:(id)sender;
- (IBAction)addGroup:(id)sender;
- (IBAction)addSpeciesObservation:(id)sender;
- (IBAction)birdInfo:(id)sender;
- (IBAction)handleSwipeGesture:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editGroup;

- (IBAction)editGroupAction:(id)sender;

@end
