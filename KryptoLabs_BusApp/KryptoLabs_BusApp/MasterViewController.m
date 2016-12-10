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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    busStopManager = [[BusStopManager alloc] init];
    busStopManager.m_BusControllerDelegate = self;
    [busStopManager fetchBusStops:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([CLLocationManager locationServicesEnabled]){
        
        NSLog(@"Location Services Enabled");
        mapView.showsUserLocation = YES;
        [self zoomToCurrentLocation];
    }
    else
    {
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

- (void)zoomToCurrentLocation {
    float spanX = 0.00725;
    float spanY = 0.00725;
    MKCoordinateRegion region;
    region.center.latitude = self.mapView.userLocation.coordinate.latitude;
    region.center.longitude = self.mapView.userLocation.coordinate.longitude;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        NSDate *object = self.objects[indexPath.row];
//        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
//        [controller setDetailItem:object];
//        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
//        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
    else if ([[segue identifier] isEqualToString:@"openBusList"]) {
        MKPointAnnotation *annotation = (MKPointAnnotation *)sender;
        
        BusListController *controller = (BusListController *)[segue destinationViewController];
        NSString *busStopId = [self getBusIdForTitle :annotation.title];
        [controller setBusStopId:busStopId];
    }
}

#pragma mark - Busstopmanager delegate
- (void) busStopRequestCallback : (NSDictionary *)responseDictionary
{
    busStopList = responseDictionary[@"response"];
    [self addAllAnnotations];
}



-(void)addAllAnnotations
{
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
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
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
    id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        [self performSegueWithIdentifier:@"openBusList" sender:annotation];
    }
}

@end
