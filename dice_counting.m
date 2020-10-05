%program to count total dice and dots in each dice

function dice_counting(im)   
   %I = imread(im);
   I = imread('D:\RIT\CV\hw\hw5\TEST_IMAGES\img_6892__threes.jpg');                     %reading the image
   imshow(I);
   %fprintf("INPUT Filename: %s\n", im);
   
   if size(I, 1) > size(I, 2)                           %if image is tall and thin then rotate by 90 degree
       I = imrotate(I, 90);
   end
   im_r = I(:,:,1);                                     %convert to red channel so that company name on 'dice 1' goes away
   figure, imshow(im_r);
     
   im_r = medfilt2(im_r, [9 9]);                        %median filter with 9 by 9 neighborhood to remove noise
   figure, imshow(im_r);
   figure, imhist(im_r);
   
   %level = graythresh(im_r);
   %disp(level);
   BW = imbinarize(im_r, 0.7);                          %binarize image with given threshold    
   temp = BW;
   figure, imshow(BW);
   BW = imclearborder(BW);                            %suppress structures that are lighter than surroundings and 
                                                        %connected to the border
%  BW = bwareaopen(BW,200);
  
    [B,~] = bwboundaries(BW,'noholes');                    %B stores co-ordinates for boundaries(holes not included)
   hold on
   for k = 1:length(B)
       boundary = B{k};                                 %stores boundary values for a single object(according to value of k)
       plot(boundary(:,2), boundary(:,1), 'c', 'LineWidth', 2) % plots cyan colored boundary of width 2 for each dice
   end
   hold off;
   SE = strel('disk', 5);                               %structuring element(circle) with radius 5
   SE1 = strel('disk', 12);                            %structuring element(circle) with radius 12
   
   BW2 = imopen(BW,SE);                                 %does erosion and then dilation with SE
   figure, imshow(BW2);
   
   BW2 = imdilate(BW2,SE1);                             %does dilation with morphological structuring element specified
   figure, imshow(BW2);

   

   CC = bwconncomp(BW2);                                %finds connected component for image BW2
   store = CC;
   total_dices = CC.NumObjects;             
   fprintf("Number of Dice: %d\n", total_dices);        %displays total dices in image
   
   L = labelmatrix(CC);                                 %creates label matrix from connected component structure
   G = 1 - BW2;                                         %creates new image where 1's and 0's are replaced
                                                        %(explained in writeup)
   CC = bwconncomp(G);                          
   total_dots = CC.NumObjects - 1;                      %variable which stores total dots in image

   stats = regionprops(BW2, 'Image');                   %measures property 'Image' of image BW2

   one = 0; two = 0; three = 0; four = 0; five = 0; six = 0; unknown = 0;
   for dice = 1:total_dices
        CC = bwconncomp(1 - stats(dice).Image);         %finds connected component in each dice(i.e dots in every dice)        
        if CC.NumObjects - 4 == 1
            one = one + 1;
        elseif CC.NumObjects - 4 == 2
            two = two + 1;
        elseif CC.NumObjects - 4 == 3
            three = three + 1;
        elseif CC.NumObjects - 4 == 4                   %stores and increments values for each type of dice(one, two, three                   
            four = four + 1;                            % four, five, six, unknown(which is not recognized in any category))
        elseif CC.NumObjects - 4 == 5
            five = five + 1;
        elseif CC.NumObjects - 4 == 6
            six = six + 1;
        else
            unknown = unknown + 1;
        end
   end
   
   fprintf("Number of 1's: %d\n", one);
   fprintf("Number of 2's: %d\n", two);
   fprintf("Number of 3's: %d\n", three);
   fprintf("Number of 4's: %d\n", four);            %displays the count of how many dice are there for different dot values
   fprintf("Number of 5's: %d\n", five);
   fprintf("Number of 6's: %d\n", six);
   fprintf("Number of Unknown: %d\n", unknown);
   fprintf("Total of all dots: %d\n", total_dots);
end