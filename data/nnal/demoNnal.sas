/*  Data, NHANES Tobacco Smoke Exposure.
NHANES: National Health and Nutrition Examination Survey
For demonstration of cumulative ROC curve analysis for a ternary ordinal outcome of self-reported tobacco smoke exposure.

File:   nhanes_SI3.csv
        Comma-delimited text file with 5 variables
        16990 records

Variables
    SEQN        Unique identifier for NHANES participant
                Numeric
                Original NHANES variable
    SDDSRVYR    NHANES cycle
                Original NHANES variable
                Numeric
                    5 => 2007 - 2008
                    6 => 2009 - 2010
                    7 => 2011 - 2012
    urxnalLN    Ln NNAL, Urine [ng/mL]: natural log transformed from URXNAL (original NHANES variable)
                    NNAL: 4-[methylnitrosamino]-1-[3-pyridyl]-1-butanol (CAS No. 76014-81-8)
                Numeric
    shsX3_C     Tobacco Smoke Exposure
                Character
                Three categories of self-reported tobacco smoke exposure
                    Non-exposed: non-user of tobacco products and not exposed to secondhand tobacco smoke
                    SHS Exposed: non-user of tobacco products exposed to secondhand tobacco smoke
                        SHS: secondhand tobacco smoke
                    Combusted, Exlusive: user of combusted tobacco products exclusively (exclusive smoker)
    shsX3       Tobacco Smoke Exposure
                Numeric
                Three categories of tobacco smoke exposure, corresponding to shsX3_C
                    0 => Non-exposed
                    1 => SHS Exposed
                    2 => Combusted tobacco, Exlusive
*/
LIBNAME demo    ".\data\nnal" ;

PROC FORMAT ;
    Value nhCyc
        5  = "2007 - 2008"
        6  = "2009 - 2010"
        7  = "2011 - 2012"
    ;
    Value exp3G
        0  = "Non-Exposed"
        1  = "ETS-Exposed"
        2  = "Smoker, Exclusive"
    ;
RUN ;

PROC IMPORT OUT= WORK._nnal
            DATAFILE= "./data/nnal/nhanes_SI3.csv"
            DBMS=CSV REPLACE ;
RUN ;

DATA demo.nnal_SI ;
    LENGTH  shsX3_C $ 30 ;
    SET _nnal ;
    LABEL   URXNALln=   "Ln NNAL, urine [ng/ml]"
            shsX3=      "Exposure"
            shsX3_C=    "Exposure"
            SEQN        Unique identifier for NHANES participant
            SDDSRVYR    NHANES cycle
    ;
    FORMAT  SDDSRVYR    nhCyc.
            shsX3       exp3G.
    ;
RUN ;

PROC SORT   DATA=   demo.nnal_SI ;
    BY SDDSRVYR shsX3 SEQN ;
RUN ;
