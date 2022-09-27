#include "bedmerge_data.h"

void Bedmerge::readGTF(std::string fgtf)
{
    string buffer; vector < string > tokens;

	
	input_file fd (fcov);
	if (fd.fail()) vrb.error("Cannot open file!");
	
    unsigned int gtfIndex;
    gtfIndex = 0;

	//Read GTF
	while (getline(fd, buffer)) {
	    boost::split(tokens, std::string(str.s), boost::is_any_of("\t "));
		// Check whether tokens start with ###
        if (tokens[2] != "gene") continue; 
        gtfChrVector.push_back(tokens[0]);
        gtfStartVector.push_back(tokens[3]);
        gtfEndVector.push_back(tokens[4]);
        gtfStrandVector.push_back(tokens[6]);
        
		

	fd.close();
}