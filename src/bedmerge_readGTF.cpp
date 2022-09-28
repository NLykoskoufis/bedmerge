#include "bedmerge_data.h"

void Bedmerge::readGTF(std::string fgtf)
{
    std::string buffer; vector < std::string > tokens;

	
	input_file fd (fgtf);
	if (fd.fail()) std::cout << "Cannot open file!" << std::endl;
	
    int gtfIndex;
    gtfIndex = 0;

    unsigned int linecount = 0;

	//Read GTF
	while (getline(fd, buffer)) {
	    boost::split(tokens, buffer, boost::is_any_of("\t "));
		// Check whether tokens start with ###
        if (linecount % 1000 == 0) std::cout << "Read " << std::to_string(linecount) << "\n";
        linecount++;
        if (tokens[2] != "gene") continue; 
        gtfChrVector.push_back(tokens[0]);
        gtfStartVector.push_back(std::stof(tokens[3]));
        gtfEndVector.push_back(std::stof(tokens[4]));
        gtfStrandVector.push_back(tokens[6]);
        ensemblIDvector.push_back(tokens[9].substr(1,tokens[9].size() - 3));
        geneNameVector.push_back(tokens[11].substr(1, tokens[17].size() - 3));

        gtfGeneIndexMap.insert(std::make_pair(tokens[9].substr(1,tokens[9].size() - 3), gtfIndex));
        gtfIndex++;
        
    }
    ensemblIDvector_size = ensemblIDvector.size();
    std::cout << "Finished reading GTF file\n";
	fd.close();
}