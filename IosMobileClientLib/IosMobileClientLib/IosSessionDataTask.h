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
@property (readwrite) NSURLSessionDataTask* sessionDataTask;
@property (readwrite, copy) NSString* baseUrl;

-(id) initWithRequestSype:(CamsWsRequest)request
                 dataTask:(NSURLSessionDataTask *)dataTask
                  baseUrl:(NSString *)url;

+(NSString *) GetUrlSuffixForRequest:(CamsWsRequest) request baseUrl:(NSString *)url;
@end
