//
//  CoreDataController.h
//  EventFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataController : NSObject

+(void)deleteAllObjects:(NSString *)entityDescription;
+(Photo*)getEventPhotoByEventId:(NSString*)eventId;
+(NSArray*)getEventPhotosByEventId:(NSString*)eventId;
+(NSArray*)getCategories;
+(NSArray*) getAllEvents;
+(NSArray*) getEventByCategoryId:(NSString*)categoryId;
+(Event*) getEventByEventId:(NSString*)eventId;
+(MainCategory*) getCategoryByCategory:(NSString*)category;
+(NSArray*) getCategoryNames;
+(MainCategory*) getCategoryByCategoryId:(NSString*)categoryId;

@end
