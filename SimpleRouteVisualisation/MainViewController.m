//
//  ViewController.m
//  SimpleRouteVisualisation
//
//  Created by Mikołaj-iMac on 24.06.2016.
//  Copyright © 2016 Mikołaj Płachta. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize listOfPaths, source, destination, points, table, loading;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [loading setHidden:YES];
    listOfPaths = [[NSMutableArray alloc] init];
    points = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ([listOfPaths count]);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Opcje dróg na trasie %@ - %@", sourceCity, destinationCity];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    RoutingObject *cellData = [listOfPaths objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"Dystans: %.3f km - czas podróży %.0fh:%.0fm - ilość punktów pośrednich: %lu",cellData.distance, floor((cellData.time)/3600), (cellData.time)/60 - (floor((cellData.time)/3600)*60), [cellData.waypoints count]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"toMap" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.table indexPathForSelectedRow];
    MapViewController *destViewController = segue.destinationViewController;
    destViewController.routing = [listOfPaths objectAtIndex:indexPath.row];
}

-(IBAction) startLookingFor:(id)sender
{
    // procedura wyszukiwania tras
    if(!([source.text isEqualToString:@""] || [destination.text isEqualToString:@""]))
    {
        if(listOfPaths.count > 0)
        {
            [listOfPaths removeAllObjects];
            [points removeAllObjects];
            [self.table reloadData];
            [self.table setHidden:YES];
        }
        [loading setHidden:NO];
        [loading startAnimating];
        [self readPointsOfSource:source.text :destination.text];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Błąd!" message:@"Nie wypełniłeś wszystkich pól!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

-(IBAction) resetValues:(id)sender
{
    // reset wszystkich parametrów
    [listOfPaths removeAllObjects];
    [points removeAllObjects];
    self.source.text = @"";
    self.destination.text = @"";
    [self.table reloadData];
    [self.table setHidden:YES];
    [loading stopAnimating];
    [loading setHidden:YES];
}

-(void) readPointsOfSource:(NSString*)sourceRoute :(NSString*)destinationRoute
{
    // wczytanie współrzednych punktu początkowego
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graphhopper.com/api/1/geocode?q=%@&locale=en&debug=true&limit=1&key=904543d8-df0c-4af5-8fb5-1caa3f0e7e3c",sourceRoute]]
        completionHandler:^(NSData *data,
                            NSURLResponse *response,
                            NSError *error) {
            if (data.length > 0 && error == nil)
            {
                NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    NSDictionary * hits = [dataDict objectForKey:@"hits"];
                    for (NSDictionary *groupDic in hits)
                    {
                        sourceCity = [groupDic objectForKey:@"name"];
                        [points addObject:[[[groupDic objectForKey:@"point"] objectForKey:@"lng"] stringValue]];
                        [points addObject:[[[groupDic objectForKey:@"point"] objectForKey:@"lat"] stringValue]];
                        
                    }
                    if([hits count] > 0)
                    {
                        [self readPointsOfDestination:destinationRoute];
                    } else {
                        [loading stopAnimating];
                        [loading setHidden:YES];
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Błąd!" message:@"Podane miasto źródłowe jest błędne!" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                }];
            }
        }] resume];
}

-(void) readPointsOfDestination:(NSString*)destinationRoute
{
    // wczytanie współrzednych punktu końcowego
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graphhopper.com/api/1/geocode?q=%@&locale=en&debug=true&limit=1&key=904543d8-df0c-4af5-8fb5-1caa3f0e7e3c",destinationRoute]]
        completionHandler:^(NSData *data,
                            NSURLResponse *response,
                            NSError *error) {
            if (data.length > 0 && error == nil)
            {
                NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
     
                    NSDictionary * hits = [dataDict objectForKey:@"hits"];
     
                    for (NSDictionary *groupDic in hits)
                    {
                        destinationCity = [groupDic objectForKey:@"name"];
                        [points addObject:[[[groupDic objectForKey:@"point"] objectForKey:@"lng"] stringValue]];
                        [points addObject:[[[groupDic objectForKey:@"point"] objectForKey:@"lat"] stringValue]];
                    }
                    if([hits count] > 0)
                    {
                        if([sourceCity isEqualToString:destinationCity])
                        {
                            [points removeAllObjects];
                            [loading stopAnimating];
                            [loading setHidden:YES];
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Błąd!" message:@"Miasto źródłowe oraz docelowe nie mogą być takie same!" preferredStyle:UIAlertControllerStyleAlert];
                            
                            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                            [alertController addAction:ok];
                            
                            [self presentViewController:alertController animated:YES completion:nil];
                        } else {
                            [self createRoutingOptions];
                        }
                    } else {
                        [points removeAllObjects];
                        [loading stopAnimating];
                        [loading setHidden:YES];
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Błąd!" message:@"Podane miasto docelowe jest błędne!" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                }];
            }
     }] resume];
}

-(void) createRoutingOptions
{
    // wczytanie możliwy tras pomiędzy dwoma punktami
    NSURLSession *session = [NSURLSession sharedSession];
    NSLog(@"https://graphhopper.com/api/1/route?point=%@%%2C%@&point=%@%%2C%@&points_encoded=false&instructions=false&vehicle=car&locale=en&key=904543d8-df0c-4af5-8fb5-1caa3f0e7e3c",points[1], points[0], points[3], points[2]);
    [[session dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graphhopper.com/api/1/route?point=%@%%2C%@&point=%@%%2C%@&points_encoded=false&instructions=false&vehicle=car&locale=en&key=904543d8-df0c-4af5-8fb5-1caa3f0e7e3c",points[1], points[0], points[3], points[2]]]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                if (data.length > 0 && error == nil)
                {
                    NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        
                        NSDictionary * hits = [dataDict objectForKey:@"paths"];
                        
                        for (NSDictionary *groupDic in hits)
                        {
                            RoutingObject* routing = [[RoutingObject alloc] init];
                            [routing parseData:groupDic :sourceCity :destinationCity];
                            [listOfPaths addObject:routing];
                        }
                        [self.table reloadData];
                        [self.table setHidden:NO];
                        [loading stopAnimating];
                        [loading setHidden:YES];
                    }];
                }
                
            }] resume];
}
@end
