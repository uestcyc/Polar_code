function Z=get_bec_bhattacharyya(N,e)
%������������BEC�ŵ���Bhattacharyya����
%����Ϊ�ŵ�����N,BEC��������e
%���ΪBhattacharyya��������

n=log2(N);
temp=e;
for i=1:n
    for ii=1:2^(i-1)
        temp1(2*ii-1)=2*temp(ii)-temp(ii)*temp(ii);
        temp1(2*ii)=temp(ii)*temp(ii);
    end
    temp=temp1;
end

Z=temp;

end