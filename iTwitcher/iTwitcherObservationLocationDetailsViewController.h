//
//  iTwitcherObservationLocationDetailsViewController.h
//  iTwitcher
//
//  Created by Raymond Harrison on 2/21/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObservationLocation.h"
@interface iTwitcherObservationLocationDetailsViewController : UITableViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UISlider *locationRadiusSlider;
@property (weak, nonatomic) IBOutlet UITextField *locationNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationDescriptionTextField;
@property (weak, nonatomic) IBOutlet UIButton *directionsButton;
@property (weak, nonatomic) IBOutlet UIButton *addToHotspotsButton;
@property (weak, nonatomic) IBOutlet UIButton *shareLocationButton;
@property (weak, nonatomic) IBOutlet UIImageView *locationImageView;

@property (nonatomic, strong) UIManagedDocument *birdDatabase;
@property (nonatomic, strong) ObservationLocation *observationLocation;
- (IBAction)changeRadius:(id)sender;
- (IBAction)locationPhoto:(id)sender;
- (IBAction)getDirections:(id)sender;
- (IBAction)addHotspots:(id)sender;
- (IBAction)shareLocation:(id)sender;


@end
