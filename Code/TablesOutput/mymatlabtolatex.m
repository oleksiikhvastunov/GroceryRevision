function  mymatlabtolatex( view, file, titleoftable,  columns, rows )
    fileID = fopen(file,'w');
    numcols=size(view,2);
    numrows=size(view{1,1},1);
    fprintf(fileID,'%s \n','\begin{table}[htbp]\centering');
    fprintf(fileID,'%s \n','\scriptsize');
    
    fprintf(fileID,'%s \n','\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}');
    fprintf(fileID,'%s %s %s \n','\caption{',titleoftable,'\label{tab1}}');
    fprintf(fileID,'%s %d %s \n','\begin{tabular}{l*{',numcols,'}{D{.}{.}{-1}}}');
    fprintf(fileID,'%s \n','\toprule');
    for i=1:1:(numcols+1)
        if (i<numcols+1)
            fprintf(fileID,'%s %s %s ','\multicolumn{1}{c}{',columns{1,i},'}&');
        end;
        if (i==numcols+1)
            fprintf(fileID,'%s %s %s \n','\multicolumn{1}{c}{',columns{1,i},'}\\');
        end;
    end;
    fprintf(fileID,'%s \n','\midrule');
    for i=1:1:numrows
        fprintf(fileID,'%s %s',rows{i,1},'&');
        for j=1:1:numcols-1
            fprintf(fileID,'%6.3f %s',view{1,j}(i,1),'&');
        end;
        fprintf(fileID,'%6.3f %s \n',view{1,numcols}(i,1),'\\');
        fprintf(fileID,'%s ','&');
        for j=1:1:numcols-1
            fprintf(fileID,'%s %6.3f %s','(',view{1,j}(i,2),')&');
        end;
        fprintf(fileID,'%s %6.3f %s \n','(',view{1,numcols}(i,2),')\\');
        
    end;
    fprintf(fileID,'%s','\midrule');
    fprintf(fileID,'%s','\bottomrule');
    fprintf(fileID,'%s','\end{tabular}');
    fprintf(fileID,'%s','\end{table}');
    fclose(fileID);
    
    

end

