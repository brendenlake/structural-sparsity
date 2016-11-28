function G = setStyleColors(G)
    
    colorSize = 75;

    RGB = [ 0.4371         0    1.0000;
            0.3433         0    1.0000;
                 0    0.3425    1.0000;
                 0    0.5445    1.0000;
                 0    0.8255    0.7401;
                 0    0.9930    0.3840;
                 0    1.0000         0;
            0.5963    1.0000         0;
            1.0000    0.7727         0;
            1.0000    0.4384         0;
            1.0000    0.0403         0;
            1.0000         0         0;
            0.8170         0         0;
            0.4306         0         0  ];

    ncolor = size(RGB,1);

    for i=1:ncolor
       G = setGraphNodes(G,G.tag(i),...
           'size',colorSize,'color',RGB(i,:),'showLabel',false); 
    end
    
end