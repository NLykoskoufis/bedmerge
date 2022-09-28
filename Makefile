##########################################
# SET THESE 6 PATHS CORRECTLY TO COMPILE #
##########################################
BOOST_INC=
BOOST_LIB=
RMATH_INC=
RMATH_LIB=
HTSLD_INC=
HTSLD_LIB=
#########################################################
# EXAMPLES:                                             #
# BOOST_INC=/usr/include/                               #
# BOOST_LIB=/usr/lib/x86_64-linux-gnu/                  #
# RMATH_INC=$(HOME)/Tools/R-3.6.1/src/include           #
# RMATH_LIB=$(HOME)/Tools/R-3.6.1/src/nmath/standalone  #
# HTSLD_INC=$(HOME)/Tools/htslib-1.9                    #
# HTSLD_LIB=$(HOME)/Tools/htslib-1.9                    #
#########################################################
define n


endef

#INSTALL LOCATIONS
#CHANGE prefix TO INSTALL LOCALLY
prefix      = /usr/local
exec_prefix = $(prefix)
bindir      = $(exec_prefix)/bin
datarootdir = $(prefix)/share
mandir      = $(datarootdir)/man
man1dir     = $(mandir)/man1
autocompdir = /etc/bash_completion.d
MKDIR_P = mkdir -p
INSTALL = install -p
INSTALL_DATA    = $(INSTALL) -m 644
INSTALL_EXE    = $(INSTALL) -m 755
INSTALL_DIR     = $(MKDIR_P) -m 755
INSTALL_MAN     = $(INSTALL_DATA)
INSTALL_PROGRAM = $(INSTALL)
INSTALL_SCRIPT  = $(INSTALL_EXE)

#COMPILER MODE C++11
CXX=g++ -std=c++0x

#COMPILER FLAGS
CXXFLAG_REL=-O3
CXXFLAG_DBG=-g
CXXFLAG_WRN=-Wall -Wextra -Wno-sign-compare -Wno-unused-local-typedefs -Wno-deprecated -Wno-unused-parameter

#BASE LIBRARIES
LIB_FLAGS=-lz -lgsl -lbz2 -llzma -lgslcblas -lm -lpthread 

#FILE LISTS
BFILE=bin/bedmerge
SFILE=$(shell find scripts -name *.R)
MFILE=$(shell find doc -name *.1)
HFILE=$(shell find src -name *.h)
TFILE=$(shell find lib -name *.h)
CFILE=$(shell find src -name *.cpp | LC_ALL=C sort)
OFILE=$(shell for file in `find src -name *.cpp | LC_ALL=C sort`; do echo obj/$$(basename $$file .cpp).o; done)
VPATH=$(shell for file in `find src -name *.cpp | LC_ALL=C sort`; do echo $$(dirname $$file); done)
ifneq (, $(shell which git))
 GITVS=$(shell git describe --tags --long --abbrev=10 2>/dev/null)
 ifneq (, $(GITVS))
  $(info Compiling version $(GITVS))
  CXXFLAG_REL+= -DQTLTOOLS_VERSION=\"$(GITVS)\"
  CXXFLAG_DBG+= -DQTLTOOLS_VERSION=\"$(GITVS)\"
 endif
endif

#STATICLY LINKED LIBS
LIB_FILES=$(HTSLD_LIB)/libhts.a $(BOOST_LIB)/libboost_iostreams.a $(BOOST_LIB)/libboost_program_options.a
#INCLUDE DIRS
IFLAG=-Ilib/OTools -isystem lib -I$(HTSLD_INC) -I$(BOOST_INC)

#ONLY FOR MAC STATIC LINKING, ARCHIVES ASSUMED TO BE INSTALLED WITH BREW.IF YOU HAVE THESE IN OTHER LOCATIONS MODIFY THE NEXT 5 LINES 
MZ=/usr/local/opt/zlib/lib/libz.a
MCBLAS=/usr/local/lib/libgslcblas.a
MGSL=/usr/local/lib/libgsl.a
MBZ2=/usr/local/opt/bzip2/lib/libbz2.a
MLZMA=/usr/local/lib/liblzma.a
MCURL=/usr/local/opt/curl/lib/libcurl.a

#MAC SPECIFIC STUFF
UNAME := $(shell uname)
ifeq ($(UNAME),Darwin)
 CXXFLAG_REL+= -fvisibility=hidden -fvisibility-inlines-hidden
 CXXFLAG_DBG+= -fvisibility=hidden -fvisibility-inlines-hidden
endif

#DEFAULT VERSION (SET UP THE VARIABLES IN THE BEGINING OF THE MAKEFILE)
all: CXXFLAG=$(CXXFLAG_REL) $(CXXFLAG_WRN)
all: LDFLAG=$(CXXFLAG_REL)
all: $(BFILE)


#STATIC VERSION (SET UP THE VARIABLES IN THE BEGINING OF THE MAKEFILE)
static: CXXFLAG=$(CXXFLAG_REL) $(CXXFLAG_WRN)
static: LDFLAG=$(CXXFLAG_REL)
ifeq ($(UNAME),Darwin)
#ASSUMES YOU INSTALLED REQUIRED LIBRARIES WITH BREW. SEE ABOVE WHERE THESE VARIABLES ARE SET
static: LIB_FILES+= $(MZ) $(MCBLAS) $(MGSL) $(MBZ2) $(MLZMA) $(MCURL)
static: LIB_FLAGS=-lm -lpthread
else
static: LIB_FLAGS=-Wl,-Bstatic -lz -lgsl -lbz2 -llzma -lgslcblas -lcurl -Wl,-Bdynamic -lm -lpthread
endif
static: $(BFILE)



personal: BOOST_INC=/Users/nikolaoslykoskoufis/Documents/Programming/Tools/boost_1_74_0/
personal: BOOST_LIB=/Users/nikolaoslykoskoufis/Documents/Programming/Tools/boost_1_74_0/stage/lib
personal: HTSLD_INC=/Users/nikolaoslykoskoufis/Documents/Programming/Tools/htslib-1.11
personal: HTSLD_LIB=/Users/nikolaoslykoskoufis/Documents/Programming/Tools/htslib-1.11
personal: static


baobab: BOOST_INC=/srv/beegfs/scratch/groups/funpopgen/Tools/boost_1_71_0/
baobab: BOOST_LIB=/srv/beegfs/scratch/groups/funpopgen/Tools/boost_1_71_0/stage/lib/
baobab: HTSLD_INC=/srv/beegfs/scratch/groups/funpopgen/Tools/htslib-1.9/
baobab: HTSLD_LIB=/srv/beegfs/scratch/groups/funpopgen/Tools/htslib-1.9/
baobab: static


#COMPILATION RULES
$(BFILE): $(OFILE)
	$(CXX) $^ $(LIB_FILES) -o $@ $(LIB_FLAGS) $(LDFLAG) 

obj/%.o: %.cpp $(TFILE) $(HFILE) $(CFILE)
	$(CXX) -o $@ -c $< $(CXXFLAG) $(IFLAG)


clean: 
	rm -f obj/*.o $(BFILE)