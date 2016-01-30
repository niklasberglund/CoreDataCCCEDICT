//
//  CDSyncer.m
//  CC-CEDICT-downloader
//
//  Created by Niklas Berglund on 1/17/16.
//
//

#import "CDSyncer.h"
#import "CDCCCEDICT.h"
#import <UZKArchive.h>
#import "CDTranslationEntry.h"

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
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"<#format string#>", arguments];
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

- (void)getDataFileFromURL:(NSURL *)url onCompletion:(void (^)(NSData *data, NSError *error))completionBlock
{
    self.completionBlock = completionBlock;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url];
    [dataTask resume];
}

- (void)getDataFileFromURL:(NSURL *)url onCompletion:(void (^)(NSData *, NSError *))completionBlock onProgress:(void (^)(NSNumber *))progressBlock
{
    self.completionBlock = completionBlock;
    self.progressBlock = progressBlock;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url];
    [dataTask resume];
}

#pragma mark - NSURLSession delegate methods
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    completionHandler(NSURLSessionResponseAllow);
    
    self.dataSize = [response expectedContentLength];
    _downloadedData = [NSMutableData new];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [_downloadedData appendData:data];
    
    // invoke percentageBlock
    if (self.progressBlock) {
        NSNumber *progressNumber =[NSNumber numberWithFloat:(float)(_downloadedData.length/(float)_dataSize)];
        self.progressBlock(progressNumber);
    }
    
    // download complete?
    if (_downloadedData.length == _dataSize) {
        // write to temporary location
        NSString *tempArchivePath = [NSString stringWithFormat:@"file://%@CC-CEDICT.txt.zip", NSTemporaryDirectory()];
        NSURL *tempArchiveURL = [NSURL URLWithString:tempArchivePath];
        BOOL writeSuccess = [_downloadedData writeToURL:tempArchiveURL atomically:YES]; // TODO: check writeSuccess
        
        // extract zip file
        NSError *archiveError;
        UZKArchive *archive = [[UZKArchive alloc] initWithURL:tempArchiveURL error:&archiveError];
        NSError *listError;
        NSArray *fileNames = [archive listFilenames:&listError];
        
        NSError *extractError = nil;
        [archive extractFilesTo:NSTemporaryDirectory() overwrite:YES progress:^(UZKFileInfo * _Nonnull currentFile, CGFloat percentArchiveDecompressed) {
            NSURL *tempDirURL = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@", NSTemporaryDirectory()]];
            NSURL *extractedFileURL = [tempDirURL URLByAppendingPathComponent:currentFile.filename];
            
            NSError *readFileError = nil;
            
            // invoke completionBlock
            if (self.completionBlock) {
                self.completionBlock([NSData dataWithContentsOfURL:extractedFileURL], readFileError);
            }
            else { // this should not be possible
                NSLog(@"No completionBlock.......");
            }
        } error:&extractError];
    }
}

- (void)updateWithData:(NSData *)dictionaryData onCompletion:(void (^)(NSData *, NSError *))completionBlock
{
    NSString *dictionaryString = [[NSString alloc] initWithData:dictionaryData encoding:NSUTF8StringEncoding];
    NSArray *lines = [dictionaryString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSDate *databaseUpdateDate; // set further down
    
    // iterate over all lines in file
    for (NSString *line in lines) {
        // skip commented out and empty lines
        if (line.length < 1) {
            continue;
        }
        else if ([line characterAtIndex:0] == '#') {
            if ([line characterAtIndex:1] == '!') { // lines starting with #! contains db info
                if ([line containsString:@"#! time="]) {
                    NSString *databaseTimestampString = [line substringFromIndex:8];
                    databaseUpdateDate = [NSDate dateWithTimeIntervalSince1970:[databaseTimestampString intValue]];
                    NSLog(@"%@", databaseUpdateDate);
                }
            }
            
            continue;
        }
        
        NSLog(@"%@", line);
        
        NSArray *components = [line componentsSeparatedByString:@"/"];
        NSString *chineseComponent = components[0];
        
        NSString *traditionalChinese;
        NSString *simplifiedChinese;
        NSString *pinyin;
        
        NSScanner *chineseScanner = [NSScanner scannerWithString:chineseComponent];
        [chineseScanner scanUpToString:@" " intoString:&traditionalChinese];
        [chineseScanner scanUpToString:@" [" intoString:&simplifiedChinese];
        [chineseScanner setScanLocation:[chineseComponent rangeOfString:@" ["].location+2];
        [chineseScanner scanUpToString:@"]" intoString:&pinyin];
        
        NSArray *englishTranslations = [components subarrayWithRange:NSMakeRange(1, components.count - 2)];
        
        CDTranslationEntry *translationEntry = [CDTranslationEntry translationEntryWithTraditionalChinese:traditionalChinese simplifiedChinese:simplifiedChinese pinyin:pinyin englishTranslations:englishTranslations];
        
        NSManagedObjectContext *managedObjectContext = [CDCCCEDICT managedObjectContext];
        NSManagedObject *chineseManagedObject = [translationEntry chineseManagedObjecInManagedObjectContext:managedObjectContext];
        NSArray *englishManagedObjectsArray = [translationEntry englishManagedObjectsInManagedObjectContext:managedObjectContext];
        NSManagedObject *entryManagedObject = [translationEntry entryManagedObjectWithChinese:chineseManagedObject english:englishManagedObjectsArray date:[NSDate date] inManagedObjectContext:managedObjectContext];
        
        [CDCCCEDICT saveContext];
        
        
        NSLog(@"%@", line);
        NSLog(@"%@", simplifiedChinese);
        NSLog(@"%@", traditionalChinese);
        NSLog(@"%@", pinyin);
    }
}

@end
