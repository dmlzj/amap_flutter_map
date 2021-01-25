//
//  AMapClusterController.m
//  amap_flutter_map
//
//  Created by mac3 on 2021/1/23.
//

#import "AMapClusterController.h"
#import "FlutterMethodChannel+MethodCallDispatch.h"
#import "CoordinateQuadTree.h"
#import "AMapSearchObj.h"
#import "AMapJsonUtils.h"
@interface AMapClusterController()
@property (nonatomic,strong) FlutterMethodChannel *methodChannel;
@property (nonatomic,strong) NSObject<FlutterPluginRegistrar> *registrar;
@property (nonatomic,strong) MAMapView *mapView;
@property (nonatomic,strong) CoordinateQuadTree *coordinateQuadTree;
@end

@implementation AMapClusterController
- (instancetype)init:(FlutterMethodChannel*)methodChannel
             mapView:(MAMapView*)mapView
           registrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    self = [super init];
    if (self) {
        _methodChannel = methodChannel;
        _mapView = mapView;
        //_markerDict = [NSMutableDictionary dictionaryWithCapacity:1];
        _registrar = registrar;
        
        __weak typeof(self) weakSelf = self;
        
        [_methodChannel addMethodName:@"markers#update" withHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
 //           id markersToAdd = call.arguments[@"markersToAdd"];
//            if ([markersToAdd isKindOfClass:[NSArray class]]) {
//                [weakSelf addMarkers:markersToAdd];
//            }
//            id markersToChange = call.arguments[@"markersToChange"];
//            if ([markersToChange isKindOfClass:[NSArray class]]) {
//                [weakSelf changeMarkers:markersToChange];
//            }
//            id markerIdsToRemove = call.arguments[@"markerIdsToRemove"];
//            if ([markerIdsToRemove isKindOfClass:[NSArray class]]) {
//                [weakSelf removeMarkerIds:markerIdsToRemove];
//            }
            result(nil);
        }];
    }
    return self;
}

- (void)addClusters:(NSArray*)clustersToAdd
{
    if(!self.coordinateQuadTree){
        self.coordinateQuadTree = [[CoordinateQuadTree alloc]init];
    }
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary* dic in clustersToAdd) {
        AMapPOI *amappoi = [AMapJsonUtils modelFromDict:dic modelClass:[AMapPOI class]];
        AMapGeoPoint * location = [[AMapGeoPoint alloc]init];
        NSArray * locArr =dic[@"position"];
        location.latitude =  [locArr[0]floatValue];
        location.longitude = [locArr[1]floatValue];
        amappoi.location = location;
        amappoi.address = dic[@"data"];//当成扩展字段 存数据了
        [arr addObject:amappoi];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /* 建立四叉树. */
       
        
        //从bitmapDesc中解析UIImage
        [self.coordinateQuadTree buildTreeWithPOIs:arr];

        dispatch_async(dispatch_get_main_queue(), ^{
                /* 计算当前mapView区域内需要显示的annotation. */
                NSLog(@"First time calculate annotations.");
                [self addAnnotationsToMapView:self.mapView];
        });
    });
}
- (void)addAnnotationsToMapView:(MAMapView *)mapView
{
    /* 判断是否已建树. */
    if (self.coordinateQuadTree.root == nil)
    {
        return;
    }
    /* 根据当前zoomLevel和zoomScale 进行annotation聚合. */
    double zoomScale = self.mapView.bounds.size.width / self.mapView.visibleMapRect.size.width;
    /* 基于先前建立的四叉树索引，计算当前需要显示的annotations. */
    NSArray *annotations = [self.coordinateQuadTree clusteredAnnotationsWithinMapRect:mapView.visibleMapRect
                                withZoomScale:zoomScale
                                 andZoomLevel:mapView.zoomLevel];

    /* 更新annotations. */
    [self updateMapViewAnnotationsWithAnnotations:annotations];
}
///* 更新annotation. */
- (void)updateMapViewAnnotationsWithAnnotations:(NSArray *)annotations
{
    /* 用户滑动时，保留仍然可用的标注，去除屏幕外标注，添加新增区域的标注 */
    NSMutableSet *before = [NSMutableSet setWithArray:self.mapView.annotations];
    [before removeObject:[self.mapView userLocation]];
    NSSet *after = [NSSet setWithArray:annotations];

    /* 保留仍然位于屏幕内的annotation. */
    NSMutableSet *toKeep = [NSMutableSet setWithSet:before];
    [toKeep intersectSet:after];

    /* 需要添加的annotation. */
    NSMutableSet *toAdd = [NSMutableSet setWithSet:after];
    [toAdd minusSet:toKeep];

    /* 删除位于屏幕外的annotation. */
    NSMutableSet *toRemove = [NSMutableSet setWithSet:before];
    [toRemove minusSet:after];

    /* 更新. */
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mapView addAnnotations:[toAdd allObjects]];
        [self.mapView removeAnnotations:[toRemove allObjects]];
    });
}
@end
