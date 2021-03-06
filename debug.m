image_file = '~/Documents/Research/20140701/2014-04-02_BSA_flowcell_2_Pluronic_RT_exp200ms_l10_EM200_2_cut.tif';
trajall = Result.Trajectory;
traj_ind = 648;

traj = trajall(traj_ind).trajectory;
frame_appear = Molecule(traj(1)).frame;
frame_disappear = Molecule(traj(end)).frame;
info = imfinfo(image_file);
n_images = numel(info);
[pathstr,~,~] = fileparts(image_file);

for i = 1:9
    im = imread(image_file,i);
    RGB = repmat(im,[1,1,3]);
    % normalize data to dynamic range [0,1]
    RGB = double(RGB)/16384;
    if i == 1
        ofile_name = fullfile(pathstr,(strcat('Trajectory_',num2str(traj_ind),...
            '.tiff')));
        imwrite(RGB,ofile_name);
    else
        ofile_name = fullfile(pathstr,(strcat('Trajectory_',num2str(traj_ind),...
            '.tiff')));
        imwrite(RGB,ofile_name,'WriteMode','append');
    end
end

j = 1;

for i = frame_appear:frame_disappear
    im = imread(image_file,i);
    % locate 'point'
    pt = Molecule(traj(j)).coordinate(1:2);
    pt = int32(pt);
    marker_intensity = round(max(im(:)));   %%%%%%
    RGB = repmat(im,[1,1,3]);   %%%%%%%
    RGB(pt(1)-2:pt(1)+2,pt(2),1) = 0;
    RGB(pt(1)-2:pt(1)+2,pt(2),2) = marker_intensity;
    RGB(pt(1)-2:pt(1)+2,pt(2),3) = 0;
    RGB(pt(1),pt(2)-2:pt(2)+2,1) = 0;
    RGB(pt(1),pt(2)-2:pt(2)+2,2) = marker_intensity;
    RGB(pt(1),pt(2)-2:pt(2)+2,3) = 0;
    RGB = double(RGB)/16384;
    ofile_name = fullfile(pathstr,(strcat('Trajectory_',num2str(traj_ind),...
            '_',num2str(i),'.tiff')));
    imwrite(RGB,ofile_name);
    j = j + 1;
end

for i = (frame_disappear+1):n_images
    im = imread(image_file,i);
    RGB = repmat(im,[1,1,3]);
    RGB = double(RGB)/16384;
    ofile_name = fullfile(pathstr,(strcat('Trajectory_',num2str(traj_ind),...
            '_',num2str(i),'.tiff')));
    imwrite(RGB,ofile_name);
end