//
//  iTwitcherSpeciesViewController.h
//  iTwitcher
//
//  Created by Raymond Harrison on 1/27/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Species+Query.h"
#import "SpeciesObservation+Query.h"
#import "SpeciesObservation+Create.h"
#import "ObservationLocation.h"
#import "ObservationGroup+Query.h"
#import "iTwitcherSpeciesObservationViewController.h"

@interface iTwitcherSpeciesViewController : UITableViewController <NSFetchedResultsControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate, iTwitcherSpeciesObservationDelegate>



@property (nonatomic, strong) UIManagedDocument *birdDatabase;

@property (nonatomic, weak) NSString *birdDatabaseURL;


@property (nonatomic, weak) NSMutableArray *tappedCellSpecies;
@property (nonatomic, weak) Species *tappedSpecies;
@property (nonatomic, strong) SpeciesObservation *speciesObservation;
@property (nonatomic) CLLocationCoordinate2D location;
@property (nonatomic, strong) ObservationLocation *observationLocation;
@property (nonatomic, strong) ObservationGroup *observationGroup;
@end
