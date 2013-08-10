function dets = detect_gray_square(img_path, show_figure)
    if (nargin < 1) 
        img_path = 'sample-mask.jpg';
    end
    if (nargin < 2)
        show_figure = 1;
    end

    value = 128;
    value = repmat(value(1), [1,1,3]);       

    margin = 0.1;
    
    img = imread(img_path);
    img = double(img);
    errs = abs(bsxfun(@minus, img, value))./3;
    mask = (errs(:,:,1) <= margin & errs(:,:,2) <= margin & errs(:,:,3) <= margin);
    
    h = fspecial('gaussian', 5, 1);
    mask = imfilter(double(mask), h);
    
    se = strel('disk',5);
    mask = imopen(mask, se);
    [ccl,n] = bwlabel(mask,4);
    dets = [];
    for i=1:n
        tmp = ccl == i;
        [y,x] = find(tmp > 0);
        size_x = max(x) - min(x);
        size_y = max(y) - min(y);
        if (size_x * size_y > 5)
            dets = [dets;min(x) max(x) min(y) max(y)];
        end
    end
    
    if (show_figure)
        figure(1);
        imshow(img/255.0);
        hold on;
        cm = colormap(hsv(size(dets,1)));
        for i=1:size(dets,1)        
            [x,y] = meshgrid(dets(i,1):dets(i,2), dets(i,3):dets(i,4));
            plot(x(:),y(:),'Color',cm(i,:));
        end
        axis([0 size(img,2) 0 size(img,1)]);
        pause
    end
end

