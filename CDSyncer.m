//
//  CDSyncer.m
//  CC-CEDICT-downloader
//
//  Created by Niklas Berglund on 1/17/16.
//
//

#import "CDSyncer.h"
#import "CDCCCEDICT.h"

@implementation CDSyncer

- (void)testStore
{
    // store test
    NSManagedObject *entryManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Entry" inManagedObjectContext:[CDCCCEDICT managedObjectContext]];
    [entryManagedObject setValue:[NSDate date] forKey:@"added"];
    [entryManagedObject setValue:[NSDate date] forKey:@"modified"];
    
    NSManagedObject *englishManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"English_entry" inManagedObjectContext:[CDCCCEDICT managedObjectContext]];
    [englishManagedObject setValue:@"test" forKey:@"english"];
    
    NSManagedObject *chineseManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Chinese_entry" inManagedObjectContext:[CDCCCEDICT managedObjectContext]];
    [chineseManagedObject setValue:@"试" forKey:@"simplified"];
    [chineseManagedObject setValue:@"試" forKey:@"traditional"];
    [chineseManagedObject setValue:@"shi4" forKey:@"pinyin"];
    
    [entryManagedObject setValue:englishManagedObject forKey:@"inEnglish"];
    [entryManagedObject setValue:chineseManagedObject forKey:@"inChinese"];
    
    [CDCCCEDICT saveContext];
    
    // fetch test
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:[CDCCCEDICT managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    // Specify criteria for filtering which objects to fetch
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"<#format string#>", <#arguments#>];
    //[fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    //NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"<#key#>"
    //ascending:YES];
    //[fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [[CDCCCEDICT managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"%@", error);
    }
    else {
        NSLog(@"Fetched objects");
        NSLog(@"%@", fetchedObjects);
    }
}

#pragma mark - CC-CEDICT download
- (void)getLatestDataInfoOnCompletion:(void (^)(NSDictionary *databaseInfo, NSError *error))completionBlock
{
    NSError *error;
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"https://www.mdbg.net/chindict/chindict.php?page=cc-cedict"] encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"%@", result);
    
    if (error) {
        completionBlock(nil, error);
        return;
    }
    
    NSString *latestReleaseResult = nil;
    NSString *latestReleaseStart = @"Latest release: <strong>";
    NSString *latestReleaseEnd = @"</strong>";
    
    NSString *numberOfEntriesResult = nil;
    NSString *numberOfEntriesStart = @"Number of entries: <strong>";
    NSString *numberOfEntriesEnd = @"</strong>";
    
    NSString *zipArchiveResult = nil;
    NSString *zipArchiveStart = @"<strong><a href=\"";
    NSString *zipArchiveEnd = @"\">";
    
    NSString *gzipArchiveResult = nil;
    NSString *gzipArchiveStart = @"<strong><a href=\"";
    NSString *gzipArchiveEnd = @"\">";
    
    NSScanner *scanner = [NSScanner scannerWithString:result];
    
    // scan latest release
    [scanner scanUpToString:latestReleaseStart intoString:nil];
    scanner.scanLocation += latestReleaseStart.length;
    [scanner scanUpToString:latestReleaseEnd intoString:&latestReleaseResult];
    
    // scan number of entries
    [scanner scanUpToString:numberOfEntriesStart intoString:nil];
    scanner.scanLocation += numberOfEntriesStart.length;
    [scanner scanUpToString:numberOfEntriesEnd intoString:&numberOfEntriesResult];
    
    // scan zip archive location
    [scanner scanUpToString:zipArchiveStart intoString:nil];
    scanner.scanLocation += zipArchiveStart.length;
    [scanner scanUpToString:zipArchiveEnd intoString:&zipArchiveResult];
    
    // scan gzip archive location
    [scanner scanUpToString:gzipArchiveStart intoString:nil];
    scanner.scanLocation += gzipArchiveStart.length;
    [scanner scanUpToString:gzipArchiveEnd intoString:&gzipArchiveResult];
    
    // date formatter for the latest release date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    
    // turn the results into pretty objects
    NSDate *latestReleaseDate = [dateFormatter dateFromString:latestReleaseResult];
    NSNumber *numberOfEntries = [NSNumber numberWithInt:[numberOfEntriesResult intValue]];
    NSURL *zipArchiveURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.mdbg.net/chindict/%@", zipArchiveResult]];
    NSURL *gzipArchiveURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.mdbg.net/chindict/%@", gzipArchiveResult]];
    
    NSDictionary *resultDict = @{
                                 @"latestReleaseDate": latestReleaseDate,
                                 @"numberOfEntries": numberOfEntries,
                                 @"zipArchiveURL": zipArchiveURL,
                                 @"gzipArchiveURL": gzipArchiveURL
                                 };
    
    completionBlock(resultDict, error);
}

@end
