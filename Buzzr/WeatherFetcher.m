//
//  WeatherFetcher.m
//  Buzzr
//
//  Created by Conor Eby on 11/23/13.
//  Copyright (c) 2013 Conor Eby. All rights reserved.
//

#import "WeatherFetcher.h"

@implementation WeatherFetcher

+ (NSURL *)URLforWeatherAtLatitude: (float)latitude atLongitude:(float) longitude
{
	NSString * url = [NSString stringWithFormat:@"http://api.worldweatheronline.com/free/v1/weather.ashx?q=%f%%2C%f&format=json&num_of_days=1&key=r6xc2g7gbydh3acemb39yu8w", latitude, longitude];
	return [NSURL URLWithString:url];
}

+ (NSURL *)URLforCurrentWeatherIcon: (NSDictionary *)fetchResults
{
	NSString *iconString = [[[fetchResults valueForKeyPath:URL_FOR_WEATHER_ICON] firstObject] firstObject];
	return [NSURL URLWithString:iconString];
}

@end
