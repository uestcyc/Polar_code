function p=W(y,x,var)
%�����ŵ�ת�Ƹ��ʺ���W(y|x)
p=1/sqrt(2*pi*var)*exp(-(y-(2*x-1)).^2/(2*var));