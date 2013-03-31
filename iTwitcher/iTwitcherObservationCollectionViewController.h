//
//  iTwitcherObservationCollectionViewController.h
//  iTwitcher
//
//  Created by Raymond Harrison on 2/14/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObservationCollection+Query.h"
#import "ObservationGroup+Query.h"

@interface iTwitcherObservationCollectionViewController : UITableViewController

@property (nonatomic, strong) UIManagedDocument *birdDatabase;
@property (nonatomic, strong) ObservationGroup *observationGroup;

@end
