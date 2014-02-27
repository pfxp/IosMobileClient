//
//  IosSessionDataTask.h
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 23/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalSettings.h"

@interface IosSessionDataTask : NSObject
@property (readwrite) CamsWsRequest camsRequestType;
@property (readwrite, strong) NSURLSessionDataTask* sessionDataTask;
@property (readwrite, copy) NSURL* baseUrl;

-(id) initWithRequestType:(CamsWsRequest)request
                 dataTask:(NSURLSessionDataTask *)dataTask
                  baseUrl:(NSURL *)url;

+(NSURL *) generateUrlForRequest:(CamsWsRequest)request baseUrl:(NSURL *)url;
+(NSURL *) generateUrlForApnsRequest:(CamsWsRequest)request baseUrl:(NSURL *)url apnsid:(NSString*)apnsid;
@end
