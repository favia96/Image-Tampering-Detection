function get_map(imagePath)
    %   Written by
	%   Kamil Rzechowski
    %   Federico Favia
    %   Martin De Pellegrini
    %   UNIVERSITY OF TRENTO
    %   TRENTO, 2018
    
    dim1 = 1500;
    dim2 = 2000;

    finalMap = zeros(dim1,dim2);
    OutMapDir = 'DEMO_RESULTS'; %directory where to save correlation maps

    if(contains(imagePath,'.tif'))
        finalMap = tifAnalyse(imagePath, dim1, dim2);         
    elseif (contains(imagePath,'.jpg'))
        finalMap = jpegAnalyse(imagePath);
    else
        disp('Wrong image extention');
    end
    
    mfilename;
    mfilename('fullpath'); 

    % SAVING THE CORRELATION Map  
    splitedPathName = strsplit(which(mfilename),'\');
    currentFolder = '';
    
    for i =1:1:length(splitedPathName)-1
        currentFolder = fullfile(currentFolder,splitedPathName(i));
    end
    strTemp = char(splitedPathName(length(splitedPathName)));
    splitExtention = strsplit(strTemp,'.');
    
    %get file name
    splitedPathName1 = strsplit(imagePath,'\');
    splitExtention2 = strsplit(char(splitedPathName1(length(splitedPathName1))),'.');
    
    fileName = strcat(splitExtention2(1),'.bmp');
    baseFileName = fullfile(currentFolder,OutMapDir);
    fullFileName = fullfile(baseFileName,fileName);
    
    try
        mkdir(OutMapDir);
    catch
        display('Cant create the folder "DEMO_RESULTS". The folder might exist already');
    end
    
    imwrite(finalMap, char(fullFileName));
end



