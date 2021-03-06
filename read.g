#############################################################################
##
#W    read.g                  The FSR package             
#W                                                               
##

#############################################################################
##
#R  Read the install files.
##
ReadPackage( "FSR", "lib/misc.gi" ); #misc

ReadPackage( "FSR", "lib/outputs.gi" ); # the output formatting functions

ReadPackage( "FSR", "lib/fsr.gi" ); # the top-level functions

ReadPackage( "FSR", "lib/lfsr.gi" ); # the top-level functions

ReadPackage( "FSR", "lib/outlfsr.gi" ); # the output formatting functions - LFSR specific

ReadPackage( "FSR", "lib/drawlfsr.gi" ); # LFSR drawing functions - outputs a *.tex file

Print("read.g done!!!\n");
#E  read.g . . . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here