//
//  CDSyncer.h
//  CC-CEDICT-downloader
//
//  Created by Niklas Berglund on 1/17/16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CDSyncer : NSObject

- (void)testStore;
- (void)getLatestDataInfoOnCompletion:(void (^)(NSDictionary *databaseInfo, NSError *error))completionBlock;

@end
