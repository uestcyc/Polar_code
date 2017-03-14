function [Pb, M]=get_punc_awgn_Pb(N,var,indeR)
%������������BEC�ŵ���Bhattacharyya����
%����Ϊ�ŵ�����N,BEC��������e
%���ΪBhattacharyya��������
load('phi_inv_in_out_chart.mat')
n=log2(N);
temp=zeros(1,N);
temp(indeR)=2/var;
for i=1:n
    for ii=1:2^(i-1)
        temp1(2*ii)=2*temp(ii);
        temp1(2*ii-1)=f2(temp(ii), phi_inv_in, phi_inv_out, length(phi_inv_in), phi_inv_out(1));
    end
    temp=temp1;
end
M=temp;
Pb=1-qfunc(sqrt(M./2)*(-1));

end