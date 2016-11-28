% Save the current figure as a pdf
% with the name: fname
function pdf_gcf(fname)

    f = gcf;
   
    set(f,'PaperUnits','inches');
    papersize = [26 20];
    set(f,'PaperSize',papersize);    
    set(gcf, 'PaperPositionMode', 'auto');
    print(f,'-dpdf',fname);

end