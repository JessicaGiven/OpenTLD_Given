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
%这一部分完全没看懂
function f = tldGenerateFeatures(nTREES, nFEAT, show)

SHI = 1/5;
SCA = 1;
OFF = SHI;

x = repmat(ntuples(0:SHI:1,0:SHI:1),2,1);
x = [x x + SHI/2];
k = size(x,2);
r = x; r(3,:) = r(3,:) + (SCA*rand(1,k)+OFF);
l = x; l(3,:) = l(3,:) - (SCA*rand(1,k)+OFF);
t = x; t(4,:) = t(4,:) - (SCA*rand(1,k)+OFF);
b = x; b(4,:) = b(4,:) + (SCA*rand(1,k)+OFF);

x = [r l t b];

idx = all(x([1 2],:) < 1 & x([1 2],:) > 0,1);
x = x(:,idx); %取前idx列
x(x > 1) = 1; %所有元素大于1取1
x(x < 0) = 0; %所有元素小于0 取0

numF = size(x,2); %取x列数

x = x(:,randperm(numF)); %以随机顺序取x前numF列
x = x(:,1:nFEAT*nTREES); %取x的前nFEAT*nTREES列
x = reshape(x,4*nFEAT,nTREES); %feature的最终结构是一个矩阵，4是单个蕨的特征数

f.x = x;
f.type = 'forest';

% show
if nargin == 3
if show
    for i = 1:nTREES
        F = 1+99*reshape(f.x(:,i),4,[]);
        img = zeros(100,100);
        imshow(img);
        
        line(F([1 3],:),F([2 4],:),'linewidth',1,'color','w');
        pause(.05);
    end
end
end