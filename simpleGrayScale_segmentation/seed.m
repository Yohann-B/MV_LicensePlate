function outputMatrix=seed(mySize, origo, option, radius)
    
    x = -((mySize/2)-1):((mySize/2)-1);
    y = -((mySize/2)-1):((mySize/2)-1);
    [xx yy] = meshgrid(x,y);
    outputMatrix = zeros(size(xx));
    
    limit1 = origo(1,1)-radius;
    limit2 = origo(1,1)+radius;
    if strcmp(option,'cross')
        outputMatrix(origo(1,1),limit1:limit2)=1;
        outputMatrix(limit1:limit2,origo(1,1))=1;
    end
    if strcmp(option, 'circle')
        outputMatrix((xx.^2+yy.^2)<radius^2)=1;        
    end