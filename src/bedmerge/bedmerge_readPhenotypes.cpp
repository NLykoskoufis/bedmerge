#include "bedmerge_data.h"

void Bedmerge::readGTF(std::string fgtf)
{
    string buffer; vector < string > tokens;

	
	input_file fd (fcov);
	if (fd.fail()) vrb.error("Cannot open file!");
	

	//Read GTF
	while (getline(fd, buffer)) {
	    boost::split(tokens, std::string(str.s), boost::is_any_of("\t"));
		if (tokens[2] != "gene") continue; 
        
		

	fd.close();
}