//
//  iTwitcherSpeciesViewController.h
//  iTwitcher
//
//  Created by Raymond Harrison on 1/27/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Species+Query.h"

@interface iTwitcherSpeciesViewController : UITableViewController <NSFetchedResultsControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate>



@property (nonatomic, strong) UIManagedDocument *birdDatabase;

@property (nonatomic, weak) NSString *birdDatabaseURL;


@property (nonatomic, strong) NSMutableArray *tappedCellSpecies;
@property (nonatomic, strong) Species *tappedSpecies;
@end
