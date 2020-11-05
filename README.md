# AbaAccess.jl
A simple module with one function MeshObtain to get mesh information, including nodes, elements, nodesets and elsets from an .inp file.
---
## Documents
### Read an `.inp` file
*example*
```julia
NodeDict,ElemDict,NSetDict,ElSetDict=MeshObtain(InpName);
```
The information of nodes,elements,nsets and elsets will be stored in dictionarys.

*Attention: both nset and elset now just support defined by nodes and elements id. And keyword \*part and \*assembly are not support yet.*

### Write an `.inp` file
*example*
```julia

# open a file
FileName = "test.inp"
fID = open(FileName,"w");

# write nodes
NodesWrite!(fID,NodeDict);

# write elements
ElemType = "CPE4";    # any type you need
ElementsWrite!(fID,ElemDict;ElemType=ElemType);

# write nset
SetWrite!(fID,NSetDict);

# write elset 
ElSetWrite!(fID,ElSetDict);

# close the file
close(fID);

```

Meanwhile, an optional function is also provided to output the mesh information easily:
```julia

# give a file name and out put it
FileName = "test2.inp";
LazyMeshWrite(NodeDict,ElemDict,NSetDict,ElSetDict;ElemType=ElemType,FileName=FileName);

```


---
## Installation
```julia
pkg> add https://github.com/bplcn/AbaAccess.jl.git
```
