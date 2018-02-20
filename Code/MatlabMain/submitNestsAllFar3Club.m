

JOBS = 1;


for j=1:JOBS
    pbsfname = sprintf('sub_NestsAllFar3Club_%03d', j);
    pbsf = fopen(pbsfname, 'w');
    
    fprintf(pbsf, '#PBS -j oe \n#PBS -l nodes=1:ppn=1\n');
    fprintf(pbsf, '#PBS -l mem=20g\n');
    fprintf(pbsf, '#PBS -l walltime=120:00:00\n');
    fprintf(pbsf, '#PBS -q lionxf-econ\n');
    fprintf(pbsf, 'module load matlab/R2013a\nmodule load knitro/9.0.1\n\n');
    fprintf(pbsf, 'cd %s\n', pwd);
    
    fprintf(pbsf,'matlab -nodisplay<<MRUN\n');
    fprintf(pbsf, 'mainNestsPointsAllFar3Club(%d)\n', j);
    fprintf(pbsf, 'MRUN\n');
    
    fclose(pbsf);
    
    unix(sprintf('qsub -m ae %s', pbsfname));
    %disp(sprintf('qsub -m ae %s', pbsfname));
    
end

