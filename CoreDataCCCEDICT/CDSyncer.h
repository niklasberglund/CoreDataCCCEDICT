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

@property (nonatomic, strong) NSMutableData *downloadedData;
@property (nonatomic, assign) long long dataSize;

// stashed away blocks passed to the getDataFileFromURL methods
@property (nonatomic, copy) void (^completionBlock)(NSData *, NSError *);
@property (nonatomic, copy) void (^progressBlock)(NSNumber *);

- (void)testStore;
- (void)getLatestDataInfoOnCompletion:(void (^)(NSDictionary *databaseInfo, NSError *error))completionBlock;
- (void)getDataFileFromURL:(NSURL *)url OnCompletion:(void (^)(NSData *data, NSError *error))completionBlock;
- (void)getDataFileFromURL:(NSURL *)url OnCompletion:(void (^)(NSData *data, NSError *error))completionBlock onProgress:(void (^)(NSNumber *percentage))progressBlock;

@end
