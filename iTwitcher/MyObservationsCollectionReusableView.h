//
//  MyObservationsCollectionReusableView.h
//  iTwitcher
//
//  Created by Raymond Harrison on 3/4/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyObservationsCollectionReusableView;
@protocol MyObservationsHeaderViewDelegate <NSObject>
-(void) didPressSpeciesWeb: (MyObservationsCollectionReusableView *)headerView;


@end

@interface MyObservationsCollectionReusableView : UICollectionReusableView

@property (nonatomic, weak) id <MyObservationsHeaderViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *myObservationDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *addSpecies;
@property (nonatomic) NSInteger section;
@property (nonatomic) BOOL editingHeader;
@property (nonatomic) BOOL deletable;
- (IBAction)addSpeciesAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end
