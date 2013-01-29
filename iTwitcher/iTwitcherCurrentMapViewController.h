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
@interface iTwitcherCurrentMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, ADBannerViewDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) UIManagedDocument *birdDatabase;
@property (nonatomic, weak) NSString *birdDatabaseURL;
@end
