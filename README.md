# AbaAccess
A simple module with one function MeshObtain to get mesh information, including nodes, elements, nodesets and elsets from an .inp file.
---
## Documents
*example*
```
julia> NodeDict,ElemDict,NSetDict,ElsetDict=MeshObtain(InpName);
```
The information of nodes,elements,nsets and elsets will be stored in dictionarys.

*Attention: both nset and elset now just support defined by nodes and elements id. And keyword \*part and \*assembly are not support yet.*
---
## Installation
```
pkg> add https://github.com/bplcn/AbaAccess.jl.git
```
