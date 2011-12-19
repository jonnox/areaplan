#import <Foundation/Foundation.h>

@interface Search : NSObject

- (int) levenshteinDistanceOfString1: (char*) s1 String2: (char*) s2;

@end

@implementation Search

- (int) levenshteinDistanceOfString1: (const char*) s1 String2: (const char*) s2
{
   const int m = strlen(s1);
   const int n = strlen(s2);
   int d[m][n];
   int i, j;
   for(i=0; i<m; i++)
      d[i][0] = i;
   for(j=0; j<n; j++)
      d[0][j] = j;

   for(j=1; j<n; j++)
   {
      for(i=1; i<m; i++)
      {
         if(s1[i] == s2[j])
         {
            d[i][j] = d[i-1][j-1];
         }
         else
         {
            int min = INT_MAX;

            int deletion   = d[i-1][j] + 1;
            int insertion  = d[i][j-1] + 1;
            int substitute = d[i-1][j-1] + 1;
            if(deletion < min)
               min = deletion;
            if(insertion < min)
               min = insertion;
            if(substitute < min)
               min = substitute;

            d[i][j] = min;
         }
      }
   }

   return d[m-1][n-1];
}

@end

int main(void) {

   Search *s = [[Search alloc] init];
   char *query = "SomeRoomNumberWeAreLookingFor";
   char *name = "SomeLongLocationNameAtSomeParticularVenuePlace";
   int distance = [s levenshteinDistanceOfString1: query String2: name];

   NSLog(@"%d", distance);

   return 0;
}
