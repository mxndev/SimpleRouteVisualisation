//
//  RoutingObject.m
//  SimpleRouteVisualisation
//
//  Created by Mikołaj-iMac on 25.06.2016.
//  Copyright © 2016 Mikołaj Płachta. All rights reserved.
//

#import "RoutingObject.h"

@implementation RoutingObject

@synthesize distance, waypoints, time, source, destination;

-(void) parseData:(NSDictionary*)data :(NSString*)sourceCity :(NSString*)destinationCity
{
    self.source = sourceCity;
    self.destination = destinationCity;
    self.distance = ([[data objectForKey:@"distance"] floatValue])/1000.0f;
    self.time = ([[data objectForKey:@"time"] floatValue])/1000.0f;
    self.waypoints = [[data objectForKey:@"points"] objectForKey:@"coordinates"];
}

@end