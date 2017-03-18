% BuildModel_simpleBaseline.m
% Author: Emilio Molina (emm@ic.uma.es)
% Date: 17/09/2014
%
% Build model: Needed to perform the later melody matching.
% Note: 
% This model just works if all queries start at the beginning MIDI files.
%
% INPUT: Folder with MIDI files, OUTPUT: pvs.mat & names.mat
%---------------------

% Dataset of MIDI files.
folder='./Jang48plus2000noiseESSEN'; %'./midfile';
clear vars; close all;
flag_analyse=1; % 1 = perform analysis

if flag_analyse   
    % Initialize
    vlengths= [500 600 700 800 900 1000 1100];
    hopsize_secs=0.01;
    lvectors = 50;
    pvs=[];
    names=[];
   
    filelist=recdir(folder); %Recursive dir
    for id=1:length(filelist)
        if strcmp(filelist(id).name(end-2:end),'mid')
            midifile=filelist(id).name;
            slashes=regexp(midifile,'/');
            onlyname=midifile(slashes(end)+1:end);
            fprintf('%s\n',onlyname);
            midi=readmidi(midifile);
            M=midiInfo(midi); %We assume only one track
            notes=M(:,[5 6 3]); % onset (s) - offset (s) - pitch (midi note)
            notes(:,[1 2])=notes(:,[1 2])-notes(1,1); %remove initial silence
            notes(1:end-1,2)=notes(2:end,1); %replace rests by previous pitches
            maxlength=round(notes(end,2)/hopsize_secs);
            pv=[];
            for j=1:maxlength % extract the whole pitch vector
                currpos=j*hopsize_secs;
                currpitch = notes(... % current pitch
                    (currpos>=notes(:,1))&...
                    (currpos<notes(:,2)),3);
                if isempty(currpitch)
                    break;
                end
                pv(j)=currpitch;
            end
            for j=1:length(vlengths)
                if vlengths(j)<=length(pv)
                    pv_resampled= interp1(1:vlengths(j),...
                        pv(1:vlengths(j)),...
                        1:vlengths(j)/lvectors:vlengths(j));
                    pvs(end+1,:)=pv_resampled-mean(pv_resampled);
                    names{end+1}=onlyname;
                end
            end
        end
    end
    pvs=pvs';
    save('pvs.mat','pvs');
    save('names.mat','names');
else
    load pvs;
    load names;
end