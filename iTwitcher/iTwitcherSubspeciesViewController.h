//
//  iTwitcherSubspeciesViewController.h
//  iTwitcher
//
//  Created by Raymond Harrison on 2/3/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpeciesObservation+Query.h"
#import "ObservationLocation.h"
#import <CoreLocation/CoreLocation.h>
#import "Species.h"
#import "iTwitcherSpeciesObservationViewController.h"
@interface iTwitcherSubspeciesViewController : UITableViewController 


@property (nonatomic, strong) UIManagedDocument *birdDatabase;
@property (nonatomic, strong) NSMutableArray *subspecies;
@property (nonatomic, strong) SpeciesObservation *speciesObservation;

@property (nonatomic) CLLocationCoordinate2D currentObservationCoordinate;
@property (nonatomic, strong) ObservationLocation *observationLocation;
//@property (nonatomic, strong) Species *species;

@end
