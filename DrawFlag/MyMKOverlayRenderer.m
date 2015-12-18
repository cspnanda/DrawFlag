//
//  MyMKOverlayRenderer.m
//  Trumbs
//
//  Created by Prasanna Nanda on 12/12/15.
//  Copyright © 2015 iosrecipe. All rights reserved.
//

#import "MyMKOverlayRenderer.h"

@interface MyMKOverlayRenderer ()
@property (nonatomic, strong) UIImage *overlayImage;

@end

@implementation MyMKOverlayRenderer
- (instancetype)initWithOverlay:(id<MKOverlay>)overlay overlayImage:(UIImage *)overlayImage {
  self = [super initWithOverlay:overlay];
  if (self) {
    _overlayImage = overlayImage;
  }
  return self;
}
- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context {

  [super drawMapRect:mapRect zoomScale:zoomScale inContext:context];
  MKMapRect theMapRect = [self.overlay boundingMapRect];
  CGRect theRect = [self rectForMapRect:theMapRect];
  @try {
    UIGraphicsPushContext(context);
    UIBezierPath *bpath = [UIBezierPath bezierPath];
    MKPolygon *polyGon = self.polygon;
    MKMapPoint *points = polyGon.points;
    NSUInteger pointCount = polyGon.pointCount;
    CGPoint point = [self pointForMapPoint:points[0]];
    [bpath moveToPoint:point];
    
    for (int i = 1; i < pointCount; i++) {
      point = [self pointForMapPoint:points[i]];
      [bpath addLineToPoint:point];
    }
    [bpath closePath];
    [bpath addClip];
    [_overlayImage drawInRect:theRect blendMode:kCGBlendModeMultiply alpha:0.4];
    UIGraphicsPopContext();
  }
  @catch (NSException *exception) {
    NSLog(@"Caught an exception while drawing radar on map - %@",[exception description]);
  }
  @finally {
  }
}
@end
