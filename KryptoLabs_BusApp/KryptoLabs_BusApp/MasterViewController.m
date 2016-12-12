//
//  MasterViewController.m
//  KryptoLabs_BusApp
//
//  Copyright © 2016 Riddhi Ojha. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

@interface MasterViewController ()

@property NSMutableArray *objects;
@end

@implementation MasterViewController
@synthesize mapView;
@synthesize locationManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    //initialize managers
    busStopManager = [[BusStopManager alloc] init];
    busStopManager.m_BusControllerDelegate = self;
//    [busStopManager fetchBusStops:nil];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
   
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //check location authorization status
    if ([CLLocationManager locationServicesEnabled]){
        CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
        if (authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
            authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
            self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
            self.locationManager.distanceFilter=kCLDistanceFilterNone;
            [self.locationManager startMonitoringSignificantLocationChanges];
            [self.locationManager startUpdatingLocation];
            isUpdatingLocation = YES;
            mapView.showsUserLocation = YES;
        }
        else
        {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
    else
    {
        //show alert when location services disabled
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"App Permission Denied"
                                              message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"Cancel action");
                                       }];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                   }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //pass parameters when opening segue
    if ([[segue identifier] isEqualToString:@"openBusList"]) {
        MKPointAnnotation *annotation = (MKPointAnnotation *)sender;
        BusListController *controller = (BusListController *)[segue destinationViewController];
        NSString *busStopId = [self getBusIdForTitle :annotation.title];
        [controller setBusStopId:busStopId];
    }
}

#pragma mark - Busstopmanager delegate
- (void) busStopRequestCallback : (NSDictionary *)responseDictionary
{
    //handle callback from bus list web service
    busStopList = responseDictionary[@"response"];
    [self addAllAnnotations];
}



-(void)addAllAnnotations
{
    //add all nearby bus stop location annotations
    self.mapView.delegate=self;
    for(int i = 0; i < busStopList.count; i++)
    {
        NSString *busStopName = busStopList[i][@"name"];
        NSDictionary *locationDict = busStopList[i][@"location"];
        NSArray *coordinate = locationDict[@"coordinates"];
        [self addPinWithTitle:busStopName AndCoordinate:coordinate];
    }
    [self setMapViewRect];
}

-(void)addPinWithTitle:(NSString *)title AndCoordinate:(NSArray *)coordinates
{
    MKPointAnnotation *mapPin = [[MKPointAnnotation alloc] init];
    double longitude = [coordinates[0] doubleValue];
    double latitude = [coordinates[1] doubleValue];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    mapPin.title = title;
    mapPin.coordinate = coordinate;
    [self.mapView addAnnotation:mapPin];
}

- (void) setMapViewRect
{
    //set viewable rect for map showing all annotations
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in mapView.annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    [mapView setVisibleMapRect:zoomRect animated:YES];
}

#pragma mark - Bus name to ID
- (NSString *) getBusIdForTitle : (NSString *)busStopName
{
    for (int i=0; i<busStopList.count; i++) {
        NSString *compareToName = busStopList[i][@"name"];
        if ([busStopName isEqualToString:compareToName]) {
            return busStopList[i][@"id"];
        }
    }
    return nil;
}

#pragma mark - MapView delegate

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    float spanX = 0.1;
    float spanY = 0.1;
    MKCoordinateRegion region;
    NSLog(@"%f -------- %f", self.mapView.userLocation.location.coordinate.latitude, self.mapView.userLocation.location.coordinate.longitude);
    region.center.latitude = self.mapView.userLocation.location.coordinate.latitude;
    region.center.longitude = self.mapView.userLocation.location.coordinate.longitude;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    [self.mapView setRegion:region];
    
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    //add custom annotation image
    MKAnnotationView *annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"String"];
    if(!annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"String"];
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    annotationView.image = [UIImage imageNamed:@"AnnotationImage"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    //enable callout
    id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        [self performSegueWithIdentifier:@"openBusList" sender:annotation];
    }
}

#pragma mark - CLLocation manager delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //when update location-fetch coordinates and get bus stops
    CLLocation *newLocation = locations[[locations count] -1];
    CLLocation *currentLocation = newLocation;
    NSString *longitude = [NSString stringWithFormat:@"%.5f", currentLocation.coordinate.longitude];
    NSString *latitude = [NSString stringWithFormat:@"%.5f", currentLocation.coordinate.latitude];

    if (currentLocation != nil && isUpdatingLocation)
    {
        isUpdatingLocation = NO;
        float spanX = 0.1;
        float spanY = 0.1;
        MKCoordinateRegion region;
        region.center.latitude = currentLocation.coordinate.latitude;
        region.center.longitude = currentLocation.coordinate.longitude;
        region.span.latitudeDelta = spanX;
        region.span.longitudeDelta = spanY;
        [self.mapView setRegion:region];
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:longitude,@"longitude",
                                    latitude, @"latitude", nil];
        [busStopManager fetchBusStops:dictionary];

    }
    else if (currentLocation !=nil)
    {
//        [locationManager stopUpdatingLocation];
    }
    else {
          UIAlertView *errorAlert = [[UIAlertView alloc]
                                     initWithTitle:@"Error" message:@"Unable to Get Your Location"
                                     delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
          [errorAlert show];
      }
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)authorizationStatus {
    //when first time authorisation changes, handle accordingly
    if (authorizationStatus == kCLAuthorizationStatusDenied) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"App Permission Denied"
                                              message:@"Permission denied to acces your location."
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                   }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if (authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
        authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        self.locationManager.distanceFilter=kCLDistanceFilterNone;
        [self.locationManager startMonitoringSignificantLocationChanges];
        [self.locationManager startUpdatingLocation];
        isUpdatingLocation = YES;
        mapView.showsUserLocation = YES;
    }
}

@end
