% Evaluation_simple.m
% Author: Emilio Molina (emm@ic.uma.es)
% Date: 17/09/2014
% It matches a bunch of F0 vectors (.pv file), and exports the results
% to a .txt file.

load pvs;
load names;
folder=[];
%algorithms={'manual', 'melodia', 'melodiapoly', 'melotranscript', 'praat', 'praatadjusted', 'pyin', 'rapt', 'ryynanen', 'swipep', 'yin'};
algorithms={'ryynanen'};
curridwhole=1;
idwhole=0;
ntop=10;
strprintf=['%s:'];
for i=1:ntop
    strprintf=[strprintf,'\t%s'];
end
strprintf=[strprintf,'\n'];
for idalg=1:length(algorithms)
    rank=[];
    folder='./PVs_test'; %'./output';
    disp(folder);
    filelist=recdir(folder);
    for id=1:length(filelist)
        if strcmp(filelist(id).name(end-2:end),'.pv')
            d=regexp(filelist(id).name,'_','split');
            targetname=d{end-1};
            tic;
            filelist(id).name=strrep(filelist(id).name,'\','/');
            [topnames,costs]=matchmelody_simple(filelist(id).name, pvs,names,ntop);
            toc;
            rank_aux=find(strcmp(topnames,targetname),1);
            if isempty(rank_aux); rank_aux=Inf; end;
            rank(end+1)=1/rank_aux;
            if rank(end)==0
                cprintf('_red', 'RANK:')
            else
                cprintf('_green', 'RANK:')
            end
            fprintf('%s \n',[num2str(rank(end)),' --                                                   mean: ',num2str(mean(rank))]);
            fprintf('\n');
            
            namefileresults=['baseline_pvstest_',algorithms{idalg},'.txt'];
            
            fid=fopen(namefileresults,'a');
            fprintf(fid,strprintf,...
                strrep(strrep(filelist(id).name,'\','/'),':',''), ...
                topnames{:});
            fclose(fid);
        end
    end
end