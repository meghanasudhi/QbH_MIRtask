
% DEMO of baseline usage.
% Note: .cpp files have been compiled in W32 and MACi64. If you are in
% other OS, you may compile these files by typing:
%       'mex dpcore.cpp' and 'mex similvectors_c.cpp'.
% In case you don't want to use MEX compiled sources, you can modify the
% file matchmelody_simple.m, and replace the functions similvectors_c by
% simil_vectors (Line 49) and dpfast by dp (Line 51). But they are slow!

% Build a Model
BuildModel_simpleBaseline; % Approx. time ~5 mins
%Match one single file
matchmelody_simple('./PVs_test/year2003_person00002_00040_manual.pv',...
    pvs,names,10); %('./output/query0355.pv',...
    %pvs,names,10); %Approx. time ~10 seconds 
%Match a complete dataset
evaluation_simple; % Approx. time ~10 mins
