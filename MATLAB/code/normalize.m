function [im_norm] = normalize (im, par_vektor, ver)

if nargin < 3, ver = 2; end;

im_norm = zeros(size(im));
m_dim1 = par_vektor(1);
m_dim2 = par_vektor(2);
exp_dim1 = par_vektor(3);
exp_dim2 = par_vektor(4);
sl_dim1 = par_vektor(5);
sl_dim2 = par_vektor(6);

% Normalize image with par.-vektor:
% using par_names = str2mat('center dim1', 'center dim2', 'exp dim1', 'exp dim2', 'slope dim1', 'slope dim2');  
% im_norm(x,y) = im(x,y) + sd2(x-cd2)^ed2+ sd1(y-cd1)^ed1

if ver == 1 % too slow:
    for i=1:size(im,1)
        for j=1:size(im,2)
            im_norm(i,j) = im(i,j) + sl_dim1*abs(i-m_dim1)^exp_dim1 + sl_dim2*abs(j-m_dim2)^exp_dim2;
        end;
    end;

else
    t = ones(size(im,1),1)*(sl_dim2*(abs([1:size(im,2)]-m_dim2).^exp_dim2));
    v = (sl_dim1*(abs([1:size(im,1)]'-m_dim1).^exp_dim1))*ones(1,size(im,2));

    im_norm = im + t + v;
end;