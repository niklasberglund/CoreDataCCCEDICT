//
//  CDCCCEDICT.h
//  CC-CEDICT-downloader
//
//  Created by Niklas Berglund on 1/17/16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CDSyncer.h"

@interface CDCCCEDICT : NSObject

//@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
+ (NSManagedObjectContext *)managedObjectContext;
+ (NSManagedObjectModel *)managedObjectModel;
+ (void)saveContext;

+ (void)openDataModelOnCompletion:(void (^)(BOOL success))completionBlock;

@end
