function [ Group ] = FBGroup( obj_ffbindex )
%FBGROUP Group the freqfilter2d filter bank.
%
%
%   Chenzhe
%   Mar, 2016
%

alpha = 0.1;
ffb2d = obj_ffbindex.fb2d;

iG = 1;
while true
    
    filterleft = obj_ffbindex.IndexMatrix(obj_ffbindex.MarkMatrix); % contains all the lindex of the filters left
    if isempty(filterleft)  % no filters left
        break;
    end
    
    Group{iG} = [];
    
    nleft = length(filterleft);
    E = zeros(1, nleft);
    for i = 1:nleft
        E(i) = ffb2d(filterleft(i)).EnergyPortion;
    end
    [Emax, ind] = max(E);
    lindex = filterleft(ind);
    
    while length(Group{iG})<=3 % we need lindex to get into this loop
        % Step 1, add the filter (lindex) into the group
        Group{iG} = [Group{iG}, lindex];      % add to group
        cindex = ffb2d(lindex).index;
        [ii, jj] = obj_ffbindex.cindex2index2d(cindex);
        obj_ffbindex.MarkMatrix(ii, jj) = false;    % remove from filter bank
        
        % Step 2, find all neighbours' lindices of the group
        NB = obj_ffbindex.FindNeighbourGroup(Group{iG});
        
        % Step 3, loop over all neighbours, find the largest energy
        nNB = length(NB);
        if nNB>0
            E = zeros(1, nNB);
            for iNB = 1:nNB
                lindex = NB(iNB);
                E(iNB) = ffb2d(lindex).EnergyPortion;
            end
        else    % no more neighbours, start a new group
            break;
        end
        [Enbmax, Inbmax] = max(E);
        if Enbmax > alpha*Emax  % add this neighbour to group, continue to add more in this group
            lindex = NB(Inbmax);
            continue;
        else    % start a new group
            break;
        end
    end
    
    iG = iG + 1;
    
end

end

