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
#import "CamsObjectRepository.h"
#import <dispatch/dispatch.h>

@class IosSessionDataTask;
@class RequestQueue;

@protocol MapsArrivedFromServerProtocol <NSObject>
    - (void)mapsArrivedFromServer;
@end



@interface Cams : NSObject<NSURLSessionDelegate, NSURLSessionDataDelegate>
{
    dispatch_queue_t backgroundQueue;
}

@property (assign) id<MapsArrivedFromServerProtocol> delegateMapsArrived;

@property (readwrite) RequestQueue *requeustQueue;
@property (readwrite) CamsObjectRepository *repository;
@property (readwrite, copy) NSURL *baseUrl;
@property (readwrite) NSURLSession *session;
@property (readwrite) NSMutableDictionary *dataFromWebService;
@property (readwrite) NSMutableDictionary *camsObjectsReceived;

-(id) initWithBaseUrl:(NSURL*) url;
-(void) initializeCamsObjectsReceived;
-(void) camsObjectReceived:(CamsWsRequest) request;
-(void) startup;
-(void) createSession;
-(void) addConfigurationRequests;
-(void) addAlarmsRequests;
-(void) executeRequests;

-(void) registerApnsToken:(NSString *) token;
-(void) acknowledgeAlarm:(NSNumber *) eventId;

-(void) joinTogetherWsData:(NSUInteger)taskId  data:(NSData*)data;
-(void) getAlarms;
@end
