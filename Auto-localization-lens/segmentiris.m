% segmentiris - �ָ��Ĥ�����ͬʱ�������������򣬲��������ͽ�ë�����ڸ�
%
% ʹ�÷�����
% [circleiris, circlepupil, imagewithnoise] = segmentiris(image)
%
% ������
%	eyeimage		- ����ͼ��
%	
% �����
%	circleiris	    - ��Ĥ��Ե������������뾶
%	circlepupil	    - ͫ�ױ�Ե������������뾶 
%	imagewithnoise	- �������������λͼ��
%

function [circleiris, circlepupil, imagewithnoise] = segmentiris(eyeimage)

% ����ͫ�����Ĥ�뾶��Χ

%CASIA
lpupilradius = 20;
upupilradius = 60;
lirisradius = 80;
uirisradius = 150;


% �������ڼ���hough�任�ķ�������
scaling = 0.4;

reflecthres = 240;

% Ѱ�Һ�Ĥ�빮Ĥ��߽磬����Ĥ��߽�
[row, col, r] = findcircle(eyeimage, lirisradius, uirisradius, scaling, 2, 0.20, 0.15, 1.00, 0.00);

circleiris = [row col r];

rowd = double(row);
cold = double(col);
rd = double(r);

irl = round(rowd-rd);
iru = round(rowd+rd);
icl = round(cold-rd);
icu = round(cold+rd);

imgsize = size(eyeimage);

if irl < 1 
    irl = 1;
end

if icl < 1
    icl = 1;
end

if iru > imgsize(1)
    iru = imgsize(1);
end

if icu > imgsize(2)
    icu = imgsize(2);
end

% �ڸղ�̽��õ��ĺ�Ĥ������Ѱ��ͫ��
imagepupil = eyeimage( irl:iru,icl:icu);

%Ѱ��ͫ�ױ߽�
[rowp, colp, r] = findcircle(imagepupil, lpupilradius, upupilradius ,0.6,2,0.25,0.25,1.00,1.00);

rowp = double(rowp);
colp = double(colp);
r = double(r);

row = double(irl) + rowp;
col = double(icl) + colp;

row = round(row);
col = round(col);

circlepupil = [row col r];

%�������ڼ�¼������������飬�������ؾ߱�NaN����ֵ
imagewithnoise = double(eyeimage);

%Ѱ��������
topeyelid = imagepupil(1:(rowp-r),:);
lines = findline(topeyelid);

if size(lines,1) > 0
    [xl yl] = linecoords(lines, size(topeyelid));
    yl = double(yl) + irl-1;
    xl = double(xl) + icl-1;
    
    yla = max(yl);
    
    y2 = 1:yla;
    
    ind3 = sub2ind(size(eyeimage),yl,xl);  %
    imagewithnoise(ind3) = NaN;
    
    imagewithnoise(y2, xl) = NaN;
end

%Ѱ��������
bottomeyelid = imagepupil((rowp+r):size(imagepupil,1),:);
lines = findline(bottomeyelid);

if size(lines,1) > 0
    
    [xl yl] = linecoords(lines, size(bottomeyelid));
    yl = double(yl)+ irl+rowp+r-2;
    xl = double(xl) + icl-1;
    
    yla = min(yl);
    
    y2 = yla:size(eyeimage,1);
    
    ind4 = sub2ind(size(eyeimage),yl,xl);
    imagewithnoise(ind4) = NaN;
    imagewithnoise(y2, xl) = NaN;
    
end
%���ӽ�ë������
ref = eyeimage < 100;
coords = find(ref==1);
imagewithnoise(coords) = NaN;
