//
//  Cams.h
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 21/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//
// Handles all Web Service communications with the CAMS Server.
// Contains the CAMS Object Repository which contains lists of Zones,
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "CamsObjectRepository.h"
#import <dispatch/dispatch.h>

@class IosSessionDataTask;
@class RequestQueue;


@interface Cams : NSObject<NSURLSessionDelegate, NSURLSessionDataDelegate, CLLocationManagerDelegate>
{
    dispatch_queue_t backgroundQueue;
}

@property (readwrite) CLLocationManager *locationManager;
@property (readwrite) CLLocation *currentLocation;

@property (readwrite) RequestQueue *requeustQueue;
@property (readwrite) CamsObjectRepository *repository;
@property (readwrite) NSDictionary *urls;
@property (readwrite, copy) NSURL *baseUrl;
@property (readwrite) NSURLSession *session;
@property (readwrite) NSMutableDictionary *dataFromWebService;
@property (readwrite) NSMutableDictionary *camsObjectsReceived;


-(id) initWithUrls:(NSDictionary*) urls;
-(void) initializeCamsObjectsReceived;
-(void) camsObjectReceived:(CamsWsRequest) request;
-(BOOL) hasCamsObjectBeenReceived:(CamsWsRequest) request;

-(void) startup;
-(void) startStandardLocationService;
-(void) createSession;
-(void) addConfigurationRequests;
-(void) addAlarmsRequests;
-(void) executeRequests;

-(void) registerApnsToken:(NSString *) token;
-(void) acknowledgeAlarm:(NSNumber *) eventId;

-(void) joinTogetherWsData:(NSUInteger)taskId  data:(NSData*)data;
-(void) getAlarms;
@end

