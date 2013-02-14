//
//  iTwitcherCurrentMapViewController.h
//  iTwitcher
//
//  Created by Raymond Harrison on 1/27/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <iAd/iAd.h>
#import "iTwitcherMapDetailsViewController.h"
#import "iTwitcherSpeciesObservationMasterViewController.h"
@interface iTwitcherCurrentMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, ADBannerViewDelegate, iTwitcherMapDetailsDelegate,iTwitcherSpeciesObservationMasterDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) UIManagedDocument *birdDatabase;
@property (nonatomic, weak) NSString *birdDatabaseURL;

- (IBAction)currentLocation:(id)sender;
@end
