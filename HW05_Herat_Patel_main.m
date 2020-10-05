function show_all_files_in_dir()
    file_list = dir('../TEST_IMAGES/*.jpg');                       %stores every image with extension .jpg
    
    for counter = 1 : length(file_list)
       im = file_list(counter).name;                %name of the image
       fprintf("file %3d = %s\n", counter, im);     
       dice_counting(im);                           %calls the dice_counting function with image as parameter
    end                                             %each image in the directory will be run one by one
end