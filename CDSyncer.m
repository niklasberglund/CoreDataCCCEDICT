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

@end
