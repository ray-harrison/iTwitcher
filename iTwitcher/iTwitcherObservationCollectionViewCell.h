//
//  iTwitcherObservationCollectionViewCell.h
//  iTwitcher
//
//  Created by Raymond Harrison on 3/4/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpeciesObservation.h"

@class iTwitcherObservationCollectionViewCell;
@protocol ObservationCollectionViewCellDelegate <NSObject>
-(void) didPressSpeciesWeb: (iTwitcherObservationCollectionViewCell *)cell;


@end


@interface iTwitcherObservationCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id <ObservationCollectionViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *speciesNameButton;
@property (weak, nonatomic) IBOutlet UILabel *speciesCountButton;

@property (weak, nonatomic) IBOutlet UIButton *speciesWebButton;

@property (weak, nonatomic) SpeciesObservation *speciesObservation;
@property (weak, nonatomic) NSIndexPath *indexPath;
- (IBAction)speciesWeb:(id)sender;

@end
