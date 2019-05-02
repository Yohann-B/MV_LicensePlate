function outputIm = selectThresholdIm(inputIm,th1,th2)
    r=size(inputIm,1);
    c=size(inputIm,2);
    outputIm=zeros(r,c);
    
    for i=1:r
        for j=1:c
            if (inputIm(i,j) >= th1) && (inputIm(i,j) <= th2)
                outputIm(i,j)=255;
            else
                outputIm(i,j)=0;
            end
        end
    end
end

    