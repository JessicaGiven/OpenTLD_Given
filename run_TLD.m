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

addpath(genpath('.')); init_workspace; 

opt.source          = struct('camera',0,'input','_input/','bb0',[]); % camera/directory swith, directory_name, initial_bounding_box (if empty, it will be selected by the user) 指定输入源
opt.output          = '_output/'; mkdir(opt.output); % output directory that will contain bounding boxes + confidence 指定输出路径

min_win             = 24; % minimal size of the object's bounding box in the scanning grid, it may significantly influence speed of TLD, set it to minimal size of the object 指定目标框的最小尺寸，有助于提高算法性能
patchsize           = [15 15]; % size of normalized patch in the object detector, larger sizes increase discriminability, must be square 归一化片的尺寸，越大分类效果越好，必须是正方形
fliplr              = 0; % if set to one, the model automatically learns mirrored version s of the object 自动学习镜像目标？
maxbbox             = 1; % fraction of evaluated bounding boxes in every frame, maxbox = 0 means detector is truned off, if you don't care about speed set it to 1 每一帧应用的目标框
update_detector     = 1; % online learning on/off, of 0 detector is trained only in the first frame and then remains fixed 在线学习开关
opt.plot            = struct('pex',1,'nex',1,'dt',1,'confidence',1,'target',1,'replace',0,'drawoutput',3,'draw',0,'pts',1,'help', 0,'patch_rescale',1,'save',0); 

% Do-not-change -----------------------------------------------------------

opt.model           = struct('min_win',min_win,'patchsize',patchsize,'fliplr',fliplr,'ncc_thesame',0.95,'valid',0.5,'num_trees',10,'num_features',13,'thr_fern',0.5,'thr_nn',0.65,'thr_nn_valid',0.7);
opt.p_par_init      = struct('num_closest',10,'num_warps',20,'noise',5,'angle',20,'shift',0.02,'scale',0.02); % synthesis of positive examples during initialization 汇总初始化时的正样本
opt.p_par_update    = struct('num_closest',10,'num_warps',10,'noise',5,'angle',10,'shift',0.02,'scale',0.02); % synthesis of positive examples during update 汇总更新时的正样本
opt.n_par           = struct('overlap',0.2,'num_patches',100); % negative examples initialization/update 初始化和更新时的负样本
opt.tracker         = struct('occlusion',10);
opt.control         = struct('maxbbox',maxbbox,'update_detector',update_detector,'drop_img',1,'repeat',1);

        
% Run TLD -----------------------------------------------------------------
%profile on;
[bb,conf] = tldExample(opt);    %运行TLD
%profile off;
%profile viewer;

% Save results ------------------------------------------------------------
dlmwrite([opt.output '/tld.txt'],[bb; conf]');
disp('Results saved to ./_output.'); %显示结果