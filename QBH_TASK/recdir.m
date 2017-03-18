function list=recdir(folder)
list = dir(folder);
for i=1:length(list)
    list(i).name=[folder,'/',list(i).name];
end
if (length(list)<2)
    disp('');
end
list(1)=[];
list(1)=[];
L=length(list);
for i=1:L
    if list(i).isdir
        list=[list;recdir(list(i).name)];
     
    end
end
end