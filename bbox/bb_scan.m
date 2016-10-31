% Copyright 2011 Zdenek Kalal
%
% This file is part of TLD.
% 
% TLD is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% TLD is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with TLD.  If not, see <http://www.gnu.org/licenses/>.

%扫描网格初始化函数

%输入参数：
%bb 目标标定框
%imsize 输入图像尺寸
%min_win 标定框的长、宽最小尺寸

%输出参数：
%bb_out 一个6xn的矩阵（n表示在当前有效尺度下共有多少个网格，前四行组成的列向量表示网格的四个顶点，第5行表示索引，第6行表示横向的分布点数）
%sca 有效尺度下网格的长宽，为2xm的矩阵（m为有效尺度的个数）

function [bb_out,sca] = bb_scan(bb, imsize,min_win)

SHIFT = 0.1;
SCALE = 1.2.^[-10:10];
MINBB = min_win;

% Check if input bbox is smaller than minimum
if min(bb_size(bb)) < MINBB
    bb_out = [];
    sca    = [];
    return;
end

bbW   = round(bb_width(bb) .* SCALE);   %对目标标定框进行尺度变换
bbH   = round(bb_height(bb) .* SCALE);
bbSHH = SHIFT * min(bbH,bbH);   %取bbW和bbH中的最小元素组成新的矩阵，表示变形之后目标标定框的移动步长
bbSHW = SHIFT * min(bbH,bbW);

bbF   = [2 2 imsize(2) imsize(1)]';

bbs = {};
sca = [];
idx = 1;

for i = 1:length(SCALE)
    if bbW(i) < MINBB || bbH(i) < MINBB, continue; end
    
    left  = round(bbF(1):bbSHW(i):bbF(3)-bbW(i)-1);
    top   = round(bbF(2):bbSHH(i):bbF(4)-bbH(i)-1);
    
    grid  = ntuples(top,left);
    if isempty(grid), continue; end
    
    bbs{end+1} =  [grid(2,:); ...
        grid(1,:); ...
        grid(2,:)+bbW(i)-1; ...
        grid(1,:)+bbH(i)-1; ...
        idx*ones(1,size(grid,2));
        length(left)*ones(1,size(grid,2));];
    sca  = [sca [bbH(i); bbW(i)]];
    idx = idx + 1;
end
bb_out = [];
for i = 1:length(bbs)
    bb_out = [bb_out bbs{i}];
end

% for i = 1:length(bbs)
%     
%     if i-1 > 0
%         idx = bb_overlap(bbs{i},bbs{i-1},2);
%         bbs{i}(7,:) = idx;
%     end
%     
%     if i+1 <= length(bbs)
%         idx = bb_overlap(bbs{i},bbs{i+1},2);
%         bbs{i}(8,:) = idx;
%     end
%     
% end
% disp(['MINBB: ' num2str(MINBB) ', bb: ' num2str(size(bbs,2))]);
% end


