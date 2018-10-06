############
#Arguments checking and object building
############
ECGPreprocess <- function(ComparisonID,
                        ExpressionData,
                        MinGene,
                        MaxGene,
                        SeedNumber,
                        BootstrapNumber,
                        PCorrection,
                        DBSpecies,
                        PCorrectionMethod,
                        WilcoxonTest,
                        FisherTest,
                        AnalysisDomain,
                        GeneIdentifier,
                        completeTest){

    #Check the expression data. ExpressionData must be a data frame or a path
    #for a text file tab separated containing at least 3
    #columns. First column mandatory corresponds to gene names,
    #according to GeneIdentifier argument. Second, third and the
    #others correspond to the gene samples expression.
    if(!missing(ExpressionData)){
        GeneExpressionData <- checkExpressionData(ExpressionData)
    }else{
        stop("Please inform a valid expression data!")
    }

    #Check the comparison IDs. ComparisonID argument must be a vector in wich 
    #each element corresponds to 2 sample columns from
    #the expression data. The data sample columns in each element from the
    #vector are comma separated.
    if(!missing(ComparisonID)){
        ComparisonID <- checkComparisonID(ComparisonID,GeneExpressionData)
    }else{
        stop("Please inform a valid comparison ID!")
    }

    #Check the minimum and maximum number of genes per group of a GFAG 
    #(Group of Functionally Associated Genes). Both must be integer
    #positive values and different from zero. Besides, the argument MaxGene 
    #must be allways greater than MinGene.
    if(!missing(MinGene) & !missing(MaxGene)){
        GeneNumbers <- checkGeneNumbers(MinGene,MaxGene)
        InfGeneLimit <- GeneNumbers[1]
        SupGeneLimit <- GeneNumbers[2]
    }
    if(missing(MinGene)){
        InfGeneLimit <- as.integer(3)
    }
    if(missing(MaxGene)){
        SupGeneLimit <- as.integer(2000)
    }

    #Check the domain analysis, species reference database and gene identifier.
    #The argument AnalysisDomain must be a character
    #corresponding to a domain (gobp, gocc, gomf, kegg or own). The argument
    #DBSpecies must be a character corresponding to an
    #OrgDb species package (org.Hs.eg.db, org.Dm.eg.db ...) or a character path
    #for an own gene annotation file containing 3 columns:
    #gene name, term annotation and description of the term annotation. 
    #The GeneIdentifier argument must be a character containing
    #the nomenclature to be used (symbol or entrez).
    if(!missing(AnalysisDomain) & !missing(DBSpecies) & 
        !missing(GeneIdentifier)){
        Analysis <- checkAnalysisDomain_DBSpecies_GeneIdentifier(x = 
                    AnalysisDomain, y = DBSpecies, z = GeneIdentifier,
                    k = ExpressionData)
        DomainGroup <- Analysis[[1]]
        DataSpeciesFunctionsSample <- Analysis[[2]]
        DataSpeciesFunctionsRaw <- Analysis[[3]]
        GeneNomenclature <- Analysis[[4]]
    }
    if(missing(AnalysisDomain)){
        stop("Please inform a valid domain!")
    }
    if(missing(DBSpecies)){
        stop("Please inform a valid database species!")
    }
    if(missing(GeneIdentifier)){
        stop("Please inform a valid gene identifier!")
    }

    if(completeTest){
        #Check the seed for random generation numbers. The argument SeedNumber
        #must be a numeric value allways positive, greater than or
        #equal to zero.
        if(!missing(SeedNumber)){
            SeedNumber <- checkSeedNumber(SeedNumber)
        }else{
            SeedNumber <- as.integer(10049)
        }
        
        #Check the number of bootstraps necessary for defining GFAG p-values.
        #The argument BootstrapNumber must be an integer number
        #greater than zero.
        if(!missing(BootstrapNumber)){
            BootstrapNumber <- checkBootstrapNumber(BootstrapNumber)
        }else{
            BootstrapNumber <- as.integer(10000)
        }
        
        #Check the cutoff to be used for one of the p-value correction methods. 
        #The PCorrection argument must be a numeric value between
        #zero and one.
        if(!missing(PCorrection)){
            PCorrection <- checkPCorrection(PCorrection)
        }else{
            PCorrection <- 0.05
        }
        
        #Check the p-value correction method. The PCorrectionMethod argument
        #must be a character corresponding to one of the p.adjust function
        #correction methods (holm, hochberg, hommel, bonferroni, BH, BY, fdr).
        if(!missing(PCorrectionMethod)){
            PCorrectionMethod <- checkPCorrectionMethod(PCorrectionMethod)
        }else{
            PCorrectionMethod <- "fdr"
        }
        
        #Check if it will be performed the Wilcoxon Rank Sum Test. The 
        #WilcoxonTest argument should be TRUE for running the test or FALSE
        #if the test won't be performed.
        if(!missing(WilcoxonTest)){
            WilcoxonTest <- checkWilcoxonTest(WilcoxonTest)
        }else{
            WilcoxonTest <- FALSE
        }
        
        #Check if it will be performed the Fisher Exact Test. The FisherTest
        #argument should be TRUE for running the test or FALSE
        #if the test won't be performed.
        if(!missing(FisherTest)){
            FisherTest <- checkFisherTest(FisherTest)
        }else{
            FisherTest <- FALSE
        }
        
        #Object building, according to the necessary arguments for running 
        #complete analysis ADAM.
        inputObject <- new(Class = "ECGMainData",
                        ComparisonID = ComparisonID,
                        ExpressionData = GeneExpressionData,
                        MinGene = InfGeneLimit,
                        MaxGene = SupGeneLimit,
                        SeedNumber = SeedNumber,
                        BootstrapNumber = BootstrapNumber,
                        PCorrection = PCorrection,
                        DBSpeciesFunctionsSample = DataSpeciesFunctionsSample,
                        DBSpeciesFunctionsRaw = DataSpeciesFunctionsRaw,
                        PCorrectionMethod = PCorrectionMethod,
                        WilcoxonTest = WilcoxonTest,
                        FisherTest = FisherTest,
                        AnalysisDomain = DomainGroup,
                        GeneIdentifier = GeneNomenclature)
    }else{
        #Object building, according to the necessary arguments for running 
        #parcial analysis with ADAM.
        inputObject <- new(Class = "ECGMainData",
                        ComparisonID = ComparisonID,
                        ExpressionData = GeneExpressionData,
                        MinGene = InfGeneLimit,
                        MaxGene = SupGeneLimit,
                        DBSpeciesFunctionsSample = DataSpeciesFunctionsSample,
                        DBSpeciesFunctionsRaw = DataSpeciesFunctionsRaw,
                        AnalysisDomain = DomainGroup,
                        GeneIdentifier = GeneNomenclature)
    }
    return(inputObject)
}