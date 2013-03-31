//
//  iTwitcherSpeciesObservationDescriptionViewController.h
//  iTwitcher
//
//  Created by Raymond Harrison on 2/21/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObservationCollection.h"
@class iTwitcherSpeciesObservationDescriptionViewController;
@protocol iTwitcherObservationDescriptionDelegate <NSObject>
-(void) didChooseSave: (iTwitcherSpeciesObservationDescriptionViewController *)controller observationLocation: (ObservationCollection *)observationCollection;
-(void) didCancel: (iTwitcherSpeciesObservationDescriptionViewController *)controller;
@end

@interface iTwitcherSpeciesObservationDescriptionViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic, weak) id<iTwitcherObservationDescriptionDelegate> observationDescriptionDelegate;
@property (weak, nonatomic) IBOutlet UITextField *observationNameTextField;

@property (nonatomic, strong) ObservationCollection *observationCollection;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;


@end
