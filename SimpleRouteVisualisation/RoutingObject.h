//
//  RoutingObject.h
//  SimpleRouteVisualisation
//
//  Created by Mikołaj-iMac on 25.06.2016.
//  Copyright © 2016 Mikołaj Płachta. All rights reserved.
//

#ifndef RoutingObject_h
#define RoutingObject_h

#import <Foundation/Foundation.h>

@interface RoutingObject : NSObject 
{
    NSString *source, *destination;
    float distance; // w kilometrach
    float time; // w sekundach
    NSArray* waypoints; //dane wszytkich punktów zapisane po kolei
}

@property (nonatomic) NSString *source;
@property (nonatomic) NSString *destination;
@property (nonatomic) float distance;
@property (nonatomic) NSArray* waypoints;
@property (nonatomic) float time;

-(void) parseData:(NSDictionary*)data :(NSString*)sourceCity :(NSString*)destinationCity;

@end

#endif /* RoutingObject_h */
