#pragma once 

#include "../common/data.h"


class Bedmerge {
public: 

    // GTF related 
    std::vector < std::string > ensemblIDvector;
    std::vector < std::string > geneNameVector;
    std::vector < std::string > gtfChrVector;
    std::vector < int > gtfStartVector; 
    std::vector < int > gtfEndVector;
    std::vector < std::string > gtfStrandVector;

    std::unordered_map < std::string, unsigned int > gtfGeneIndexMap; 


    // BED RELATED 
    
    std::vector < double > phenotypeValVector; 

    // FUNCTIONS 

    void readPhenotypes(std::string);
    void readGTF(std::string);

    


};