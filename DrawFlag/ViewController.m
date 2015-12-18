//
//  ViewController.m
//  DrawFlag
//
//  Created by Prasanna Nanda on 12/17/15.
//  Copyright © 2015 C S Prasanna Nanda. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize overLayDict,mapView;
- (void)viewDidLoad {
  [super viewDidLoad];
  [mapView setCenterCoordinate:CLLocationCoordinate2DMake(37.7833, -122.4167)];
  // Do any additional setup after loading the view, typically from a nib.
  [self countriesOverlays];
  [mapView addOverlays:[overLayDict objectForKey:@"United States"]];
}


- (void)countriesOverlays {
  if(overLayDict == Nil)
    overLayDict = [[NSMutableDictionary alloc] init];
  NSString *fileName = [[NSBundle mainBundle] pathForResource:@"gz_2010_us_040_00_500k" ofType:@"json"];
  NSData *overlayData = [NSData dataWithContentsOfFile:fileName];
  NSArray *countries = [[NSJSONSerialization JSONObjectWithData:overlayData options:NSJSONReadingAllowFragments error:nil] objectForKey:@"features"];
  for (NSDictionary *country in countries) {
    NSMutableArray *overlays = [[NSMutableArray alloc] init];
    NSDictionary *geometry = country[@"geometry"];
    if ([geometry[@"type"] isEqualToString:@"Polygon"]) {
      MKPolygon *polygon = [ViewController overlaysFromPolygons:geometry[@"coordinates"] id:country[@"properties"][@"name"]];
      if (polygon) {
        [overlays addObject:polygon];
      }
      
      
    } else if ([geometry[@"type"] isEqualToString:@"MultiPolygon"]){
      for (NSArray *polygonData in geometry[@"coordinates"]) {
        MKPolygon *polygon = [ViewController overlaysFromPolygons:polygonData id:country[@"properties"][@"name"]];
        if (polygon) {
          [overlays addObject:polygon];
        }
      }
    } else {
      NSLog(@"Unsupported type: %@", geometry[@"type"]);
    }
    [overLayDict setObject:overlays forKey:country[@"properties"][@"name"]];
  }
}

+ (MKPolygon *)overlaysFromPolygons:(NSArray *)polygons id:(NSString *)title
{
  NSMutableArray *interiorPolygons = [NSMutableArray arrayWithCapacity:[polygons count] - 1];
  for (int i = 1; i < [polygons count]; i++) {
    [interiorPolygons addObject:[ViewController polygonFromPoints:polygons[i] interiorPolygons:nil]];
  }
  
  MKPolygon *overlayPolygon = [ViewController polygonFromPoints:polygons[0] interiorPolygons:interiorPolygons];
  overlayPolygon.title = title;
  
  
  return overlayPolygon;
}

+ (MKPolygon *)polygonFromPoints:(NSArray *)points interiorPolygons:(NSArray *)polygons
{
  NSInteger numberOfCoordinates = [points count];
  CLLocationCoordinate2D *polygonPoints = malloc(numberOfCoordinates * sizeof(CLLocationCoordinate2D));
  
  NSInteger index = 0;
  for (NSArray *pointArray in points) {
    polygonPoints[index] = CLLocationCoordinate2DMake([pointArray[1] floatValue], [pointArray[0] floatValue]);
    index++;
  }
  
  MKPolygon *polygon;
  
  if (polygons) {
    polygon = [MKPolygon polygonWithCoordinates:polygonPoints count:numberOfCoordinates interiorPolygons:polygons];
  } else {
    polygon = [MKPolygon polygonWithCoordinates:polygonPoints count:numberOfCoordinates];
  }
  free(polygonPoints);
  
  return polygon;
}


- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
  if ([overlay isKindOfClass:[MKPolygon class]])
  {
    MyMKOverlayRenderer *renderer = [[MyMKOverlayRenderer alloc] initWithOverlay:overlay overlayImage:[UIImage imageNamed:@"USA.png"]];
    return renderer;
  }
  return nil;
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
