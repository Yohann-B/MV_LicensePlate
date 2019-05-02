function outputHist= histogram (inputIm)
    
    outputHist = [1:256];
    r = size(inputIm,1);
    c = size(inputIm,2);
    
    for i = 1:r
        for j = 1:c
            outputHist(inputIm(i,j)+1) = outputHist(inputIm(i,j)+1)+1;
        end
    end
end

