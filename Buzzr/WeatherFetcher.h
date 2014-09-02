//
//  WeatherFetcher.h
//  Buzzr
//
//  Created by Conor Eby on 11/23/13.
//  Copyright (c) 2013 Conor Eby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherFetcher : NSObject
#define WeatherAPIKey = @"r6xc2g7gbydh3acemb39yu8w"

#define WEATHER_RESULTS_CURRENT_CONDITION @"data.current_condition.weatherDesc.value"
#define WEATHER_RESULTS_CURRENT_TEMPERATURE_F @"data.current_condition.temp_F"
#define WEATHER_RESULTS_CURRENT_TEMPERATURE_C @"data.current_condition.temp_C"
#define URL_FOR_WEATHER_ICON @"data.current_condition.weatherIconUrl.value"

+ (NSURL *)URLforWeatherAtLatitude: (float)latitude atLongitude:(float) longitude;
+ (NSURL *)URLforCurrentWeatherIcon: (NSDictionary *)fetchResults;
@end
