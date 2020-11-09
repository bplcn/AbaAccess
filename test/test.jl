using AbaAccess

InpName = "test/NUAA_logo.inp";
NodeDict,ElemDict,NSetDict,ElSetDict=MeshObtain(InpName);

FileName = "test/NUAA_logo_output.inp"
fID = open(FileName,"w");

# write nodes
NodesWrite!(fID,NodeDict);

# write elements
ElemIDArray = collect(keys(ElemDict));
ElementsWrite!(fID,ElemDict,ElemIDArray;ElemType="CPE4");
# ElementsWrite!(fID,ElemDict;ElemType="CPE4");

# write nset
NSetWrite!(fID,NSetDict);

# write elset 
ElSetWrite!(fID,ElSetDict);

# close the file
close(fID);

FileName = "test/NUAA_logo_output2.inp";
LazyMeshWrite(NodeDict,ElemDict,NSetDict,ElSetDict;ElemType="CPE4",FileName=FileName);