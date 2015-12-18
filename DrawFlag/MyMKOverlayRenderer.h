//
//  MyMKOverlayRenderer.h
//  Trumbs
//
//  Created by Prasanna Nanda on 12/12/15.
//  Copyright © 2015 iosrecipe. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MyMKOverlayRenderer : MKPolygonRenderer
- (instancetype)initWithOverlay:(id<MKOverlay>)overlay overlayImage:(UIImage *)overlayImage;

@end
