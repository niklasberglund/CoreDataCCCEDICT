//
//  CDSyncer.h
//  CC-CEDICT-downloader
//
//  Created by Niklas Berglund on 1/17/16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CDSyncer : NSObject<NSURLSessionDelegate, NSURLSessionTaskDelegate>

typedef NS_ENUM(NSUInteger, CDSyncerStatus) {
    CDSyncerStatusIdle,
    CDSyncerStatusCheckingDatabaseInfo,
    CDSyncerStatusDownloadingDatabase,
    CDSyncerStatusImportingDatabase
};

@property (nonatomic, assign) NSUInteger status;
@property (nonatomic, assign) NSUInteger totalDatabaseEntries;
@property (nonatomic, assign) NSUInteger importedDatabaseEntries;

@property (nonatomic, strong) NSMutableData *downloadedData;
@property (nonatomic, assign) long long dataSize;

// stashed away blocks passed to the getDataFileFromURL methods
@property (nonatomic, copy) void (^completionBlock)(NSData *, NSError *);
@property (nonatomic, copy) void (^progressBlock)(NSNumber *);

- (void)testStore;
- (void)getLatestDataInfoOnCompletion:(void (^)(NSDictionary *databaseInfo, NSError *error))completionBlock;
- (void)getDataFileFromURL:(NSURL *)url onCompletion:(void (^)(NSData *data, NSError *error))completionBlock;
- (void)getDataFileFromURL:(NSURL *)url onCompletion:(void (^)(NSData *data, NSError *error))completionBlock onProgress:(void (^)(NSNumber *percentage))progressBlock;
- (void)updateWithData:(NSData *)dictionaryData onCompletion:(void (^)(NSData *data, NSError *error))completionBlock;

@end
