function  mymatlabtolatexRegularCompNewOutsideInside( view, index, file, titleoftable,  columns, rows, outside, inside )
    fileID = fopen(file,'w');
    numcols=2*size(view,2)-1;
    numcols2=size(view,2);
    
    numrows=size(view,1);
    fprintf(fileID,'%s \n','\begin{table}[htbp]\centering');
    fprintf(fileID,'%s \n','\scriptsize');
    
    fprintf(fileID,'%s \n','\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}');
    fprintf(fileID,'%s %s %s \n','\caption{',titleoftable,'\label{tab1}}');
    %fprintf(fileID,'%s %d %s \n','\begin{tabular}{l*{',numcols+1,'}{D{.}{.}{-1}}}');
    fprintf(fileID,'%s %d %s \n','\begin{tabular}{ll|ll|ll|r}');
    fprintf(fileID,'%s \n','\toprule');
    for i=1:1:(numcols+2)
        if (i<numcols+1)
            fprintf(fileID,'%s %s %s ','\multicolumn{1}{c}{',columns{1,i},'}&');
        end;
        if (i==numcols+1)
            fprintf(fileID,'%s %s %s ','\multicolumn{1}{c}{',columns{1,i},'}&');
        end;
        
    end;
    fprintf(fileID,'%s \n','\multicolumn{1}{c}{Outside Option}\\ ');
    
    fprintf(fileID,'%s \n','\midrule');
    for i=1:1:numrows
        
        for j=1:1:numcols2-1
            fprintf(fileID,'%s %s %s %s','\textrm{',rows{index(i,j),1},'}','&');
            fprintf(fileID,'%6.3f %s',view(i,j),'&');
            %if (j==1)
            %    fprintf(fileID,'%6.3f %s',inside(i,1),'&');
            %end;
            
        end;
        fprintf(fileID,'%s %s %s %s','\textrm{',rows{index(i,numcols2),1},'}','&');
        fprintf(fileID,'%6.3f %s ',view(i,numcols2),'&');
        fprintf(fileID,'%6.3f %s \n',outside(i,1),'\\');
       
        
    end;
    fprintf(fileID,'%s','\midrule');
    fprintf(fileID,'%s','\bottomrule');
    fprintf(fileID,'%s','\end{tabular}');
    fprintf(fileID,'%s','\end{table}');
    fclose(fileID);
    
    

end

