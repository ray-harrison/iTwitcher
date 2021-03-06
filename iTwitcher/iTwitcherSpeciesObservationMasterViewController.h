//
//  iTwitcherSpeciesObservationMasterViewController.h
//  iTwitcher
//
//  Created by Raymond Harrison on 2/5/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SpeciesObservation+Create.h"
#import "SpeciesObservation+Query.h"
#import "ObservationLocation.h"
#import "ObservationCollection+Query.h"
#import "iTwitcherSpeciesObservationDescriptionViewController.h"
@class iTwitcherSpeciesObservationMasterViewController;
@protocol iTwitcherSpeciesObservationMasterDelegate <NSObject>
-(void) didCreateObservationCollection: (iTwitcherSpeciesObservationMasterViewController *)controller observationCollection: (ObservationCollection *)observationCollection;
-(void) didCancel:(iTwitcherSpeciesObservationMasterViewController *)controller;

@end

@interface iTwitcherSpeciesObservationMasterViewController : UITableViewController <iTwitcherObservationDescriptionDelegate, UINavigationBarDelegate>

@property (nonatomic, weak) id <iTwitcherSpeciesObservationMasterDelegate> observationMasterDelegate;

@property (nonatomic, strong) UIManagedDocument *birdDatabase;
@property (nonatomic) CLLocationCoordinate2D location;
@property (nonatomic, strong) ObservationLocation *observationLocation;
@property (nonatomic, strong) ObservationCollection *observationCollection;
@property (weak, nonatomic) IBOutlet UIButton *observationNameButton;

- (IBAction)doneAction:(id)sender;
- (IBAction)cancelAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addGroupButton;
- (IBAction)addGroup:(id)sender;

@end
