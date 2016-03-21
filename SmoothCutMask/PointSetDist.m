function [ P_dist ] = PointSetDist( Set_mat, max_dist )
%POINTSETDIST Find the distance from a point to a set. We use Euclidean
%distance (l2 distance) here.
%
%Input:
%   Set_mat:
%       Logical Matrix. Indicate the position of the set of points. The
%       point value set to be true if it is in the set. Otherwise, set to
%       false.
%   max_dist:
%       Maximum distance to consider. If the point is max_dist farther from
%       the set, set the value to be inf.
%Output:
%   P_dist:
%       Matrix of the same size as Set_mat. Output the distance of the
%       points to the set. If the point is in the set, ouptut 0. If the
%       point is more than max_dist farther to the set, output max_dist.
%
%   Chenzhe
%   Feb, 2016
%

Set_mat = logical(Set_mat);
P_dist = double(Set_mat);

% Construct a distance matrix
tmp = -max_dist:max_dist;
dist1 = repmat(tmp, 2*max_dist+1, 1);
dist1 = dist1.^2;
dist2 = dist1';
dist_mat = sqrt(dist1 + dist2);


[M, N] = size(Set_mat);
for i = 1:M
    for j = 1:N
        if Set_mat(i,j)==true   % if the point is in the set
            P_dist(i,j) = 0;
            continue;
        end
        % Cut the Set_mat
        d1_min = max(1, i-max_dist);
        d2_min = max(1, j-max_dist);
        d1_max = min(M, i+max_dist);
        d2_max = min(N, j+max_dist);
        logic_mat_cut = Set_mat(d1_min:d1_max, d2_min:d2_max);
        if any(logic_mat_cut(:))==false   % The neighbourhood intersects the set is null, the point is far away from the set
            P_dist(i,j) = max_dist;
            continue;
        end
        
        % Cut the dist_mat
        d1_min = max_dist - (i-d1_min) +1;
        d2_min = max_dist - (j-d2_min) +1;
        d1_max = max_dist + 1 + (d1_max-i);
        d2_max = max_dist + 1 + (d2_max-j);
        dist_mat_cut = dist_mat(d1_min:d1_max, d2_min:d2_max);
        
        P_dist(i,j) = min(dist_mat_cut(logic_mat_cut));
        
    end
end

P_dist(P_dist>max_dist) = max_dist;







end

