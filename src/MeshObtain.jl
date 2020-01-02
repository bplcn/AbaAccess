function MeshObtain(InpName)
# the function return the mesh information
    # InpName = "Model3D\\Mesh_1.inp"
    fID = open(InpName,"r")
    StrLine = readlines(fID)
    # UserElementDefLine = 0
    # NodesDefLine = 0

    Keywordorcomment = []
    ElementDefLineArray = []
    NodesDefLineArray = []
    NodeSetLineArray = []
    ElSetLineArray = []



    # Obtain the beginning of the nodes and elements definition
    for kline = 1:length(StrLine)

        Strtemp = StrLine[kline]

        if Strtemp[1]=='*'
            push!(Keywordorcomment,kline)
            # Strtemp = filter(x -> !isspace(x), Strtemp)
            Strtemp = split(Strtemp,",")

            if uppercase(Strtemp[1])=="*ELEMENT"
                ElementDefLine = kline
                push!(ElementDefLineArray,ElementDefLine)
            end

            if uppercase(Strtemp[1])=="*NODE"
                NodesDefLine = kline
                push!(NodesDefLineArray,NodesDefLine)
            end

            if uppercase(Strtemp[1])=="*NSET"
                NodeSetLine = kline
                push!(NodeSetLineArray,NodeSetLine)
            end

            if uppercase(Strtemp[1])=="*ELSET"
                ElSetLine = kline
                push!(ElSetLineArray,ElSetLine)
            end
            
        end
    end

    # obtain the mesh
    NodeDict = Dict()
    NodeOut = Dict()
    for knodeblock = 1:length(NodesDefLineArray)
        NodesDefLineStart = NodesDefLineArray[knodeblock]
        NodesDefLineEnd = Keywordorcomment[minimum(findall(Keywordorcomment.>NodesDefLineStart))]

        Strtemp = StrLine[NodesDefLineStart]
        Strtemp = split(Strtemp,",")

        if length(Strtemp)>1
            if Strtemp[end][end-1:end] in ["XX","YY","ZZ","XY","XZ","YZ"]
                # control nodes
                Strnexttemp = StrLine[NodesDefLineStart+1]
                Strnexttemp = split(Strnexttemp,",")
                NodeOut[Strtemp[end][end-1:end]] = parse(Int64,Strnexttemp[1])
                continue
            end
        end

        NodeLines = collect((NodesDefLineStart+1):(NodesDefLineEnd-1))
        NodeTotal = length(NodeLines)
        for knode = 1:NodeTotal
            kline = NodeLines[knode]

            Strtemp = StrLine[kline]
            Strtemp = split(Strtemp,",")
            NodeID = parse(Int64,Strtemp[1])
            if length(Strtemp)<4
                NodeDict[NodeID] = [parse(Float64,Strtemp[2]),parse(Float64,Strtemp[3])];
            else
                NodeDict[NodeID] = [parse(Float64,Strtemp[2]),parse(Float64,Strtemp[3]),parse(Float64,Strtemp[4])];
            end
            
        end
    end

    ElemDict = Dict()
    ElsetDict = Dict()
    for kelemblock = 1:length(ElementDefLineArray)
        ElemDefLineStart = ElementDefLineArray[kelemblock]
        ElemDefLineEnd = Keywordorcomment[minimum(findall(Keywordorcomment.>ElemDefLineStart))]
        ElemLines = collect((ElemDefLineStart+1):(ElemDefLineEnd-1))
        ElemTotal = length(ElemLines)

        ElsetAddSwitch = false
        Strtemp = StrLine[ElemDefLineStart]
        Strtemp = split(Strtemp,", ")

        elemtype =  Strtemp[2][6:end]

        if uppercase(Strtemp[end])[1:5] == "ELSET"
            ElsetAddSwitch = true
            ElsetName = Strtemp[end][7:end]
        end

        ElSetMember = []
        for kelem = 1:ElemTotal
            kline = ElemLines[kelem]
            Strtemp = StrLine[kline]
            Strtemp = split(Strtemp,",")
            ElemID = parse(Int64,Strtemp[1])
            push!(ElSetMember,ElemID)
            if (elemtype=="C3D4")
                ElemDict[ElemID] = [parse(Int64,Strtemp[2]),parse(Int64,Strtemp[3]),
                                    parse(Int64,Strtemp[4]),parse(Int64,Strtemp[5])];
            elseif elemtype=="S3"
                ElemDict[ElemID] = [parse(Int64,Strtemp[2]),parse(Int64,Strtemp[3]),
                                    parse(Int64,Strtemp[4])];
            elseif elemtype=="T3D2"
                ElemDict[ElemID] = [parse(Int64,Strtemp[2]),parse(Int64,Strtemp[3])];
            else
                ElemDict[ElemID] = [parse(Int64,Strtemp[kidloc]) for kidloc = 2:length(Strtemp)]
            end
        end
        if ElsetAddSwitch
            ElsetDict[ElsetName] = ElSetMember
        end
    end

    NSetDict = Dict()
    for ksetblock = 1:length(NodeSetLineArray)
        NSetDefLineStart = NodeSetLineArray[ksetblock]
        NSetDefLineEnd = length(StrLine)+1
        try
            NSetDefLineEnd = Keywordorcomment[minimum(findall(Keywordorcomment.>NSetDefLineStart))]
        catch
        end

        # Strtemp = StrLine[NSetDefLineStart]
        # Strtemp = split(Strtemp,", ")
        # Strtemp = filter(x -> !isspace(x), Strtemp[end])
        # # NSetName = Strtemp[6:end]
        # NSetName = split(Strtemp[2],"=")[end]

        Strtemp = StrLine[NSetDefLineStart]
        Strtemp = filter(x -> !isspace(x), Strtemp)
        Strtemp = split(Strtemp,",")
        NSetName = split(Strtemp[2],"=")[end]

        if NSetName[1]=='_'
            continue
        end

        if Strtemp[end]=="generate"
            kline = NSetDefLineStart+1;
            Strtemp = StrLine[kline];
            Strtemp = filter(x -> !isspace(x), Strtemp);
            if Strtemp[end]==','
                Strtemp = Strtemp[1:end-1];
            end
            Strtemp = split(Strtemp,",");
            NSetMember = collect(parse(Int64,Strtemp[1]):parse(Int64,Strtemp[3]):parse(Int64,Strtemp[2]));

        else
            NodeLines = collect((NSetDefLineStart+1):(NSetDefLineEnd-1))
            NodeTotal = length(NodeLines)
            NSetMember = []
            for knode = 1:NodeTotal
                kline = NodeLines[knode]
                Strtemp = StrLine[kline]
                Strtemp = filter(x -> !isspace(x), Strtemp)

                Strtemp = split(Strtemp,",")
                Strtemp = Strtemp[.~(isempty.(Strtemp))]
                try
                    append!(NSetMember,parse.(Int64,Strtemp))
                catch
                    println("the nset "*NSetName[1]*" seems not a set defined by nodal id.")
                    break
                end
            end
        end
        
        NSetDict[NSetName] = NSetMember
    end

    for ksetblock = 1:length(ElSetLineArray)
        ElSetDefLineStart = ElSetLineArray[ksetblock];
        ElSetDefLineEnd = ElSetDefLineStart != maximum(Keywordorcomment) ? 
                                               Keywordorcomment[minimum(findall(Keywordorcomment.>ElSetDefLineStart))] : 
                                               length(StrLine)+1 ;


        Strtemp = StrLine[ElSetDefLineStart]
        Strtemp = filter(x -> !isspace(x), Strtemp)
        Strtemp = split(Strtemp,",")
        ElSetName = split(Strtemp[2],"=")[end]
        if ElSetName[1]=='_'
            continue
        end

        if Strtemp[end]=="generate"
            kline = ElSetDefLineStart+1;
            Strtemp = StrLine[kline];
            Strtemp = filter(x -> !isspace(x), Strtemp);
            if Strtemp[end]==','
                Strtemp = Strtemp[1:end-1];
            end
            Strtemp = split(Strtemp,",");
            ElSetMember = collect(parse(Int64,Strtemp[1]):parse(Int64,Strtemp[3]):parse(Int64,Strtemp[2]));
        else
            ElemLines = collect((ElSetDefLineStart+1):(ElSetDefLineEnd-1))
            ElemTotal = length(ElemLines)
            ElSetMember = []
            for kelem = 1:ElemTotal
                kline = ElemLines[kelem]
                Strtemp = StrLine[kline]
                Strtemp = filter(x -> !isspace(x), Strtemp)
                if Strtemp[end]==','
                    Strtemp = Strtemp[1:end-1]
                end
                Strtemp = split(Strtemp,",")
                append!(ElSetMember,parse.(Int64,Strtemp))
            end
        end
        

        
        ElsetDict[ElSetName] = ElSetMember
    end
    return NodeDict,ElemDict,NSetDict,ElsetDict
    
end
