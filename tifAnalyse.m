function [ tamperMap ] = tifAnalyse(imagePath, dim1, dim2)

    noCameras = 4;

    load('PRNUs_wholeimage.mat');

    % ----- VARIABLES -----
    block_size1 = 128;
    block_size2 = 128;
    step = 16;

    I = zeros(dim1+block_size1,dim2+block_size2);
    K = zeros(dim1+block_size1,dim2+block_size2,noCameras);
    Wk = zeros(dim1+block_size1,dim2+block_size2);
    Ik = zeros(dim1+block_size1,dim2+block_size2);

    Ib = zeros(block_size1,block_size2); %block of the image
    Kb = zeros(block_size1,block_size2); %block of the PRNU
    Wb = zeros(block_size1,block_size2); %block of residual

    corrSet = zeros(1, noCameras);
    
    Map = zeros(dim1+block_size1,dim2+block_size2);
    finalMap1 = zeros(dim1,dim2);
    
    tempImage = imread(imagePath); %loading the image
    disp(['Processing image ' imagePath]);

    % preprocessing
    I(1:dim1,1:dim2) = tempImage(:,:,2);
    Ik(1:dim1,1:dim2) = wiener2(I(1:dim1,1:dim2),[5 5]); 
    Wk(1:dim1,1:dim2) = I(1:dim1,1:dim2)-Ik(1:dim1,1:dim2); %HERE I HAVE THE RESIDUAL OF THE IMAGE i
    
    K(1:dim1,1:dim2,:) = PRNUs(:,:,:);

    for x = 1:noCameras % ----- FIND THE HIGHEST CORRELATED PRNU -----
        %COMPUTING THE CORRELATION 
        correlation = corr2(I(:,:).*K(:,:,x),Wk(:,:));
        corrSet(1,x) = correlation;
    end
    [~, index] = find(ismember(corrSet, max(corrSet(:))));

    %here we have found the index corresponding to the better PRNU matched
    for k = 1 : step : dim1 %- block_size1 %
        for j = 1 : step : dim2 %- block_size2 %
            Ib(:,:) = I(k:k+block_size1-1, j:j+block_size2-1);
            Wb(:,:) = Wk(k:k+block_size1-1, j:j+block_size2-1);
            Kb(:,:) = K(k:k+block_size1-1, j:j+block_size2-1,index); %insert max prnu for that image

            %correlation 2
            correlation = corr2(Ib(:,:).*Kb(:,:),Wb(:,:));

            %correlation map
            Map(k:k+step,j:j+step) = correlation; %best results with groups of pixel with which you slide
                                                   %not with windows analysis of 128x127
        end
     end
     finalMap1(:,:) = Map(1:dim1,1:dim2);
     finalMap1 = imgaussfilt(finalMap1,3);

     Map_bin = imbinarize(finalMap1); %binarize
     Map_bin = imcomplement(Map_bin); %complementary
     se = strel('disk',16);
     Map_bin = imopen(Map_bin,se);
     tamperMap = imerode(Map_bin,se);
end