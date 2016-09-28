//
//  ViewController.h
//  SimpleRouteVisualisation
//
//  Created by Mikołaj-iMac on 24.06.2016.
//  Copyright © 2016 Mikołaj Płachta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoutingObject.h"
#import "MapViewController.h"

@interface MainViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray* listOfPaths, *points;
    NSString *sourceCity, *destinationCity;
}

@property (nonatomic) NSMutableArray* listOfPaths;
@property (nonatomic) NSMutableArray* points;
@property(retain) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loading;
@property (strong, nonatomic) IBOutlet UITextField *source;
@property (strong, nonatomic) IBOutlet UITextField *destination;

-(IBAction) startLookingFor:(id)sender;
-(IBAction) resetValues:(id)sender;

-(void) readPointsOfSource:(NSString*)sourceRoute :(NSString*)destinationRoute;
-(void) readPointsOfDestination:(NSString*)destinationRoute;
-(void) createRoutingOptions;
@end