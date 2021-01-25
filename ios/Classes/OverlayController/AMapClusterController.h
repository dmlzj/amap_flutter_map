//
//  AMapClusterController.h
//  amap_flutter_map
//
//  Created by mac3 on 2021/1/23.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import <MAMapKit/MAMapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AMapClusterController : NSObject

- (instancetype)init:(FlutterMethodChannel*)methodChannel
             mapView:(MAMapView*)mapView
           registrar:(NSObject<FlutterPluginRegistrar>*)registrar;

- (void)addClusters:(NSArray*)clustersToAdd;
@end

NS_ASSUME_NONNULL_END
