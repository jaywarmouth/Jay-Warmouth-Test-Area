#!/bin/sh                                                                      
#    SCM Change History                                                        
#                                                                              
#  CAUTION: DO NOT MODIFY THE FOLLOWING CODE                                   
#                                                                              
#    $Archive: COBOL/MasterSource/SHELL SCRIPTS/compspons00mas.sh$                                                               
#    $Author: dlombardo$                                                  
#    $Branch: Release to Production Version 1.0$                                                                
#    $Date: Thursday, May 21, 2015 10:08:09 AM$                                                                  
#    $File: compspons00mas.sh$                                                                  
#    $JustDate: Thursday, May 21, 2015$                                                              
#    $Log$
#    dlombardo - Thursday, May 21, 2015 10:08:09 AM
#    dlombardo - Monday, December 22, 2014 10:20:49 AM                                                                     
#    $Logfile: COBOL/MasterSource/SHELL SCRIPTS/compspons00mas.sh$                                                               
#    $Modtime: Wednesday, May 13, 2015 7:43:56 AM$                                                               
#    $Revision: 1$                                                             
#    $Workfile: compspons00mas.sh$                                                              
# program name  : compspons00mas.sh                                            
# Author        : dick lombardo                                                
# Date          : 2014/12/19                                                   
#                                                                              
                                                                               
OBJ_DIR="/usr/lnk/obj"                                                         
                                                                               
#                                                                              
# Main routine                                                                 
#                                                                              
                                                                               
SPONS00MASO=/usr/lnk/grp/SPONS00MAS.20260506.1
SPONS00MASN=/usr/lnk/grp/SPONS00MAS
SPONS00MASDIF=/usr/lnk/tmp/SPONS00MAS.DIF                                          
export SPONS00MASDIF SPONS00MASO SPONS00MASN
                                                                               
runcobol ${OBJ_DIR}/COMPSPONS00MAS
                                                                               
exit 0                                                                         
