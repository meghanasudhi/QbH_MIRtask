function [topnames, costs] = matchmelody_simple(pvfilename,pvs,names,ntop)
% function matchmelody_simple. Find the most similar .MID song given a F0
% vector.
% 
% [topnames, costs] = matchmelody_simple(pvfilename,pvs,names,ntop)
% INPUTS: 
% pvfilename --> F0 vector. Must be an ASCII-formatted in two
% columns (time frequency) with hopsize equal to 0.01s.
% pvs --> pvs.mat computed with BuildModel_simpleBaseline.m
% names --> names.mat computed with BuildModel_simpleBaseline.m
% ntop --> Number of matchers. Common value: ntop=10.
% OUTPUTS:
% topnames --> Name of the MIDI files that better match the query.
% costs --> Matching cost associated to each found MIDI file.

f0=importdata(pvfilename);
f0=f0(:,2);
if sum(f0)>0
    f0=f0(find(f0>0,1):end);
else
    f0=f0+440; %Useless, but it avoids later NaN
end
lastnote=0; %Fill rests with previous pitch note
for i=1:length(f0)
    if f0(i)==0
        f0(i)=lastnote;
    else
        lastnote=f0(i);%median(f0(i:-1:max(1,i-1)));
    end
end
f0inp=69+12*log2(f0/440); %Hz to midi note
lvectors=size(pvs,1);
f0inp=interp1(1:length(f0inp),f0inp,1:length(f0inp)/lvectors:length(f0inp));
f0inp=f0inp-mean(f0inp);
allcosts=[];
allnames=[];

slashes=regexp(pvfilename,'/');
%onlyname=pvfilename(slashes(end)+1:end);
onlyname=pvfilename;
fprintf('%s:\n',onlyname);
fprintf('0%% ');
bar_percentage=0;
for i1=1:size(pvs,2)
    if round(10*i1/size(pvs,2))~=bar_percentage
        bar_percentage=round(10*i1/size(pvs,2));
        fprintf('%i%% ',bar_percentage*10);
    end
    M = similvectors_c(pvs(:,i1)',f0inp);
    %M = simil_vectors(pvs(:,i1)',f0inp);
    [p,q,D] = dpfast(M);
    %[p,q,D] = dp(M);
    C=D(p(end),q(end));
    allcosts(end+1)=C;
    allnames{end+1}=strrep(names{i1},'.mid','');
end


fprintf('\n');
[~,idcosts]=sort(allcosts);
%---------DONE

% OPTIONAL: Graphical plotting
if 0 %--- PLOTTING
    slashes=regexp(onlyname,'_');
    id_ok=find(strcmp(allnames,[onlyname(slashes(end-1)+1:slashes(end)-1),'.mid']));
    [~,aux_id]=min(allcosts(id_ok));
    id_ok=id_ok(aux_id);
    for id=[id_ok idcosts(1:10)]
        M = similvectors_c(pvs(:,id)',f0inp);
        %M = simil_vectors(pvs(:,id)',f0inp);
        [p,q,D] = dpfast(M);
        %[p,q,D] = dp(M);
        C=D(p(end),q(end));
        if id==id_ok
            figure(1)
        else
            figure(2)
        end
        subplot(3,1,2);
        hold off;
        imagesc(M);
        title([strrep(onlyname,'_',' '), '<->', names{id},': ',num2str(C),': COST MATRIX']);
        hold on;
        plot(q,p,'r','Linewidth',2);
        subplot(3,1,3);
        title('Aligned curves');
        hold off;
        plot(pvs(p,id),'b');
        hold on;
        plot(f0inp(q),'r');
        legend({'Candidate','Query'});
        subplot(3,1,1);
        title('Original curves');
        hold off;
        plot(pvs(:,id),'b');
        hold on;
        plot(f0inp,'r');
        legend({'Candidate','Query'});
        if id~=id_ok
            pause;
        end
    end
end
topnames=cell(1,ntop);
i=1;
j=2;
topnames{1}=allnames{idcosts(1)};
costs(1)=allcosts(idcosts(1));
while j<=ntop
    i=i+1;
    if sum(strcmp(topnames(1:j-1),allnames{idcosts(i)}))==0
        topnames{j}=allnames{idcosts(i)};
        costs(j)=allcosts(idcosts(i));
        j=j+1;
    end
end