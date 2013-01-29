//
//  iTwitcherCurrentMapViewController.m
//  iTwitcher
//
//  Created by Raymond Harrison on 1/27/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "iTwitcherCurrentMapViewController.h"
#import "iTwitcherObservationAnnotation.h"
#import "iTwitcherLocationAnnotation.h"
#import "iTwitcherLocationAnnotationView.h"
#import "SpeciesObservation.h"
#import "SpeciesObservation+Create.h"
#import "SpeciesObservation+Query.h"
#import "ObservationLocation+Create.h"
#import "ObservationLocation+Query.h"
#import "iTwitcherSpeciesViewController.h"
#define METERS_PER_MILE 1609.344

@interface iTwitcherCurrentMapViewController () {
    NSMutableArray *_locations;
    NSMutableArray *_annotations;
    
    iTwitcherObservationAnnotation *_droppedPin;
    SpeciesObservation *_currentObservation;
    ObservationLocation *_birdLocation;
}

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic) BOOL iAdBannerIsVisible;



@end

@implementation iTwitcherCurrentMapViewController







- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self loadDocument];
    
    [self startLocationUpdates];
    
    
    UILongPressGestureRecognizer *longPressRecogniser = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPressRecogniser.minimumPressDuration = 1.0;
    [self.mapView addGestureRecognizer:longPressRecogniser];
    
    self.mapView.delegate = self;
    self.iAdBannerIsVisible=YES;
}

-(void) viewDidAppear:(BOOL)animated
{
    [self zoomToCurrentLocation];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Load UI Managed Document
-(void)loadDocument
{
    NSURL *url = nil;
    if (!self.birdDatabase) {
        NSLog(@"Init Bird Datbase");
        
        url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"iBirderDatabase"];
        self.birdDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
    }
}


- (void)setBirdDatabase:(UIManagedDocument *)birdDatabase
{
    
    if (_birdDatabase != birdDatabase) {
        _birdDatabase = birdDatabase;
        [self useDocument];
        
    }
}


#pragma mark - Location Delegate

-(CLLocation *)currentLocation
{
    NSLog(@"Getting current location");
    if (_currentLocation == nil) {
        _currentLocation = [self.locationManager location];
    }
    return _currentLocation;
    
}

-(CLLocationManager *)locationManager
{
    if (nil == _locationManager)
        _locationManager = [[CLLocationManager alloc] init];
    return _locationManager;
    
}

-(void)startLocationUpdates
{
    // Create the location manager if this object does not
    // already have one.
    NSLog(@"Start updating location");
  
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Set a movement threshold for new events.
    self.locationManager.distanceFilter = 100;
   // self.locationManager.pausesLocationUpdatesAutomatically = YES;
    [self.locationManager setActivityType:CLActivityTypeOther];
    [self.locationManager startUpdatingLocation];
}

- (void)startSignificantChangeUpdates
{
    // Create the location manager if this object does not
    // already have one.
    
    
    self.locationManager.delegate = self;
    [self.locationManager startMonitoringSignificantLocationChanges];
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    NSLog(@"didUpdateLocations");
    // If it's a relatively recent event, turn off updates to save power
    self.currentLocation = [locations lastObject];

    NSDate* eventDate = self.currentLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              self.currentLocation.coordinate.latitude,
              self.currentLocation.coordinate.longitude);
    }
}

-(void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager
{
    NSLog(@"Did pause location updates");
}

#pragma mark - Map Delegate


- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    if ([annotation isKindOfClass:[iTwitcherObservationAnnotation class]]) {
        // iBirderObservationAnnotation *observationAnnotation =
        // (iBirderObservationAnnotation *)annotation;
        NSLog(@"Annotation is kindofclass iBirderObservationAnnotation");
        MKPinAnnotationView*    pinView = (MKPinAnnotationView*)[[self mapView]
                                                                 dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:@"CustomPinAnnotationView"];
            
            pinView.pinColor = MKPinAnnotationColorRed;
            
            pinView.animatesDrop = YES;
            pinView.canShowCallout = YES;
            pinView.draggable = YES;
            
            // Add a detail disclosure button to the callout.
            UIButton* rightButton = [UIButton buttonWithType:
                                     UIButtonTypeDetailDisclosure];
            // [rightButton addTarget:self action:@selector(myShowDetailsMethod:)
            // forControlEvents:UIControlEventTouchUpInside];
            pinView.rightCalloutAccessoryView = rightButton;
        }
        else
            pinView.annotation = annotation;
        
        return pinView;
        
    }
    
    if ([annotation isKindOfClass:[iTwitcherLocationAnnotation class]]) {
        
        NSLog(@"annotation isKindOfClass iBirderLocationAnnotation");
        
        iTwitcherLocationAnnotation *locationAnnotation = (iTwitcherLocationAnnotation *)annotation;
        
        iTwitcherLocationAnnotationView *locationAnnotationView =
        (iTwitcherLocationAnnotationView *)[[self mapView]
                                          dequeueReusableAnnotationViewWithIdentifier:locationAnnotation.title];
        
        if (!locationAnnotationView) {
            locationAnnotationView = [iTwitcherLocationAnnotationView initWithAnnotation:annotation map:[self mapView]];
            locationAnnotationView.mapView= _mapView;
            
            locationAnnotationView.pinColor = MKPinAnnotationColorGreen;
            
        }
        
        
        
        
        locationAnnotationView.mapView= _mapView;
        locationAnnotationView.theAnnotation = annotation;
        locationAnnotationView.annotation = annotation;
        
        
        
        locationAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        
        [locationAnnotationView updateRadiusOverlay];
        
        return locationAnnotationView;
        
        
    }
    
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView
{
    // UIImage *image = [self.delegate mapViewController:self imageForAnnotation:aView.annotation];
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
    if ([view.annotation isKindOfClass:[iTwitcherObservationAnnotation class]]) {
        NSLog(@"Annotation isKindOfClass iBirderObservationAnnotation");
        [self performSegueWithIdentifier:@"AddBirds" sender:self];
    } else {
        
        
        iTwitcherLocationAnnotationView *locationAnnotationView =
        (iTwitcherLocationAnnotationView *)view;
        [locationAnnotationView removeRadiusOverlay];
        
        for (id currentAnnotation in self.mapView.annotations) {
            if ([currentAnnotation isKindOfClass:[iTwitcherLocationAnnotation class]]) {
                [self.mapView deselectAnnotation:currentAnnotation animated:YES];
            }
        }
        
        [self performSegueWithIdentifier:@"updateLocation" sender:self];
    }
    
}



-(void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    
    if ([view.annotation isKindOfClass:[iTwitcherLocationAnnotation class]]) {
        if (newState == MKAnnotationViewDragStateStarting) {
            
            // Get the annotation being moved and remove it from the list of annotations
            iTwitcherLocationAnnotationView *annotationView = (iTwitcherLocationAnnotationView *)view;
            [annotationView removeRadiusOverlay];
            
            iTwitcherLocationAnnotation *annotation = (iTwitcherLocationAnnotation *)view.annotation;
            
            annotation.region=nil;
            
            [_locations removeObject:annotation];
            
            
            
            
            
            
            
        }
        
        
        if (newState == MKAnnotationViewDragStateEnding) {
            
            iTwitcherLocationAnnotation *annotation = (iTwitcherLocationAnnotation *)view.annotation;
            iTwitcherLocationAnnotationView *annotationView = (iTwitcherLocationAnnotationView *)view;
            [annotationView updateRadiusOverlay];
            
            [_locations addObject:annotation];
            
            
        }
    } else {
        // MapPlayAnnotation *annotation = (MapPlayAnnotation *)view.annotation;
    }
}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
	if([overlay isKindOfClass:[MKCircle class]]) {
		// Create the view for the radius overlay.
		MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
		circleView.strokeColor = [UIColor greenColor];
		circleView.fillColor = [[UIColor greenColor] colorWithAlphaComponent:0.3];
		
		return circleView;
	}
	
	return nil;
}





- (void)handleLongPress:(UIGestureRecognizer*)recogniser {
    // 1
    if (recogniser.state == UIGestureRecognizerStateBegan) {
        // 2
        NSLog(@"Gesture Recognizer");
        if(_birdLocation == nil) {
            NSArray *locationData = [ObservationLocation getLocationsInContext:[self birdDatabase].managedObjectContext ];
            NSLog(@"Count in Handle Long Press %d",[locationData count]);
            NSLog(@"Bird Location is nil");
        } else {
            NSLog(@"_birdLocation %@",_birdLocation.name);
        }
        // if (_droppedPin) {
        //   [self.mapView removeAnnotation:_droppedPin];
        //[self.birdLocation removeObservationsObject:];
        // _droppedPin = nil;
        // }
        
        // 3
        CGPoint touchPoint = [recogniser locationInView:self.mapView];
        CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        
        SpeciesObservation *observation = [[SpeciesObservation alloc] initWithContext:_birdDatabase.managedObjectContext];
        observation.latitude = @(touchMapCoordinate.latitude);
        observation.longitude = @(touchMapCoordinate.longitude);
        
        NSDate *date = [NSDate date];
        observation.date = date;
        
        // format it
        //  NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        //  [dateFormat setDateFormat:@"HH:mm:ss zzz"];
        
        // convert it to a string
        //  NSString *dateString = [dateFormat stringFromDate:date];
        
        
        NSLog(@"observation latitude %f",[observation.latitude floatValue]);
        
        [_birdLocation addSpeciesObservationsObject:observation];
        _droppedPin = [[iTwitcherObservationAnnotation alloc] annotationForObservation:observation];
        _droppedPin.coordinate = touchMapCoordinate;
        // get the current date
        
        
        
        
        [_annotations addObject:_droppedPin];
        [self.mapView addAnnotation:_droppedPin];
        [self.mapView setCenterCoordinate:self.mapView.region.center animated:NO];
        //[self reloadInputViews];
        // 5
        // [self.mapView addAnnotation:_droppedPin];
        //[_mapView reloadInputViews];
        
        //  [self.birdDatabase saveToURL:self.birdDatabase.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
        //      if (success) {
        //          [self loadData];
        
        //      }
        //      if (!success) {
        //          NSLog(@"failed to save document %@",self.birdDatabase.localizedName);
        //      }
        //  }];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	 if ([segue.identifier isEqualToString:@"AddBirds"]){
        NSLog(@"Segue Identifier is OBSERVATION");
     //   iTwitcherSpeciesViewController *speciesViewController =
     //     segue.destinationViewController;
         NSLog(@"Location of file is %@",self.birdDatabase.fileURL);
         
       // speciesViewController.birdDatabase = self.birdDatabase;
        
        
    } else if ([segue.identifier isEqualToString:@"mapDetails"]) {
      //  NSLog(@"MapDetails Chosen segue");
     //   iBirderMapDetailsViewController *viewController =
     //   segue.destinationViewController;
     //   viewController.mapDetailsDelegate = self;
    //    viewController.currentMapType=self.mapView.mapType;
    //    viewController.birdDatabase=self.birdDatabase;
        
    }
}


- (void) zoomToCurrentLocation
{
    NSLog(@"Zooming");
    NSLog(@"latitude %+.6f, longitude %+.6f\n",
          self.currentLocation.coordinate.latitude,
        self.currentLocation.coordinate.longitude);
    //CLLocation *location = [self.locationManager location];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.currentLocation.coordinate, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    // 3
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    // 4
    [self.mapView setRegion:adjustedRegion animated:YES];
    
}

- (void)bannerViewDidLoadAd:(ADBannerView *)bannerView {
    if (!self.iAdBannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        // Assumes the banner view is just off the bottom of the screen.
        bannerView.frame = CGRectOffset(bannerView.frame, 0, -bannerView.frame.size.height);
        [UIView commitAnimations];
        self.iAdBannerIsVisible = YES;
    }
    
    
}

- (void)bannerView:(ADBannerView *)bannerView didFailToReceiveAdWithError:(NSError *)error{
    if (self.iAdBannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        // Assumes the banner view is placed at the bottom of the screen.
        bannerView.frame = CGRectOffset(bannerView.frame, 0, bannerView.frame.size.height);
        [UIView commitAnimations];
        self.iAdBannerIsVisible = NO;
    }
}


- (void)useDocument
{
    
    // First we need to see if the document exists at the file URL. This is done in viewDidLoad
    // (the setting of the URL). If the document does not exist at the URL, we move the already
    // created document to the file's URL and open it. If successful we call the "documentReady"
    // method.
    
    if (self.birdDatabase.documentState == UIDocumentStateClosed) {
        // exists on disk, but we need to open it
        
        [self.birdDatabase openWithCompletionHandler:^(BOOL success) {
            if (success) {
                //[self populateDocument];
                NSLog(@"Document moved from state closed to open");
            } else {
                NSLog(@"Document State Closed could not open");
            }
            
            
        }];
    } else if (self.birdDatabase.documentState == UIDocumentStateNormal) {
        // already open and ready to use
        NSLog(@"Document state normal");
        
        //[self populateDocument];
    }
}


@end
