#include "bedmerge_data.h"

void Bedmerge::readFeatureCountsPhenotypes(std::string ftxt)
{	
	/* 
		1. Read the .txt quantification file generated by featureCounts. 
		2. Get sample ID and write it in output file
		3. Create vector of molecular phenotype expression according to index of GTF file.
			3.1 IF gene is missing from GTF vector --> Raise error as it should not happen.
			3.2 IF GTF gene is not in BED file then just leave the 0 expression default value. 
		4. Once vector generated, write it into file. Need to first cache the vector and then write as the order of the molecular phenotypes might be different.
	*/

	std::string buffer; std::vector < std::string > tokens;
	unsigned int linecount = 0;

	phenotypeValVector  = std::vector < double > (ensemblIDvector_size, 0.0); // Generate vector with the number of phenotypes in GTF filled with 0.0 IMPORTANT ==> Needs to be cleaned before reading next file. 

	input_file fd (ftxt);
	if (fd.fail()) std::cout << "Cannot open file!" << std::endl;

	while (getline(fd, buffer))
	{
		if (linecount % 1000 == 0 ) std::cout << "Read " << linecount << "\n";
		linecount++;

		boost::split(tokens, buffer, boost::is_any_of("\t")); // Split line by tab
		if (tokens[0] == "Geneid") sampleID = tokens[6]; 
		if(tokens[0].substr(0,1) == "#" ) continue;
		// Check index of geneID in GTF. 
		std::unordered_map<std::string, int>::iterator it;
		it = gtfGeneIndexMap.find(tokens[0]); // Look for ensemblID gtfGeneIndexMap
		if (it != gtfGeneIndexMap.end())
    	{
			std::cout << it->first << "->" << it->second << "\n";
			phenotypeValVector.at(it->second) = std::stod(tokens[6]);
    	}
	}

	fd.close();
}