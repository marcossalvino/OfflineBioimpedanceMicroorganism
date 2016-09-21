function out = myparsefile(fname)
% MYPARSEFILE lê e converte os arquivos .txt e troca a vírgula pelo ponto
    out = [];
    f = fopen(fname);
    while 1,
      lin = fgetl(f);
      if lin == -1, break; end
      lin = strrep(lin,',','.');
      lin = sscanf(lin,'%f');
      out = [out lin];
    end
    fclose(f);
end
