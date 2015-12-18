//
//  ViewController.h
//  DrawFlag
//
//  Created by Prasanna Nanda on 12/17/15.
//  Copyright © 2015 C S Prasanna Nanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyMKOverlayRenderer.h"

@import MapKit;
@interface ViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *overLayDict;
@property (nonatomic,strong) IBOutlet MKMapView *mapView;

@end

