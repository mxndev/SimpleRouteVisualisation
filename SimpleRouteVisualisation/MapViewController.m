//
//  MapViewController.m
//  SimpleRouteVisualisation
//
//  Created by Mikołaj-iMac on 28.06.2016.
//  Copyright © 2016 Mikołaj Płachta. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize routing;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawLineWithPins];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawLineWithPins {
    
    // skasuj istniejące linie
    [self.mapView removeOverlay:self.polyline];
    
    // tablica współrzędnych
    CLLocationCoordinate2D coordinates[self.routing.waypoints.count];
    int i = 0;
    for (NSArray *currentPin in self.routing.waypoints) {
        coordinates[i].longitude = [currentPin[0] floatValue];
        coordinates[i].latitude = [currentPin[1] floatValue];
        i++;
    }
    
    //punkt startowy
    MKPointAnnotation *pointStart = [[MKPointAnnotation alloc] init];
    pointStart.coordinate = coordinates[0];
    pointStart.title = self.routing.source;
    pointStart.subtitle = @"Początek trasy";
    [self.mapView addAnnotation:pointStart];
    
    //punkt końcowy
    MKPointAnnotation *pointEnd = [[MKPointAnnotation alloc] init];
    pointEnd.coordinate = coordinates[self.routing.waypoints.count-1];
    pointEnd.title = self.routing.destination;
    pointEnd.subtitle = @"Koniec trasy";
    [self.mapView addAnnotation:pointEnd];
    
    // stwórz linie łączace kolejne punkty
    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coordinates count:self.routing.waypoints.count];
    [self.mapView addOverlay:polyline];
    self.polyline = polyline;
    
    // stwórz MKPolylineView i dodaj go do mapy
    self.polylineRender = [[MKPolylineRenderer alloc]initWithPolyline:self.polyline];
    self.polylineRender.strokeColor = [UIColor blueColor];
    self.polylineRender.lineWidth = 5;
    
    MKCoordinateRegion region = self.mapView.region;
    region.center = coordinates[(self.routing.waypoints.count)/2];
    region.span.longitudeDelta = (self.routing.distance/118.0f)*0.18;
    region.span.latitudeDelta = (self.routing.distance/118.0f)*0.18;
    [self.mapView setRegion:region];
    
}

- (MKPolylineRenderer *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    return self.polylineRender;
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"pin"];
    annView.pinTintColor = [UIColor blueColor];
    annView.canShowCallout = YES;
    return annView;
}

@end
