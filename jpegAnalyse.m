function [ tamperMap ] = jpegAnalyse(imagePath)
    disp(['Processing image ' imagePath]);
    
    im = imread(imagePath);
    OutputMap = GetDCTArtifact(im);

    normA = OutputMap - min(OutputMap(:));
    normA = normA ./ max(normA(:));
    [counts,binLocations] = imhist(normA);
    %histogram(normA);

    [max_num, max_idx]=max(counts(:));
    threshold_idx = 0;
    for i = length(counts):-1:1
        if(counts(i)>max_num*0.033)
            threshold_idx = i;
            break;
        end
    end
    thresh = binLocations(threshold_idx);
    A = OutputMap;
    A(normA>thresh) = 1;
    A(normA<=thresh) = 0;
    A1 = imclose(A,strel('disk',5));
    A2 = imopen(A1,strel('disk',3));
    A3 = imclose(A2,strel('disk',20));
    A4 = imresize(A3,[1500 2000]);
    out = imfill(A4);

    thresh2 = graythresh(out); %global image threshold using Otsu's method
    tamperMap = imbinarize(out,thresh2); %binarize
end