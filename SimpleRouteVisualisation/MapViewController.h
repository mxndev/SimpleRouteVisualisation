//
//  MapViewController.h
//  SimpleRouteVisualisation
//
//  Created by Mikołaj-iMac on 28.06.2016.
//  Copyright © 2016 Mikołaj Płachta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoutingObject.h"
#import <UIKit/UIKit.h>
@import MapKit;

@interface MapViewController : UIViewController <MKMapViewDelegate>
{
    RoutingObject* routing;
}

@property (nonatomic) RoutingObject* routing;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) MKPolylineRenderer *polylineRender;
@property (nonatomic, strong) MKPolyline *polyline;

@end
