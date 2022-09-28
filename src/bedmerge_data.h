#pragma once 

#include "otools.h"


class Bedmerge {
public: 

    // GTF related 
    std::vector < std::string > ensemblIDvector;
    std::vector < std::string > geneNameVector;
    std::vector < std::string > gtfChrVector;
    std::vector < int > gtfStartVector; 
    std::vector < int > gtfEndVector;
    std::vector < std::string > gtfStrandVector;

    std::unordered_map < std::string, int > gtfGeneIndexMap; 

    unsigned int ensemblIDvector_size;

    // BED RELATED 
    
    std::vector < double > phenotypeValVector; 
    std::string sampleID;
    
    // OUTPUT FILE RELATED 
    std::string outputFileName;

    
    // FUNCTIONS 

    void readFeatureCountsPhenotypes(std::string);
    void readGTF(std::string);
    void writeAnno();
    void populateOutputFile(std::string &);

    


};