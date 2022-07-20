using AbaAccess

InpName = "test/NUAA_logo_nodes.inp";
NodeDict,~,~,~=MeshObtain(InpName);

InpName = "test/NUAA_logo_elems.inp";
~,ElemDict,~,~=MeshObtain(InpName);