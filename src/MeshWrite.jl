"""
    NodesWrite!(fID::IOStream,NodeDict::Dict;SetName="")

    write nodes location 
"""
function NodesWrite!(fID::IOStream,NodeDict::Dict;SetName="")

    if isempty(filter(x->!isspace(x),SetName))
        println(fID,"*Node");
    else
        println(fID,"*Node, nset="*SetName);
    end

    NodeIDArray = sort(collect(keys(NodeDict)));
    for nodeID in NodeIDArray
        if length(NodeDict[nodeID])==3 # 3D
            println(fID,"$(nodeID), $(NodeDict[nodeID][1]), $(NodeDict[nodeID][2]), $(NodeDict[nodeID][3])");
        elseif length(NodeDict[nodeID])==2 # 2D
            println(fID,"$(nodeID), $(NodeDict[nodeID][1]), $(NodeDict[nodeID][2])");
        end
    end
    
    return fID

end

"""
    ElementsWrite!(fID::IOStream,ElemDict::Dict;Type::String,SetName="")

write element definition
"""
function ElementsWrite!(fID::IOStream,ElemDict::Dict;ElemType::String,SetName="")

    if isempty(filter(x->!isspace(x),SetName))
        println(fID,"*Element, type="*ElemType);
    else
        println(fID,"*Element, type="*ElemType*",elset="*SetName);
    end

    ElemIDArray = sort(collect(keys(ElemDict)));
    for elemID in ElemIDArray
        elemStr = "$(elemID)"
        for knode = 1:length(ElemDict[elemID])
            elemStr*=", $(ElemDict[elemID][knode])"
        end
        println(fID,elemStr);
    end
   
    return fID
    
end

"""
    ElementsWrite!(fID::IOStream,ElemDict::Dict;ElemIDArray::Array,ElemType::String,SetName="")

write element definition with given elemID array
"""
function ElementsWrite!(fID::IOStream,ElemDict::Dict,ElemIDArray::Array;ElemType::String,SetName="")

    if isempty(filter(x->!isspace(x),SetName))
        println(fID,"*Element, type="*ElemType);
    else
        println(fID,"*Element, type="*ElemType*",elset="*SetName);
    end

    sort!(ElemIDArray);

    for elemID in ElemIDArray
        elemStr = "$(elemID)"
        for knode = 1:length(ElemDict[elemID])
            elemStr*=", $(ElemDict[elemID][knode])"
        end
        println(fID,elemStr);
    end
   
    return fID
    
end



"""
    NSetWrite!(fID::IOStream,NSetDict::Dict)

write nset
"""
function NSetWrite!(fID::IOStream,NSetDict::Dict)
    
    for (SetName,SetMembers) in NSetDict
        println(fID,"*Nset, nset="*SetName);
        nnode = length(SetMembers);
        nline = Int64.((length(SetMembers)+10-mod(length(SetMembers),10))/10);
        for kline = 1:(nline-1)
            strtemp = "";
            for kmem = 1:10
                strtemp = strtemp*"$(SetMembers[(kline-1)*10+kmem]),";
            end
            println(fID,strtemp);
        end

        strtemp = "";
        for kmem = 1:mod(length(SetMembers),10)
            strtemp = strtemp*"$(SetMembers[(nline-1)*10+kmem]),";
        end
        if ~isempty(strtemp)
            println(fID,strtemp);
        end

    end

end

"""
    ElSetWrite!(fID::IOStream,ElSetDict::Dict)

write elset
"""
function ElSetWrite!(fID::IOStream,ElSetDict::Dict)
    
    for (SetName,SetMembers) in ElSetDict
        println(fID,"*Elset, elset="*SetName);
        nnode = length(SetMembers);
        nline = Int64.((length(SetMembers)+10-mod(length(SetMembers),10))/10);
        for kline = 1:(nline-1)
            strtemp = "";
            for kmem = 1:10
                strtemp = strtemp*"$(SetMembers[(kline-1)*10+kmem]),";
            end
            println(fID,strtemp);
        end

        strtemp = "";
        for kmem = 1:mod(length(SetMembers),10)
            strtemp = strtemp*"$(SetMembers[(nline-1)*10+kmem]),";
        end
        if ~isempty(strtemp)
            println(fID,strtemp);
        end

    end

end

"""
    LazyMeshWrite(NodeDict::Dict,ElemDict::Dict,NSetDict::Dict,ElSetDict::Dict;FileName::String)

write the base information that the mesh need
"""
function LazyMeshWrite(NodeDict::Dict,ElemDict::Dict,NSetDict::Dict,ElSetDict::Dict;ElemType::String,FileName::String)
    
    fID = open(FileName,"w");

    NodesWrite!(fID,NodeDict);
    ElementsWrite!(fID,ElemDict;ElemType=ElemType);
    NSetWrite!(fID,NSetDict);
    ElSetWrite!(fID,ElSetDict);

    close(fID)

end