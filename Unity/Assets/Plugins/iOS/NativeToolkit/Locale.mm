//
//  Locale.m
//  NativeToolkit
//
//  Created by Ryan on 31/01/2015.
//
//

#import "Locale.h"
#import "StringTools.h"

double latitude;
double longitude;
double horizontalAccuracy;

@implementation Locale

CLLocationManager *locationManager;

- (Locale *)init
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;

    //NSLog(@"[LocationAPI]accNear:%f accBest:%f", kCLLocationAccuracyNearestTenMeters, kCLLocationAccuracyBest);
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];
    
    [locationManager startUpdatingLocation];
    
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;
{
    CLLocation *location = [locations lastObject];
    latitude = location.coordinate.latitude;
    longitude = location.coordinate.longitude;
    horizontalAccuracy = location.horizontalAccuracy;
    
    //NSLog(@"[LocationAPI]lat:%f long:%f acc:%f", latitude, longitude, horizontalAccuracy);
}

@end

static Locale* localeDelegate = NULL;

extern "C"
{
    char* getLocale()
    {
        NSLocale *locale = [NSLocale currentLocale];
        NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
        
        NSLog(@"##locale: %@", countryCode);
        
        return [StringTools createCString:[countryCode UTF8String]];
    }
    
    void startLocation()
    {
        if(localeDelegate == NULL) localeDelegate = [[Locale alloc] init];
    }

    double getHorizontalAccuracy() 
    {
        return horizontalAccuracy; 
    }
    
    double getLongitude()
    {
        return longitude;
    }
    
    double getLatitude()
    {
        return latitude;
    }
}
