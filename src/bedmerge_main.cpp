#include "bedmerge_data.h"


int main (){

    std::cout << "This is a test" << std::endl;
    Bedmerge P;
    
    std::string fgtf = "/Users/srv/beegfs/scratch/users/l/lykoskou/TE/V4/data_syscol/info_files/hg19_genes_TE_1811_s.subsampled.gtf";
    std::string ftxt = "/Users/srv/beegfs/scratch/users/l/lykoskou/TE/V4/data_syscol/1009N.raw.counts.subsampled.txt.gz";
    std::string fout = "/Users/srv/beegfs/scratch/users/l/lykoskou/TE/V4/test.bed";

    P.readGTF(fgtf);
    P.readFeatureCountsPhenotypes(ftxt);
    std::cout << P.sampleID << "\n";
    

    
    return 0;
}