//
//  ECSelectMapPointViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/20.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECSelectMapPointViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface ECSelectMapPointViewController ()<
MKMapViewDelegate
>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UIImageView *shopImageView;

@end

@implementation ECSelectMapPointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI {
    WEAK_SELF
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(rightBottomAction)];
    if (!_mapView) {
        _mapView = [[MKMapView alloc] init];
    }
    [self.view addSubview:_mapView];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, 0, 0);
        make.edges.mas_equalTo(weakSelf.view).insets(padding);
    }];
    if (!_shopImageView) {
        _shopImageView = [UIImageView new];
        [_shopImageView setImage:[UIImage imageNamed:@"icon_location"]];
    }
    [_mapView addSubview:_shopImageView];
    [_shopImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.mapView.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.mapView.mas_centerY).offset(-34);
        make.size.mas_equalTo(CGSizeMake(26.5, 30));
    }];
}


#pragma mark - Actions

- (void)rightBottomAction {
    CLLocationCoordinate2D centerCoordinate = _mapView.centerCoordinate;
    if (_didSelectMapPoint) {
        _didSelectMapPoint(centerCoordinate.latitude, centerCoordinate.longitude);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configMap {
    MKCoordinateRegion region;
    region.span.latitudeDelta = 0.005;
    region.span.longitudeDelta = 0.005;
    region.center.latitude = _mapView.userLocation.coordinate.latitude;
    region.center.longitude = _mapView.userLocation.coordinate.longitude;
    [_mapView setRegion:region animated:YES];
    _mapView.showsUserLocation = NO;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [self configMap];
}

@end
