#import "BARImageOutput.h"
#import "BARImageFilter.h"

@interface BARImageFilterGroup : BARImageOutput <BARImageInput>
{
    BOOL isEndProcessing;
}

@property(readwrite, nonatomic, strong) BARImageOutput<BARImageInput> *terminalFilter;
@property(readwrite, nonatomic, strong) NSArray *initialFilters;
@property(readwrite, nonatomic, strong) NSMutableArray *filters;
@property(readwrite, nonatomic, strong) BARImageOutput<BARImageInput> *inputFilterToIgnoreForUpdates; 

// Filter management
- (void)addFilter:(BARImageOutput<BARImageInput> *)newFilter;
- (BARImageOutput<BARImageInput> *)filterAtIndex:(NSUInteger)filterIndex;
- (NSUInteger)filterCount;

@end
